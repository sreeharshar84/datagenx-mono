#!/usr/bin/env python3
"""
run_tpch_comparison.py — Run all TPC-H queries on both schemas and compare EXPLAIN plans.

Focuses on plan shape comparison (optimizer strategy) rather than query results,
since synthetic data is expected to produce different results but should trigger
the same optimizer decisions.

Usage:
    python run_tpch_comparison.py
"""

import argparse
import os
import glob
import json
from datetime import datetime

try:
    import mysql.connector
    from mysql.connector import Error
except ModuleNotFoundError:
    mysql = None
    Error = RuntimeError

# ----------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------
from datagenx.config import (
    HOST, PASSWORD, REPO_ROOT, SOURCE_SCHEMA, TARGET_SCHEMA, TPCH_QUERIES_DIR, USER,
)
from datagenx.validation.literal_mapping import load_mapping, rewrite_sql_literals

QUERIES_DIR = str(TPCH_QUERIES_DIR)
# Results belong in this repository, not written back into the TPC-H kit.
OUTPUT_FILE = str(REPO_ROOT / "generated" / "comparison_results.txt")

# Thresholds for acceptable differences
NDV_DIFF_THRESHOLD = 10  # percent
HISTOGRAM_DIFF_THRESHOLD = 10  # percent
ROW_ESTIMATE_THRESHOLD = 10  # percent


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


