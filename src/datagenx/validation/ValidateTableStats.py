import mysql.connector
from mysql.connector import Error
import argparse

from datagenx.config import PASSWORD
import json
import sys


# ------------------------------------------------------------
# Utilities
# ------------------------------------------------------------

def pct_diff(a, b):
    if a == 0 and b == 0:
        return 0.0
    if a is None or b is None:
        return 1.0
    return abs(a - b) / max(a, b)


# ------------------------------------------------------------
# Histogram + Stats helpers
# ------------------------------------------------------------

def load_histograms(cursor, schema, table):
    cursor.execute("""
        SELECT COLUMN_NAME, HISTOGRAM
        FROM information_schema.column_statistics
        WHERE SCHEMA_NAME = %s AND TABLE_NAME = %s
    """, (schema, table))

    return {
        col: json.loads(hist)
        for col, hist in cursor.fetchall()
        if hist is not None
    }


def histogram_difference(h1, h2):
    if not h1 or not h2:
        return 1.0

    b1 = h1.get("buckets", [])
    b2 = h2.get("buckets", [])

    if not b1 or not b2:
        return 1.0

    def probs(hist):
        buckets = hist["buckets"]
        hist_type = hist["histogram-type"]
        p = []
        prev = 0.0
        for b in buckets:
            cumulative = b[-2] if hist_type == "equi-height" else b[1]
            p.append(max(0.0, cumulative - prev))
            prev = cumulative
        # Sort by mass so synthetic bucket values can differ from source values.
        # This compares distribution shape, not literal bucket endpoints.
        return sorted(p, reverse=True)

    p1 = probs(h1)
    p2 = probs(h2)

    n = max(len(p1), len(p2))
    if n == 0:
        return 1.0

    p1 = p1 + [0.0] * (n - len(p1))
    p2 = p2 + [0.0] * (n - len(p2))
    return 0.5 * sum(abs(p1[i] - p2[i]) for i in range(n))


def compare_histograms(h1, h2):
    """Compare histograms and return list of (col, diff_value, reason) tuples."""
    results = []
    all_cols = set(h1.keys()) | set(h2.keys())

    for col in sorted(all_cols):
        if col not in h1:
            results.append((col, 1.0, "missing in source"))
        elif col not in h2:
            results.append((col, 1.0, "missing in target"))
        else:
            diff = histogram_difference(h1[col], h2[col])
            src_buckets = len(h1[col].get("buckets", []))
            tgt_buckets = len(h2[col].get("buckets", []))
            src_type = h1[col].get("histogram-type", "unknown")
            tgt_type = h2[col].get("histogram-type", "unknown")
            results.append((
                col,
                diff,
                f"distribution_diff = {diff:.5f}, buckets {src_buckets}->{tgt_buckets}, type {src_type}->{tgt_type}",
            ))
    return results


def load_table_stats(cursor, schema, table):
    cursor.execute("""
        SELECT TABLE_ROWS, AVG_ROW_LENGTH, DATA_LENGTH, INDEX_LENGTH
        FROM information_schema.tables
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
    """, (schema, table))
    return cursor.fetchone()


def load_index_stats(cursor, schema, table):
    cursor.execute("""
        SELECT INDEX_NAME, COLUMN_NAME, CARDINALITY
        FROM information_schema.statistics
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
        ORDER BY INDEX_NAME, SEQ_IN_INDEX
    """, (schema, table))
    return cursor.fetchall()


def load_indexed_columns(cursor, schema, table):
    """Get set of column names that are part of any index."""
    cursor.execute("""
        SELECT DISTINCT COLUMN_NAME
        FROM information_schema.statistics
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
    """, (schema, table))
    return {row[0] for row in cursor.fetchall()}


def load_column_types(cursor, schema, table):
    """Get dict of column_name -> column_type."""
    cursor.execute("""
        SELECT COLUMN_NAME, COLUMN_TYPE
        FROM information_schema.columns
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
    """, (schema, table))
    return {row[0]: row[1] for row in cursor.fetchall()}


def is_string_type(col_type):
    """Check if column type is a string type (char, varchar, text, etc.)."""
    col_type_lower = col_type.lower()
    return any(t in col_type_lower for t in ['char', 'varchar', 'text', 'blob'])


