#!/usr/bin/env python3
"""
run_single_query.py — Run a single TPC-H query on both schemas with explain plans.

Usage:
    python run_single_query.py <query_prefix>
    python run_single_query.py q11
"""

import argparse
import sys
import os
import glob
import re
import json

try:
    import mysql.connector
    from mysql.connector import Error
except ModuleNotFoundError:
    mysql = None
    Error = RuntimeError

# ----------------------------------------------------------------
# Configuration (same as MasterRun.py)
# ----------------------------------------------------------------
from datagenx.config import HOST, PASSWORD, SOURCE_SCHEMA, TARGET_SCHEMA, USER, TPCH_QUERIES_DIR
from datagenx.validation.literal_mapping import load_mapping, rewrite_sql_literals

QUERIES_DIR = str(TPCH_QUERIES_DIR)

# Threshold for "acceptable" differences
ROW_ESTIMATE_THRESHOLD = 10  # percent
HISTOGRAM_DIFF_THRESHOLD = 10  # percent - histogram differences below this are acceptable
NDV_DIFF_THRESHOLD = 10  # percent - NDV differences below this are acceptable


def get_connection(schema):
    """Create a database connection to the specified schema."""
    if mysql is None:
        raise Error("mysql-connector-python is not installed")
    return mysql.connector.connect(
        host=HOST,
        user=USER,
        password=PASSWORD,
        database=schema,
        autocommit=True,
    )


def analyze_all_tables(cursor, schema):
    """Run ANALYZE TABLE on all tables in the schema."""
    cursor.execute("""
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE'
    """, (schema,))
    tables = [row[0] for row in cursor.fetchall()]

    for table in tables:
        cursor.execute(f"ANALYZE TABLE `{schema}`.`{table}`")
        cursor.fetchall()


def find_query_file(prefix):
    """Find query file matching the given prefix."""
    pattern = os.path.join(QUERIES_DIR, f"{prefix}*.sql")
    matches = glob.glob(pattern)
    if matches:
        return matches[0]
    return None


def list_available_queries():
    """List all available query files."""
    pattern = os.path.join(QUERIES_DIR, "*.sql")
    files = glob.glob(pattern)
    return [os.path.basename(f).replace("_mysql.sql", "") for f in sorted(files)]


def run_explain(cursor, query):
    """Run EXPLAIN on the query."""
    cursor.execute(f"EXPLAIN {query}")
    return cursor.fetchall(), cursor.column_names


def extract_tables_from_explain(explain_rows, columns):
    """Extract table names from EXPLAIN output."""
    table_idx = None
    for i, col in enumerate(columns):
        if col.lower() == 'table':
            table_idx = i
            break

    if table_idx is None:
        return []

    tables = []
    for row in explain_rows:
        if table_idx < len(row) and row[table_idx]:
            table_name = str(row[table_idx])
            # Skip derived tables, subqueries
            if not table_name.startswith('<') and table_name not in tables:
                tables.append(table_name)
    return tables


def get_table_row_count(cursor, schema, table):
    """Get row count for a table."""
    try:
        cursor.execute(f"SELECT COUNT(*) FROM `{schema}`.`{table}`")
        return cursor.fetchone()[0]
    except:
        return None


def get_column_ndv(cursor, schema, table):
    """Get NDV (number of distinct values) for each column in a table."""
    try:
        cursor.execute("""
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
            ORDER BY ORDINAL_POSITION
        """, (schema, table))
        columns = [row[0] for row in cursor.fetchall()]

        ndv_info = {}
        for col in columns:
            cursor.execute(f"SELECT COUNT(DISTINCT `{col}`) FROM `{schema}`.`{table}`")
            ndv_info[col] = cursor.fetchone()[0]
        return ndv_info
    except:
        return {}