def run_explain(cursor, query):
    """Run EXPLAIN on the query."""
    cursor.execute(f"EXPLAIN {query}")
    return cursor.fetchall(), cursor.column_names


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
        has_critical: whether there are critical (access method/index) differences
    """
    shape_cols = ['select_type', 'table', 'type', 'possible_keys', 'key', 'key_len', 'ref', 'Extra']
    col_indices = {col: i for i, col in enumerate(columns)}

    shape_diffs = []
    max_rows = max(len(source_rows), len(target_rows))

    for i in range(max_rows):
        src_row = source_rows[i] if i < len(source_rows) else None
        tgt_row = target_rows[i] if i < len(target_rows) else None

        if src_row is None or tgt_row is None:
            shape_diffs.append(("PLAN ROW", "row count mismatch", "CRITICAL"))
            continue

        table_idx = col_indices.get('table', 2)
        table_name = src_row[table_idx] if table_idx < len(src_row) else '?'

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
                severity = "CRITICAL" if col in ['type', 'key'] else "WARNING"
                shape_diffs.append((f"{table_name}.{col}", f"{src_val} -> {tgt_val}", severity))

    has_critical = any(d[2] == "CRITICAL" for d in shape_diffs)
    return shape_diffs, has_critical


def get_all_tables(cursor, schema):
    """Get all table names in a schema."""
    cursor.execute("""
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE'
    """, (schema,))
    return [row[0] for row in cursor.fetchall()]


def get_table_row_count(cursor, schema, table):
    """Get row count for a table."""
    try:
        cursor.execute(f"SELECT COUNT(*) FROM `{schema}`.`{table}`")
        return cursor.fetchone()[0]
    except:
        return None


def get_column_ndv(cursor, schema, table):
    """Get NDV for each column in a table."""
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
                histograms[col] = {
                    'type': hist.get('histogram-type', 'unknown'),
                    'num_buckets': len(hist.get('buckets', [])),
                }
        return histograms
    except:
        return {}


def calculate_diff_pct(val1, val2):
    """Calculate percentage difference between two values."""
    if val1 == 0 and val2 == 0:
        return 0.0
    if val1 == 0 or val2 == 0:
        return 100.0
    return abs(val1 - val2) * 100 / max(val1, val2)


def collect_table_statistics(source_cursor, target_cursor, tables):
    """Collect NDV and histogram statistics for tables.

    Returns dict with 'ndv' and 'histogram' summaries including violations.
    """
    ndv_summary = {'total': 0, 'ok': 0, 'minor_diff': 0, 'major_diff': 0, 'violations': []}
    histogram_summary = {'total': 0, 'ok': 0, 'minor_diff': 0, 'major_diff': 0, 'violations': []}

    for table in tables:
        # NDV comparison
        src_ndv = get_column_ndv(source_cursor, SOURCE_SCHEMA, table)
        tgt_ndv = get_column_ndv(target_cursor, TARGET_SCHEMA, table)

        common_cols = set(src_ndv.keys()) & set(tgt_ndv.keys())
        for col in common_cols:
            src_val = src_ndv.get(col, 0)
            tgt_val = tgt_ndv.get(col, 0)
            diff_pct = calculate_diff_pct(src_val, tgt_val)

            ndv_summary['total'] += 1
            if diff_pct == 0:
                ndv_summary['ok'] += 1
            elif diff_pct <= NDV_DIFF_THRESHOLD:
                ndv_summary['minor_diff'] += 1
            else:
                ndv_summary['major_diff'] += 1
                ndv_summary['violations'].append({
                    'table': table,
                    'column': col,
                    'source': src_val,
                    'target': tgt_val,
                    'diff_pct': diff_pct
                })

        # Histogram comparison
        src_hist = get_histogram_info(source_cursor, SOURCE_SCHEMA, table)
        tgt_hist = get_histogram_info(target_cursor, TARGET_SCHEMA, table)

        all_hist_cols = set(src_hist.keys()) | set(tgt_hist.keys())
        for col in all_hist_cols:
            src_info = src_hist.get(col, {})
            tgt_info = tgt_hist.get(col, {})
            src_buckets = src_info.get('num_buckets', 0)
            tgt_buckets = tgt_info.get('num_buckets', 0)

            diff_pct = calculate_diff_pct(src_buckets, tgt_buckets)

            histogram_summary['total'] += 1
            if diff_pct == 0:
                histogram_summary['ok'] += 1
            elif diff_pct <= HISTOGRAM_DIFF_THRESHOLD:
                histogram_summary['minor_diff'] += 1
            else:
                histogram_summary['major_diff'] += 1
                histogram_summary['violations'].append({
                    'table': table,
                    'column': col,
                    'source': f"{src_buckets}b",
                    'target': f"{tgt_buckets}b",
                    'diff_pct': diff_pct
                })

    return {'ndv': ndv_summary, 'histogram': histogram_summary}


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run all TPC-H queries on both schemas and compare EXPLAIN plans."
    )
    parser.add_argument("--host", default=HOST)
    parser.add_argument("--user", default=USER)
    parser.add_argument("--password", default=PASSWORD)
    parser.add_argument("--source-schema", default=SOURCE_SCHEMA)
    parser.add_argument("--target-schema", default=TARGET_SCHEMA)
    parser.add_argument("--queries-dir", default=QUERIES_DIR)
    parser.add_argument("--output-file", default=OUTPUT_FILE)
    parser.add_argument("--literal-mapping-file",
                        help="Rewrite target-side string literals using this sensitive mapping file")
    return parser.parse_args()


def main():
    global HOST, USER, PASSWORD, SOURCE_SCHEMA, TARGET_SCHEMA, QUERIES_DIR, OUTPUT_FILE

    args = parse_args()
    HOST = args.host
    USER = args.user
    PASSWORD = args.password
    SOURCE_SCHEMA = args.source_schema
    TARGET_SCHEMA = args.target_schema
    QUERIES_DIR = args.queries_dir
    OUTPUT_FILE = args.output_file
    literal_mapping = load_mapping(args.literal_mapping_file) if args.literal_mapping_file else None

    # Get all query files
    query_files = sorted(glob.glob(os.path.join(QUERIES_DIR, "*.sql")))

    if not query_files:
        print(f"No query files found in {QUERIES_DIR}")
        return

    # Connect to both schemas
    try:
        source_conn = get_connection(SOURCE_SCHEMA)
        target_conn = get_connection(TARGET_SCHEMA)
        source_cursor = source_conn.cursor()
        target_cursor = target_conn.cursor()
    except Error as e:
        print(f"Database connection failed: {e}")
        return

    separator = "=" * 72
    started_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    print(separator)
    print(f"TPC-H Plan Comparison: {SOURCE_SCHEMA} vs {TARGET_SCHEMA}")
    print(separator)
    print(f"Started at: {started_at}")
    print()

    # Analyze all tables first
    print("Analyzing tables...")
    analyze_all_tables(source_cursor, SOURCE_SCHEMA)
    analyze_all_tables(target_cursor, TARGET_SCHEMA)
    print("Done.")
    print()

    # Collect table statistics (NDV, histograms) for all tables
    print("Collecting table statistics...")
    all_tables = get_all_tables(source_cursor, SOURCE_SCHEMA)
    stats_summary = collect_table_statistics(source_cursor, target_cursor, all_tables)
    print("Done.")
    print()

    # Results storage
    results = []
    plan_identical = 0
    plan_similar = 0
    plan_different = 0

    # Table header
    print(f"{'Query':<10} | {'Plan Shape':<12} | {'Details':<45}")
    print("-" * 72)

    # Run each query
    for query_file in query_files:
        query_name = os.path.basename(query_file).replace("_mysql.sql", "")

        with open(query_file) as f:
            query_sql = f.read().strip()
        target_query_sql = query_sql
        rewrite_stats = None
        if literal_mapping:
            target_query_sql, rewrite_stats = rewrite_sql_literals(query_sql, literal_mapping)

        # Get EXPLAIN plans
        try:
            source_explain, explain_cols = run_explain(source_cursor, query_sql)
            target_explain, _ = run_explain(target_cursor, target_query_sql)

            shape_diffs, has_critical = compare_explain_plans(
                source_explain, target_explain, explain_cols,
                SOURCE_SCHEMA, TARGET_SCHEMA
            )

            if not shape_diffs:
                plan_status = "IDENTICAL"
                plan_identical += 1
                details = "Same optimizer strategy"
            elif not has_critical:
                plan_status = "SIMILAR"
                plan_similar += 1
                details = f"{len(shape_diffs)} minor diff(s)"
            else:
                plan_status = "DIFFERENT"
                plan_different += 1
                critical_diffs = [d for d in shape_diffs if d[2] == "CRITICAL"]
                details = f"{len(critical_diffs)} critical diff(s)"

        except Error as e:
            plan_status = "ERROR"
            plan_different += 1
            details = str(e)[:40]
            shape_diffs = []

        results.append({
            "query": query_name,
            "status": plan_status,
            "details": details,
            "diffs": shape_diffs,
            "rewritten_literals": rewrite_stats["rewritten_literals"] if rewrite_stats else 0,
            "rewritten_dates": rewrite_stats["rewritten_dates"] if rewrite_stats else 0,
            "skipped_ambiguous_literals": rewrite_stats["skipped_ambiguous_literals"] if rewrite_stats else [],
        })

        print(f"{query_name.upper():<10} | {plan_status:<12} | {details:<45}")
        if rewrite_stats and rewrite_stats["rewritten_literals"]:
            print(f"{'':<10} | {'':<12} | target literals rewritten: {rewrite_stats['rewritten_literals']}")
        if rewrite_stats and rewrite_stats["rewritten_dates"]:
            print(f"{'':<10} | {'':<12} | target dates rewritten: {rewrite_stats['rewritten_dates']}")

    # Summary
    print()
    print(separator)
    print("SUMMARY")
    print(separator)

    total_queries = len(query_files)
    print(f"Total queries:     {total_queries}")
    print()
    print(f"Plan IDENTICAL:    {plan_identical} ({plan_identical*100//total_queries}%)")
    print(f"Plan SIMILAR:      {plan_similar} ({plan_similar*100//total_queries}%)")
    print(f"Plan DIFFERENT:    {plan_different} ({plan_different*100//total_queries}%)")

    # NDV summary
    print()
    ndv = stats_summary['ndv']
    if ndv['total'] > 0:
        ndv_ok = ndv['ok'] + ndv['minor_diff']
        if ndv['major_diff'] == 0:
            print(f"NDV (Distinct):    {ndv_ok}/{ndv['total']} OK (all within {NDV_DIFF_THRESHOLD}%)")
        else:
            print(f"NDV (Distinct):    {ndv_ok}/{ndv['total']} OK, {ndv['major_diff']} VIOLATIONS (>{NDV_DIFF_THRESHOLD}%):")
            for v in ndv['violations'][:5]:  # Show first 5
                print(f"                   - {v['table']}.{v['column']}: {v['source']} vs {v['target']} ({v['diff_pct']:.1f}%)")
            if len(ndv['violations']) > 5:
                print(f"                   ... and {len(ndv['violations']) - 5} more")

    # Histogram summary
    hist = stats_summary['histogram']
    if hist['total'] > 0:
        hist_ok = hist['ok'] + hist['minor_diff']
        if hist['major_diff'] == 0:
            print(f"Histograms:        {hist_ok}/{hist['total']} OK (all within {HISTOGRAM_DIFF_THRESHOLD}%)")
        else:
            print(f"Histograms:        {hist_ok}/{hist['total']} OK, {hist['major_diff']} VIOLATIONS (>{HISTOGRAM_DIFF_THRESHOLD}%):")
            for v in hist['violations'][:5]:  # Show first 5
                print(f"                   - {v['table']}.{v['column']}: {v['source']} vs {v['target']} ({v['diff_pct']:.1f}%)")
            if len(hist['violations']) > 5:
                print(f"                   ... and {len(hist['violations']) - 5} more")

    # List queries needing investigation
    if plan_different > 0:
        print()
        print("Queries needing investigation (DIFFERENT plans):")
        for r in results:
            if r['status'] == 'DIFFERENT':
                print(f"  - {r['query']}: {r['details']}")
                # Show first few critical diffs
                critical = [d for d in r['diffs'] if d[2] == 'CRITICAL'][:3]
                for diff in critical:
                    print(f"      {diff[0]}: {diff[1]}")

    print()
    print("-" * 72)
    print(f"NOTE: Minor differences in NDV (<={NDV_DIFF_THRESHOLD}%) and histograms (<={HISTOGRAM_DIFF_THRESHOLD}%)")
    print("      are EXPECTED with synthetic data and do not affect optimizer decisions.")
    print("      Use run_single_query.py <query> for detailed analysis of specific queries.")
    print()

    finished_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"Finished at: {finished_at}")

    # Write summary to output file
    with open(OUTPUT_FILE, "w") as f:
        f.write(f"TPC-H Plan Comparison: {SOURCE_SCHEMA} vs {TARGET_SCHEMA}\n")
        f.write(f"{separator}\n")
        f.write(f"Generated: {finished_at}\n\n")

        f.write(f"{'Query':<10} | {'Plan Shape':<12} | {'Details':<45}\n")
        f.write("-" * 72 + "\n")
        for r in results:
            f.write(f"{r['query'].upper():<10} | {r['status']:<12} | {r['details']:<45}\n")
            if r.get("rewritten_literals"):
                f.write(f"{'':<10} | {'':<12} | target literals rewritten: {r['rewritten_literals']}\n")
            if r.get("rewritten_dates"):
                f.write(f"{'':<10} | {'':<12} | target dates rewritten: {r['rewritten_dates']}\n")

        f.write(f"\n{separator}\n")
        f.write("SUMMARY\n")
        f.write(f"{separator}\n")
        f.write(f"Total queries:     {total_queries}\n")
        f.write(f"Plan IDENTICAL:    {plan_identical}\n")
        f.write(f"Plan SIMILAR:      {plan_similar}\n")
        f.write(f"Plan DIFFERENT:    {plan_different}\n")

    print(f"\nResults saved to: {OUTPUT_FILE}")

    # Cleanup
    source_cursor.close()
    target_cursor.close()
    source_conn.close()
    target_conn.close()


if __name__ == "__main__":
    main()