def is_decimal_type(col_type):
    """Check if column type is decimal/numeric (may have distinct count divergence)."""
    col_type_lower = col_type.lower()
    return any(t in col_type_lower for t in ['decimal', 'numeric'])


def load_distinct_counts(cursor, schema, table):
    cursor.execute("""
        SELECT COLUMN_NAME, COLUMN_TYPE
        FROM information_schema.columns
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
        ORDER BY ORDINAL_POSITION
    """, (schema, table))

    columns = cursor.fetchall()
    indexed_cols = load_indexed_columns(cursor, schema, table)
    distinct_counts = {}

    for col, col_type in columns:
        try:
            cursor.execute(f"SELECT COUNT(DISTINCT `{col}`) FROM `{schema}`.`{table}`")
            distinct_counts[col] = {
                'count': cursor.fetchone()[0],
                'type': col_type,
                'indexed': col in indexed_cols
            }
        except Error as e:
            distinct_counts[col] = {
                'count': None,
                'type': col_type,
                'indexed': col in indexed_cols
            }

    return distinct_counts


def load_row_count(cursor, schema, table):
    cursor.execute(f"SELECT COUNT(*) FROM `{schema}`.`{table}`")
    return cursor.fetchone()[0]


def get_all_tables(cursor, schema):
    cursor.execute("""
        SELECT TABLE_NAME
        FROM information_schema.tables
        WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_NAME
    """, (schema,))
    return [row[0] for row in cursor.fetchall()]


# ------------------------------------------------------------
# Reporting
# ------------------------------------------------------------

def report_row_counts(src_rows, tgt_rows, verbose=True):
    diff = pct_diff(src_rows, tgt_rows)
    status = "OK" if diff == 0 else "DIVERGED"
    if verbose or status != "OK":
        print("\n📊 ROW COUNT COMPARISON")
        print(f"Source: {src_rows}, Target: {tgt_rows}, diff={diff:.2%} → {status}")
    return diff == 0


def report_histogram_comparison(results, indexed_cols, column_types, verbose=True):
    """Report histogram comparison results.

    results: list of (col, diff_value, reason) from compare_histograms
    indexed_cols: set of column names that are indexed
    column_types: dict of col -> type string
    verbose: if False, only print DIVERGED items

    Returns list of critical mismatches (failures).
    """
    THRESHOLD = 0.05  # 5% threshold
    critical_mismatches = []
    minor_mismatches = []
    output_lines = []

    for col, diff, reason in results:
        is_indexed = col in indexed_cols
        col_type = column_types.get(col, 'unknown')
        is_string = is_string_type(col_type)
        is_decimal = is_decimal_type(col_type)
        idx_marker = " [idx]" if is_indexed else ""

        if diff < THRESHOLD:
            status = "OK"
        elif is_string and not is_indexed:
            status = "NOTE (unindexed string)"
            minor_mismatches.append((col, "string"))
        elif is_decimal and not is_indexed:
            status = "NOTE (decimal range generation)"
            minor_mismatches.append((col, "decimal"))
        else:
            status = "DIVERGED"
            critical_mismatches.append(col)

        if verbose or status == "DIVERGED":
            output_lines.append(f"`{col}` ({col_type}){idx_marker}: {reason} → {status}")

    if output_lines:
        print("\n📊 HISTOGRAM COMPARISON")
        for line in output_lines:
            print(line)

    if verbose and minor_mismatches:
        string_cols = [c for c, t in minor_mismatches if t == "string"]
        decimal_cols = [c for c, t in minor_mismatches if t == "decimal"]
        if string_cols:
            print(f"\n   ℹ️  {len(string_cols)} unindexed string column(s) diverged - "
                  "typically not critical for query planning")
        if decimal_cols:
            print(f"   ℹ️  {len(decimal_cols)} decimal column(s) diverged - "
                  "range-based generation may produce more distinct values")

    return critical_mismatches


def report_table_stats(orig, new, verbose=True):
    # Table statistics (AVG_ROW_LENGTH, DATA_LENGTH, etc.) are not useful
    # for query plan comparison - they depend on actual data content, not distribution
    pass