def get_histogram_info(cursor, schema, table):
    """Get histogram information for columns in a table."""
    try:
        cursor.execute("""
            SELECT COLUMN_NAME, HISTOGRAM
            FROM information_schema.column_statistics
            WHERE SCHEMA_NAME = %s AND TABLE_NAME = %s
        """, (schema, table))

        histograms = {}
        for col, hist_json in cursor.fetchall():
            if hist_json:
                hist = json.loads(hist_json)
                hist_type = hist.get('histogram-type', 'unknown')
                buckets = hist.get('buckets', [])
                histograms[col] = {
                    'type': hist_type,
                    'num_buckets': len(buckets),
                }
        return histograms
    except:
        return {}


def print_table_statistics(source_cursor, target_cursor, tables):
    """Print statistics comparison for involved tables.

    Returns:
        dict with summary info about histogram and NDV differences
    """
    print(f"\n{'Table':<15} | {'Metric':<20} | {SOURCE_SCHEMA:>12} | {TARGET_SCHEMA:>12} | {'Diff %':>8} | {'Status':<10}")
    print("-" * 90)

    histogram_summary = {'total': 0, 'ok': 0, 'minor_diff': 0, 'major_diff': 0, 'violations': []}
    ndv_summary = {'total': 0, 'ok': 0, 'minor_diff': 0, 'major_diff': 0, 'violations': []}

    for table in tables:
        # Row counts
        src_rows = get_table_row_count(source_cursor, SOURCE_SCHEMA, table)
        tgt_rows = get_table_row_count(target_cursor, TARGET_SCHEMA, table)

        if src_rows is not None and tgt_rows is not None:
            if src_rows == 0 and tgt_rows == 0:
                diff_pct = 0.0
            elif src_rows == 0 or tgt_rows == 0:
                diff_pct = 100.0
            else:
                diff_pct = abs(src_rows - tgt_rows) * 100 / max(src_rows, tgt_rows)

            status = "OK" if diff_pct < 1 else "DIFF"
            print(f"{table:<15} | {'Row Count':<20} | {src_rows:>12} | {tgt_rows:>12} | {diff_pct:>7.2f}% | {status:<10}")

        # NDV for key columns (first 3-5 columns, or indexed columns)
        src_ndv = get_column_ndv(source_cursor, SOURCE_SCHEMA, table)
        tgt_ndv = get_column_ndv(target_cursor, TARGET_SCHEMA, table)

        # Show NDV for columns that exist in both
        common_cols = set(src_ndv.keys()) & set(tgt_ndv.keys())
        for col in list(common_cols)[:5]:  # Limit to 5 columns per table
            src_val = src_ndv.get(col, 0)
            tgt_val = tgt_ndv.get(col, 0)

            if src_val == 0 and tgt_val == 0:
                diff_pct = 0.0
            elif src_val == 0 or tgt_val == 0:
                diff_pct = 100.0
            else:
                diff_pct = abs(src_val - tgt_val) * 100 / max(src_val, tgt_val)

            ndv_summary['total'] += 1

            # Determine status based on threshold
            if diff_pct == 0:
                status = "OK"
                ndv_summary['ok'] += 1
            elif diff_pct <= NDV_DIFF_THRESHOLD:
                status = "OK (~)"  # Minor difference, acceptable
                ndv_summary['minor_diff'] += 1
            else:
                status = "DIFF"
                ndv_summary['major_diff'] += 1
                ndv_summary['violations'].append({
                    'table': table,
                    'column': col,
                    'source': src_val,
                    'target': tgt_val,
                    'diff_pct': diff_pct
                })

            print(f"{'':<15} | {f'NDV({col[:12]})':<20} | {src_val:>12} | {tgt_val:>12} | {diff_pct:>7.2f}% | {status:<10}")

        # Histogram info
        src_hist = get_histogram_info(source_cursor, SOURCE_SCHEMA, table)
        tgt_hist = get_histogram_info(target_cursor, TARGET_SCHEMA, table)

        if src_hist or tgt_hist:
            all_hist_cols = set(src_hist.keys()) | set(tgt_hist.keys())
            for col in list(all_hist_cols)[:3]:  # Limit to 3 histograms per table
                src_info = src_hist.get(col, {})
                tgt_info = tgt_hist.get(col, {})
                src_buckets = src_info.get('num_buckets', 0)
                tgt_buckets = tgt_info.get('num_buckets', 0)
                src_type = src_info.get('type', '-')[:6]
                tgt_type = tgt_info.get('type', '-')[:6]

                histogram_summary['total'] += 1

                # Calculate percentage difference for buckets
                if src_buckets == 0 and tgt_buckets == 0:
                    bucket_diff_pct = 0.0
                elif src_buckets == 0 or tgt_buckets == 0:
                    bucket_diff_pct = 100.0
                else:
                    bucket_diff_pct = abs(src_buckets - tgt_buckets) * 100 / max(src_buckets, tgt_buckets)

                # Determine status based on threshold
                if bucket_diff_pct == 0:
                    status = "OK"
                    histogram_summary['ok'] += 1
                elif bucket_diff_pct <= HISTOGRAM_DIFF_THRESHOLD:
                    status = "OK (~)"  # Minor difference, acceptable
                    histogram_summary['minor_diff'] += 1
                else:
                    status = "DIFF"
                    histogram_summary['major_diff'] += 1
                    histogram_summary['violations'].append({
                        'table': table,
                        'column': col,
                        'source': f"{src_buckets}b/{src_type}",
                        'target': f"{tgt_buckets}b/{tgt_type}",
                        'diff_pct': bucket_diff_pct
                    })

                print(f"{'':<15} | {f'Hist({col[:11]})':<20} | {f'{src_buckets}b/{src_type}':>12} | {f'{tgt_buckets}b/{tgt_type}':>12} | {bucket_diff_pct:>7.2f}% | {status:<10}")

        print()  # Blank line between tables

    return {'histogram': histogram_summary, 'ndv': ndv_summary}


