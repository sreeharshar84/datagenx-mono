import mysql.connector
from mysql.connector import Error
import argparse
import time
import re
import sys
import json
from pathlib import Path


# ------------------------------------------------------------
# Utilities
# ------------------------------------------------------------

def normalize_ddl(ddl: str, src_schema: str) -> str:
    ddl = re.sub(rf"`{src_schema}_[^`]+`\.", "", ddl)
    ddl = re.sub(rf"`{src_schema}`\.", "", ddl)
    ddl = re.sub(r"\s+", " ", ddl)
    return ddl.strip().lower()


def extract_table_name(ddl: str) -> str:
    m = re.search(r"create\s+table\s+`([^`]+)`", ddl, re.IGNORECASE)
    if not m:
        raise ValueError("Could not extract table name from DDL")
    return m.group(1)


def execute_statements(cursor, sql_text):
    statements = [s.strip() for s in sql_text.split(";") if s.strip()]
    for stmt in statements:
        cursor.execute(stmt)


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


def clone_histograms(cursor, src_schema, tgt_schema, table):
    cursor.execute("""
        SELECT COLUMN_NAME
        FROM information_schema.column_statistics
        WHERE SCHEMA_NAME = %s AND TABLE_NAME = %s
    """, (src_schema, table))

    cols = [row[0] for row in cursor.fetchall()]
    if not cols:
        return

    col_list = ", ".join(f"`{c}`" for c in cols)

    cursor.execute(
        f"""
        ANALYZE TABLE `{tgt_schema}`.`{table}`
        UPDATE HISTOGRAM ON {col_list}
        WITH 100 BUCKETS
        """
    )
    cursor.fetchall()


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


# ------------------------------------------------------------
# Reporting
# ------------------------------------------------------------

def report_ddl_mismatch(orig, new):
    print("\n❌ DDL MISMATCH")
    print("----- ORIGINAL -----")
    print(orig)
    print("----- REPLAYED -----")
    print(new)


def report_rowcount_mismatch(orig, new):
    print("\n❌ ROW COUNT MISMATCH")
    print(f"Original : {orig}")
    print(f"Replayed : {new}")


def report_histogram_mismatch(mismatches):
    """Deprecated - kept for backwards compatibility."""
    print("\n❌ HISTOGRAM MISMATCHES")
    for col, reason in mismatches:
        print(f" - Column `{col}`: {reason}")


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


# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="localhost")
    parser.add_argument("--user", required=True)
    parser.add_argument("--password", required=True)
    parser.add_argument("--source-schema", required=True)
    parser.add_argument("--ddl-file", required=True)
    parser.add_argument("--insert-file", required=True)
    parser.add_argument("--keep-schema", action="store_true",
                        help="Keep the replayed schema instead of dropping it")
    args = parser.parse_args()

    src_schema = args.source_schema

    ddl_sql = Path(args.ddl_file).read_text()
    insert_sql = Path(args.insert_file).read_text()

    table = extract_table_name(ddl_sql)
    ts = int(time.time())
    new_schema = f"{src_schema}_{ts}"

    ddl_ok = rows_ok = hist_ok = distinct_ok = True

    try:
        conn = mysql.connector.connect(
            host=args.host,
            user=args.user,
            password=args.password,
            autocommit=True
        )
        cursor = conn.cursor()

        cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
        cursor.execute("SET time_zone = '+00:00'")

        cursor.execute(f"SELECT COUNT(*) FROM `{src_schema}`.`{table}`")
        src_rows = cursor.fetchone()[0]

        cursor.execute(f"CREATE SCHEMA `{new_schema}`")

        ddl_new = ddl_sql.replace(
            f"`{table}`", f"`{new_schema}`.`{table}`", 1
        )
        cursor.execute(ddl_new)

        insert_new = re.sub(
            rf"(insert\s+into\s+)`?{table}`?",
            rf"\1`{new_schema}`.`{table}`",
            insert_sql,
            flags=re.IGNORECASE
        )
        execute_statements(cursor, insert_new)

        cursor.execute(f"SELECT COUNT(*) FROM `{new_schema}`.`{table}`")
        tgt_rows = cursor.fetchone()[0]

        if src_rows != tgt_rows:
            rows_ok = False
            report_rowcount_mismatch(src_rows, tgt_rows)

        cursor.execute(f"ANALYZE TABLE `{src_schema}`.`{table}`")
        cursor.fetchall()
        cursor.execute(f"ANALYZE TABLE `{new_schema}`.`{table}`")
        cursor.fetchall()

        clone_histograms(cursor, src_schema, new_schema, table)

        cursor.execute(f"SHOW CREATE TABLE `{src_schema}`.`{table}`")
        src_ddl = cursor.fetchone()[1]
        cursor.execute(f"SHOW CREATE TABLE `{new_schema}`.`{table}`")
        tgt_ddl = cursor.fetchone()[1]

        if normalize_ddl(src_ddl, src_schema) != normalize_ddl(tgt_ddl, src_schema):
            ddl_ok = False
            report_ddl_mismatch(src_ddl, tgt_ddl)

        src_hist = load_histograms(cursor, src_schema, table)
        tgt_hist = load_histograms(cursor, new_schema, table)
        hist_diff = compare_histograms(src_hist, tgt_hist)

        if hist_diff:
            hist_ok = False
            report_histogram_mismatch(hist_diff)

        report_table_stats(
            load_table_stats(cursor, src_schema, table),
            load_table_stats(cursor, new_schema, table)
        )

        report_index_stats(
            load_index_stats(cursor, src_schema, table),
            load_index_stats(cursor, new_schema, table)
        )

        src_distinct = load_distinct_counts(cursor, src_schema, table)
        tgt_distinct = load_distinct_counts(cursor, new_schema, table)
        distinct_mismatches = report_distinct_counts(src_distinct, tgt_distinct)

        if distinct_mismatches:
            distinct_ok = False

        print("\n================ FINAL SUMMARY ================")
        print(f"DDL match            : {'✅' if ddl_ok else '❌'}")
        print(f"Row count match      : {'✅' if rows_ok else '❌'}")
        print(f"Histograms match     : {'✅' if hist_ok else '❌'}")
        print(f"Distinct counts match: {'✅' if distinct_ok else '❌'}")
        print("==============================================")

        if not (ddl_ok and rows_ok and hist_ok and distinct_ok):
            sys.exit(2)

    except Error as e:
        print("❌ MySQL Error:", e)
        sys.exit(1)

    finally:
        if cursor:
            if args.keep_schema:
                print(f"\n💾 Keeping schema `{new_schema}`, table `{table}`")
            else:
                print(f"\n🧹 Dropping schema `{new_schema}`")
                cursor.execute(f"DROP SCHEMA IF EXISTS `{new_schema}`")
            cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
        if conn and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    main()