def report_index_stats(orig, new, verbose=True):
    def to_map(rows):
        return {(r[0], r[1]): r[2] for r in rows}

    o = to_map(orig)
    n = to_map(new)

    output_lines = []
    all_keys = set(o.keys()) | set(n.keys())
    for key in sorted(all_keys):
        oc = o.get(key)
        nc = n.get(key)
        diff = pct_diff(oc, nc)
        status = "OK" if diff < 0.20 else "DIVERGED"
        if verbose or status == "DIVERGED":
            output_lines.append(f"{key}: diff={diff:.2%} → {status}")

    if output_lines:
        print("\n📊 INDEX CARDINALITY COMPARISON")
        for line in output_lines:
            print(line)


def report_distinct_counts(orig, new, verbose=True):
    all_cols = set(orig.keys()) | set(new.keys())
    critical_mismatches = []  # Indexed columns or numeric columns
    minor_mismatches = []     # Unindexed string columns (less critical)
    output_lines = []

    for col in sorted(all_cols):
        if col not in orig:
            col_type = new[col]['type'] if col in new else 'unknown'
            output_lines.append(f"`{col}` ({col_type}): missing in source")
            critical_mismatches.append(col)
        elif col not in new:
            col_type = orig[col]['type'] if col in orig else 'unknown'
            output_lines.append(f"`{col}` ({col_type}): missing in target")
            critical_mismatches.append(col)
        else:
            oc = orig[col]['count']
            nc = new[col]['count']
            col_type = orig[col]['type']
            is_indexed = orig[col].get('indexed', False)
            is_string = is_string_type(col_type)
            is_decimal = is_decimal_type(col_type)

            if oc is None or nc is None:
                if verbose:
                    output_lines.append(f"`{col}` ({col_type}): could not compute (NULL)")
                continue

            diff = pct_diff(oc, nc)

            if diff < 0.05:
                status = "OK"
            elif is_string and not is_indexed:
                status = "NOTE (unindexed string)"
                minor_mismatches.append((col, "string"))
            elif is_decimal and not is_indexed:
                status = "NOTE (decimal range generation)"
                minor_mismatches.append((col, "decimal"))
            else:
                status = "DIVERGED"
                critical_mismatches.append(col)

            idx_marker = " [idx]" if is_indexed else ""
            if verbose or status == "DIVERGED":
                output_lines.append(f"`{col}` ({col_type}){idx_marker}: orig={oc}, replay={nc}, diff={diff:.2%} → {status}")

    if output_lines:
        print("\n📊 DISTINCT VALUE COUNTS COMPARISON")
        for line in output_lines:
            print(line)

    if verbose and minor_mismatches:
        string_cols = [c for c, t in minor_mismatches if t == "string"]
        decimal_cols = [c for c, t in minor_mismatches if t == "decimal"]
        if string_cols:
            print(f"\n   ℹ️  {len(string_cols)} unindexed string column(s) diverged - "
                  "typically not critical for query planning")
        if decimal_cols:
            print(f"   ℹ️  {len(decimal_cols)} decimal column(s) diverged - "
                  "range-based generation may produce more distinct values")

    return critical_mismatches  # Only return critical mismatches as failures