def normalize_plan_value(val, source_schema, target_schema):
    """Normalize a plan value by removing schema name differences."""
    if val is None:
        return "(null)"
    s = str(val)
    s = s.replace(f"{source_schema}.", "")
    s = s.replace(f"{target_schema}.", "")
    return s


def compare_explain_plans(source_rows, target_rows, columns, source_schema, target_schema):
    """Compare two EXPLAIN plans focusing on shape differences.

    Returns:
        shape_diffs: list of critical differences (type, key, Extra)
        row_diffs: list of row estimate differences with their severity
    """
    # Shape columns - these indicate plan structure changes
    shape_cols = ['select_type', 'table', 'type', 'possible_keys', 'key', 'key_len', 'ref', 'Extra']
    # Estimate columns - differences here are often acceptable
    estimate_cols = ['rows', 'filtered']

    col_indices = {col: i for i, col in enumerate(columns)}

    shape_diffs = []
    row_diffs = []
    max_rows = max(len(source_rows), len(target_rows))

    for i in range(max_rows):
        src_row = source_rows[i] if i < len(source_rows) else None
        tgt_row = target_rows[i] if i < len(target_rows) else None

        if src_row is None:
            shape_diffs.append((f"row {i+1}", "PLAN ROW", "(missing)", str(tgt_row)[:50], "CRITICAL"))
            continue
        if tgt_row is None:
            shape_diffs.append((f"row {i+1}", "PLAN ROW", str(src_row)[:50], "(missing)", "CRITICAL"))
            continue

        # Get table name for context
        table_idx = col_indices.get('table', 2)
        table_name = src_row[table_idx] if table_idx < len(src_row) else '?'

        # Check shape columns
        for col in shape_cols:
            if col not in col_indices:
                continue
            idx = col_indices[col]
            if idx >= len(src_row) or idx >= len(tgt_row):
                continue

            src_val = src_row[idx]
            tgt_val = tgt_row[idx]

            src_normalized = normalize_plan_value(src_val, source_schema, target_schema)
            tgt_normalized = normalize_plan_value(tgt_val, source_schema, target_schema)

            if src_normalized != tgt_normalized:
                src_display = str(src_val) if src_val is not None else "(null)"
                tgt_display = str(tgt_val) if tgt_val is not None else "(null)"
                severity = "CRITICAL" if col in ['type', 'key'] else "WARNING"
                shape_diffs.append((table_name, col, src_display, tgt_display, severity))

        # Check estimate columns
        for col in estimate_cols:
            if col not in col_indices:
                continue
            idx = col_indices[col]
            if idx >= len(src_row) or idx >= len(tgt_row):
                continue

            src_val = src_row[idx]
            tgt_val = tgt_row[idx]

            try:
                src_num = float(src_val) if src_val is not None else 0
                tgt_num = float(tgt_val) if tgt_val is not None else 0

                if src_num == 0 and tgt_num == 0:
                    diff_pct = 0.0
                elif src_num == 0 or tgt_num == 0:
                    diff_pct = 100.0
                else:
                    diff_pct = abs(src_num - tgt_num) * 100 / max(src_num, tgt_num)

                if diff_pct > 0.1:  # Only report if there's any meaningful difference
                    severity = "OK" if diff_pct <= ROW_ESTIMATE_THRESHOLD else "INFO"
                    row_diffs.append((table_name, col, src_val, tgt_val, diff_pct, severity))
            except (ValueError, TypeError):
                pass

    return shape_diffs, row_diffs