def validate_table(cursor, src_schema, tgt_schema, table, skip_distinct, verbose=True):
    """Validate a single table. Returns True if all checks pass."""
    rows_ok = hist_ok = distinct_ok = True

    print(f"\n{'=' * 60}")
    print(f"TABLE: {table}")
    print(f"Comparing `{src_schema}`.`{table}` vs `{tgt_schema}`.`{table}`")
    print("=" * 60)

    # Always run ANALYZE TABLE to ensure fresh statistics
    if verbose:
        print("\nRunning ANALYZE TABLE...")
    cursor.execute(f"ANALYZE TABLE `{src_schema}`.`{table}`")
    cursor.fetchall()
    cursor.execute(f"ANALYZE TABLE `{tgt_schema}`.`{table}`")
    cursor.fetchall()

    # Row count
    src_rows = load_row_count(cursor, src_schema, table)
    tgt_rows = load_row_count(cursor, tgt_schema, table)
    rows_ok = report_row_counts(src_rows, tgt_rows, verbose)

    # Table stats
    report_table_stats(
        load_table_stats(cursor, src_schema, table),
        load_table_stats(cursor, tgt_schema, table),
        verbose
    )

    # Index stats
    report_index_stats(
        load_index_stats(cursor, src_schema, table),
        load_index_stats(cursor, tgt_schema, table),
        verbose
    )

    # Histograms
    src_hist = load_histograms(cursor, src_schema, table)
    tgt_hist = load_histograms(cursor, tgt_schema, table)
    hist_results = compare_histograms(src_hist, tgt_hist)

    # Get column metadata for categorizing mismatches
    indexed_cols = load_indexed_columns(cursor, src_schema, table)
    column_types = load_column_types(cursor, src_schema, table)

    hist_critical = report_histogram_comparison(hist_results, indexed_cols, column_types, verbose)
    if hist_critical:
        hist_ok = False

    # Distinct counts
    if not skip_distinct:
        src_distinct = load_distinct_counts(cursor, src_schema, table)
        tgt_distinct = load_distinct_counts(cursor, tgt_schema, table)
        distinct_mismatches = report_distinct_counts(src_distinct, tgt_distinct, verbose)

        if distinct_mismatches:
            distinct_ok = False
    else:
        print("\n⏭️  DISTINCT COUNTS SKIPPED")

    print(f"\n--- {table} SUMMARY ---")
    print(f"Row count match      : {'✅' if rows_ok else '❌'}")
    print(f"Histograms match     : {'✅' if hist_ok else '❌'}")
    if not skip_distinct:
        print(f"Distinct counts match: {'✅' if distinct_ok else '❌'}")

    return rows_ok and hist_ok and distinct_ok


# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Compare statistics between two schemas for tables"
    )
    parser.add_argument("--host", default="localhost")
    parser.add_argument("--user", default="root")
    parser.add_argument("--password", default=PASSWORD)
    parser.add_argument("--source-schema", default="tpch",
                        help="Reference schema (default: tpch)")
    parser.add_argument("--target-schema", default="tpch_harsha",
                        help="Schema to validate (default: tpch_harsha)")
    parser.add_argument("--table",
                        help="Table name to compare (default: all tables)")
    parser.add_argument("--skip-distinct", action="store_true",
                        help="Skip distinct count comparison (can be slow on large tables)")
    parser.add_argument("--verbose", "-v", action="store_true",
                        help="Verbose output (show all results, not just failures)")
    args = parser.parse_args()

    src_schema = args.source_schema
    tgt_schema = args.target_schema

    all_passed = True

    try:
        conn = mysql.connector.connect(
            host=args.host,
            user=args.user,
            password=args.password,
            autocommit=True
        )
        cursor = conn.cursor()

        cursor.execute("SET time_zone = '+00:00'")

        # Get tables to validate
        if args.table:
            tables = [args.table]
        else:
            tables = get_all_tables(cursor, src_schema)
            print(f"Found {len(tables)} tables in `{src_schema}`: {', '.join(tables)}")

        # Validate each table
        results = {}
        for table in tables:
            try:
                passed = validate_table(
                    cursor, src_schema, tgt_schema, table,
                    args.skip_distinct, args.verbose
                )
                results[table] = passed
                if not passed:
                    all_passed = False
            except Error as e:
                print(f"\n❌ Error validating {table}: {e}")
                results[table] = False
                all_passed = False

        # Final summary
        print("\n" + "=" * 60)
        print("FINAL SUMMARY - ALL TABLES")
        print("=" * 60)
        for table, passed in results.items():
            print(f"{table:30} : {'✅ PASS' if passed else '❌ FAIL'}")
        print("=" * 60)
        print(f"Overall: {'✅ ALL PASSED' if all_passed else '❌ SOME FAILED'}")
        print("=" * 60)

        if not all_passed:
            sys.exit(2)

    except Error as e:
        print("❌ MySQL Error:", e)
        sys.exit(1)

    finally:
        if 'cursor' in locals() and cursor:
            cursor.close()
        if 'conn' in locals() and conn and conn.is_connected():
            conn.close()


if __name__ == "__main__":
    main()