def print_plan_diff(shape_diffs, row_diffs, source_schema, target_schema):
    """Print the differences between two EXPLAIN plans."""

    # Print shape differences (critical)
    if shape_diffs:
        print("\n--- SHAPE DIFFERENCES (Plan Structure) ---")
        critical = [d for d in shape_diffs if d[4] == "CRITICAL"]
        warnings = [d for d in shape_diffs if d[4] == "WARNING"]

        if critical:
            print("\nCRITICAL (different access methods or indexes):")
            for table, col, src_val, tgt_val, _ in critical:
                print(f"  {table}.{col}: {src_val} -> {tgt_val}")

        if warnings:
            print("\nWARNINGS (other plan differences):")
            for table, col, src_val, tgt_val, _ in warnings:
                print(f"  {table}.{col}: {src_val} -> {tgt_val}")
    else:
        print("\n--- SHAPE DIFFERENCES (Plan Structure) ---")
        print("  Plans have identical structure (access types, indexes, joins)")

    # Print row estimate differences
    print("\n--- ROW ESTIMATE DIFFERENCES ---")
    if row_diffs:
        significant = [d for d in row_diffs if d[5] != "OK"]
        acceptable = [d for d in row_diffs if d[5] == "OK"]

        if acceptable:
            print(f"\nAcceptable differences (<= {ROW_ESTIMATE_THRESHOLD}% - expected with synthetic data):")
            for table, col, src_val, tgt_val, diff_pct, _ in acceptable:
                print(f"  {table}.{col}: {src_val} vs {tgt_val} ({diff_pct:.1f}% diff)")

        if significant:
            print(f"\nLarger differences (> {ROW_ESTIMATE_THRESHOLD}% - worth investigating):")
            for table, col, src_val, tgt_val, diff_pct, _ in significant:
                print(f"  {table}.{col}: {src_val} vs {tgt_val} ({diff_pct:.1f}% diff)")
    else:
        print("  Row estimates are identical")


def print_separator(title=None):
    """Print a separator line with optional title."""
    if title:
        print(f"\n{'=' * 72}")
        print(title)
        print('=' * 72)
    else:
        print('=' * 72)


def print_table(rows, columns, max_rows=None):
    """Print results as a formatted table."""
    if not rows:
        print("(no rows)")
        return

    widths = [len(str(col)) for col in columns]
    for row in rows[:max_rows] if max_rows else rows:
        for i, val in enumerate(row):
            widths[i] = max(widths[i], len(str(val)[:50]))

    header = " | ".join(str(col).ljust(widths[i]) for i, col in enumerate(columns))
    print(header)
    print("-" * len(header))

    display_rows = rows[:max_rows] if max_rows else rows
    for row in display_rows:
        line = " | ".join(str(val)[:50].ljust(widths[i]) for i, val in enumerate(row))
        print(line)

    if max_rows and len(rows) > max_rows:
        print(f"... ({len(rows) - max_rows} more rows)")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run one TPC-H query on both schemas with explain plans."
    )
    parser.add_argument("query_prefix", nargs="?", help="Query prefix, for example q11")
    parser.add_argument("--host", default=HOST)
    parser.add_argument("--user", default=USER)
    parser.add_argument("--password", default=PASSWORD)
    parser.add_argument("--source-schema", default=SOURCE_SCHEMA)
    parser.add_argument("--target-schema", default=TARGET_SCHEMA)
    parser.add_argument("--queries-dir", default=QUERIES_DIR)
    parser.add_argument("--literal-mapping-file",
                        help="Rewrite target-side string literals using this sensitive mapping file")
    return parser.parse_args()


def main():
    global HOST, USER, PASSWORD, SOURCE_SCHEMA, TARGET_SCHEMA, QUERIES_DIR

    args = parse_args()
    HOST = args.host
    USER = args.user
    PASSWORD = args.password
    SOURCE_SCHEMA = args.source_schema
    TARGET_SCHEMA = args.target_schema
    QUERIES_DIR = args.queries_dir

    if not args.query_prefix:
        print("Usage: python run_single_query.py <query_prefix>")
        print("Example: python run_single_query.py q11")
        print()
        print("Available queries:")
        for q in list_available_queries():
            print(f"  {q}")
        sys.exit(1)

    query_prefix = args.query_prefix
    query_file = find_query_file(query_prefix)

    if not query_file:
        print(f"Error: No query file found matching prefix '{query_prefix}'")
        print()
        print("Available queries:")
        for q in list_available_queries():
            print(f"  {q}")
        sys.exit(1)

    query_name = os.path.basename(query_file).replace("_mysql.sql", "")
    with open(query_file) as f:
        query_sql = f.read().strip()

    target_query_sql = query_sql
    rewrite_stats = None
    if args.literal_mapping_file:
        mapping = load_mapping(args.literal_mapping_file)
        target_query_sql, rewrite_stats = rewrite_sql_literals(query_sql, mapping)

    print_separator(f"Query: {query_name}")
    print(f"File: {query_file}")
    print()
    print("--- SQL ---")
    print(query_sql)
    if rewrite_stats:
        print()
        print("--- Target SQL after literal mapping ---")
        print(target_query_sql)
        print(f"Rewritten literals: {rewrite_stats['rewritten_literals']}")
        print(f"Rewritten dates: {rewrite_stats['rewritten_dates']}")
        if rewrite_stats["skipped_ambiguous_literals"]:
            print("Skipped ambiguous literals: " + ", ".join(rewrite_stats["skipped_ambiguous_literals"]))

    # Connect to both schemas
    try:
        source_conn = get_connection(SOURCE_SCHEMA)
        target_conn = get_connection(TARGET_SCHEMA)
        source_cursor = source_conn.cursor()
        target_cursor = target_conn.cursor()
    except Error as e:
        print(f"Database connection failed: {e}")
        sys.exit(1)

    # Analyze all tables first
    print_separator("ANALYZING TABLES")
    print(f"Running ANALYZE TABLE on all tables in {SOURCE_SCHEMA}...")
    analyze_all_tables(source_cursor, SOURCE_SCHEMA)
    print(f"Running ANALYZE TABLE on all tables in {TARGET_SCHEMA}...")
    analyze_all_tables(target_cursor, TARGET_SCHEMA)
    print("Done.")

    # EXPLAIN plans
    print_separator(f"EXPLAIN PLAN — {SOURCE_SCHEMA} (source)")
    source_explain, explain_cols = run_explain(source_cursor, query_sql)
    print_table(source_explain, explain_cols)

    print_separator(f"EXPLAIN PLAN — {TARGET_SCHEMA} (target)")
    target_explain, _ = run_explain(target_cursor, target_query_sql)
    print_table(target_explain, explain_cols)

    # Extract tables involved
    tables = extract_tables_from_explain(source_explain, explain_cols)

    # Show statistics for involved tables
    print_separator("TABLE STATISTICS (for tables in query)")
    stats_summary = print_table_statistics(source_cursor, target_cursor, tables)

    # Show plan diff (shape-focused)
    print_separator("EXPLAIN PLAN DIFF")
    shape_diffs, row_diffs = compare_explain_plans(
        source_explain, target_explain, explain_cols,
        SOURCE_SCHEMA, TARGET_SCHEMA
    )
    print_plan_diff(shape_diffs, row_diffs, SOURCE_SCHEMA, TARGET_SCHEMA)

    # Final summary
    print_separator("SUMMARY")

    # Plan shape assessment
    critical_shape = [d for d in shape_diffs if d[4] == "CRITICAL"]
    if not shape_diffs:
        print("Plan Shape:      IDENTICAL - optimizer chose same strategy")
    elif not critical_shape:
        print("Plan Shape:      SIMILAR - minor differences, same overall strategy")
    else:
        print("Plan Shape:      DIFFERENT - optimizer chose different strategies")

    # Statistics assessment
    print(f"Tables Analyzed: {', '.join(tables)}")

    # NDV assessment
    ndv_summary = stats_summary['ndv']
    if ndv_summary['total'] > 0:
        ndv_ok = ndv_summary['ok'] + ndv_summary['minor_diff']
        ndv_total = ndv_summary['total']
        if ndv_summary['major_diff'] == 0:
            print(f"NDV (Distinct):  {ndv_ok}/{ndv_total} OK (all within {NDV_DIFF_THRESHOLD}% threshold)")
        else:
            print(f"NDV (Distinct):  {ndv_ok}/{ndv_total} OK, {ndv_summary['major_diff']} VIOLATIONS (>{NDV_DIFF_THRESHOLD}%):")
            for v in ndv_summary['violations']:
                print(f"                 - {v['table']}.{v['column']}: {v['source']} vs {v['target']} ({v['diff_pct']:.1f}% diff)")

    # Histogram assessment
    histogram_summary = stats_summary['histogram']
    if histogram_summary['total'] > 0:
        hist_ok = histogram_summary['ok'] + histogram_summary['minor_diff']
        hist_total = histogram_summary['total']
        if histogram_summary['major_diff'] == 0:
            print(f"Histograms:      {hist_ok}/{hist_total} OK (all within {HISTOGRAM_DIFF_THRESHOLD}% threshold)")
        else:
            print(f"Histograms:      {hist_ok}/{hist_total} OK, {histogram_summary['major_diff']} VIOLATIONS (>{HISTOGRAM_DIFF_THRESHOLD}%):")
            for v in histogram_summary['violations']:
                print(f"                 - {v['table']}.{v['column']}: {v['source']} vs {v['target']} ({v['diff_pct']:.1f}% diff)")

    # Explicit note about acceptable differences
    print("\n" + "-" * 72)
    print(f"NOTE: Minor differences in NDV (<={NDV_DIFF_THRESHOLD}%), histograms (<={HISTOGRAM_DIFF_THRESHOLD}%),")
    print(f"      and row estimates (<={ROW_ESTIMATE_THRESHOLD}%) are EXPECTED with synthetic data")
    print("      and do not affect optimizer plan selection. The key validation")
    print("      criterion is that the optimizer chooses the SAME execution strategy")
    print("      (plan shape) on both schemas.")
    print()

    # Cleanup
    source_cursor.close()
    target_cursor.close()
    source_conn.close()
    target_conn.close()


if __name__ == "__main__":
    main()
