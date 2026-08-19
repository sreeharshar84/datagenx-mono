#!/usr/bin/env python3
"""
DataGenX Test Agent

Run after code changes:
    python3 tests/test_agent.py
    python3 tests/test_agent.py --full  # with histogram validation
"""

import argparse
import os
import sys
import subprocess
import re

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
os.chdir(PROJECT_ROOT)
sys.path.insert(0, PROJECT_ROOT)

import mysql.connector
from datagenx.config import HOST, USER, PASSWORD

SOURCE = "datagenx_test_src"
TARGET = "datagenx_test_tgt"

# Thresholds
SMALL_TABLE_ROWS = 100
HISTOGRAM_WARN_THRESHOLD = 0.30  # 30% diff is warning
HISTOGRAM_FAIL_THRESHOLD = 0.50  # 50% diff is failure even on small tables


def setup_test_db(cursor):
    """Install test schema from bundled SQL files."""
    print("Setting up test database...")

    cursor.execute(f"DROP DATABASE IF EXISTS {SOURCE}")
    cursor.fetchall()

    schema_file = os.path.join(SCRIPT_DIR, "sakila", "schema.sql")
    data_file = os.path.join(SCRIPT_DIR, "sakila", "data.sql")

    for sql_file in [schema_file, data_file]:
        with open(sql_file, 'r') as f:
            sql = f.read()
        for stmt in sql.split(';'):
            stmt = stmt.strip()
            if stmt and not stmt.startswith('--'):
                try:
                    cursor.execute(stmt)
                    cursor.fetchall()
                except:
                    pass

    cursor.execute(f"SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='{SOURCE}'")
    print(f"  Installed {cursor.fetchone()[0]} tables")


def run_generation(rows=None, full=False, skip_histograms=False):
    """Run MasterRun.py and capture output while displaying it."""
    print("\nRunning generation pipeline...\n")
    cmd = [sys.executable, "MasterRun.py", "--source-schema", SOURCE, "--target-schema", TARGET]
    if rows:
        cmd.extend(["--rows", str(rows)])
    if full:
        cmd.append("--run-validation")
        if not skip_histograms:
            cmd.append("--compare-histograms")

    # Run and capture output while displaying it
    process = subprocess.Popen(
        cmd, cwd=PROJECT_ROOT,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        text=True, bufsize=1
    )

    output_lines = []
    for line in process.stdout:
        print(line, end='')  # Display in real-time
        output_lines.append(line)

    process.wait()
    output = ''.join(output_lines)
    return process.returncode, output


def parse_validation_output(output):
    """Parse MasterRun output to extract validation results.

    Returns dict with:
        - critical_failures: list of (table, issue) for distinct/row count failures
        - histogram_warnings: list of (table, column, diff) for small variance
        - histogram_failures: list of (table, column, diff) for large variance
        - table_rows: dict of table -> row count
    """
    critical_failures = []
    histogram_warnings = []
    histogram_failures = []
    table_rows = {}

    current_table = None

    for line in output.split('\n'):
        # Track current table
        table_match = re.match(r'\[\d+/\d+\] Table: (\w+)', line)
        if table_match:
            current_table = table_match.group(1)

        # Track row counts
        row_match = re.search(r'Source row count = (\d+)', line)
        if row_match and current_table:
            table_rows[current_table] = int(row_match.group(1))

        # Distinct count failures
        distinct_match = re.search(r'`(\w+)`.*orig=(\d+), replay=(\d+), diff=([\d.]+)%.*DIVERGED', line)
        if distinct_match and 'DISTINCT' in line:
            col, orig, replay, diff = distinct_match.groups()
            diff_pct = float(diff)
            if diff_pct > 5:  # >5% distinct count diff is critical
                critical_failures.append((current_table, f"{col}: distinct {orig}→{replay} ({diff}%)"))

        # Histogram failures
        hist_match = re.search(r'`(\w+)`.*distribution_diff = ([\d.]+).*DIVERGED', line)
        if hist_match and current_table:
            col, diff = hist_match.groups()
            diff_val = float(diff)
            rows = table_rows.get(current_table, 0)

            if diff_val >= HISTOGRAM_FAIL_THRESHOLD:
                # Large variance - always a failure
                histogram_failures.append((current_table, col, diff_val, rows))
            elif diff_val >= HISTOGRAM_WARN_THRESHOLD and rows < SMALL_TABLE_ROWS:
                # Small variance on small table - warning only
                histogram_warnings.append((current_table, col, diff_val, rows))
            elif diff_val >= HISTOGRAM_WARN_THRESHOLD:
                # Small variance on large table - failure
                histogram_failures.append((current_table, col, diff_val, rows))

    return {
        'critical_failures': critical_failures,
        'histogram_warnings': histogram_warnings,
        'histogram_failures': histogram_failures,
        'table_rows': table_rows,
    }


def verify_data(cursor):
    """Verify generated data quality."""
    failures = []

    cursor.execute(f"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='{TARGET}'")
    tables = [t[0] for t in cursor.fetchall()]

    # Check row counts
    for table in tables:
        cursor.execute(f"SELECT COUNT(*) FROM `{TARGET}`.`{table}`")
        count = cursor.fetchone()[0]
        if count == 0:
            failures.append(f"{table}: 0 rows generated")

    # FK integrity checks
    fk_checks = [
        ("film", "language", "language_id"),
        ("inventory", "film", "film_id"),
        ("rental", "customer", "customer_id"),
        ("payment", "rental", "rental_id"),
    ]
    for child, parent, col in fk_checks:
        if child in tables and parent in tables:
            cursor.execute(f"""
                SELECT COUNT(*) FROM `{TARGET}`.`{child}` c
                LEFT JOIN `{TARGET}`.`{parent}` p ON c.`{col}` = p.`{col}`
                WHERE p.`{col}` IS NULL
            """)
            orphans = cursor.fetchone()[0]
            if orphans > 0:
                cursor.execute(f"SELECT COUNT(*) FROM `{TARGET}`.`{child}`")
                total = cursor.fetchone()[0]
                pct = (orphans / total * 100) if total else 0
                if pct > 10:
                    failures.append(f"{child}.{col}: {pct:.0f}% orphan rows")

    return failures


def cleanup(cursor):
    """Drop test schemas."""
    cursor.execute("SET FOREIGN_KEY_CHECKS=0")
    cursor.execute(f"DROP DATABASE IF EXISTS `{TARGET}`")
    cursor.execute("SET FOREIGN_KEY_CHECKS=1")


def main():
    parser = argparse.ArgumentParser(description="DataGenX Test Agent")
    parser.add_argument("--rows", type=int, help="Row count to generate")
    parser.add_argument("--keep", action="store_true", help="Keep target schema after test")
    parser.add_argument("--setup-only", action="store_true", help="Only setup test database")
    parser.add_argument("--full", action="store_true", help="Run with validation + histograms")
    parser.add_argument("--skip-histograms", action="store_true", help="Skip histogram comparison")
    args = parser.parse_args()

    print("=" * 60)
    print("  DataGenX Test Agent")
    print("=" * 60)

    conn = mysql.connector.connect(
        host=HOST, user=USER, password=PASSWORD,
        autocommit=True, allow_local_infile=True
    )
    cursor = conn.cursor()

    try:
        setup_test_db(cursor)

        if args.setup_only:
            print("\n--setup-only: Test database ready")
            return 0

        # Run generation
        returncode, output = run_generation(args.rows, args.full, args.skip_histograms)

        # Parse validation results from output
        results = parse_validation_output(output)

        # Verify data independently
        data_failures = verify_data(cursor)

        if not args.keep:
            cleanup(cursor)

        # Report results
        print("\n" + "=" * 60)

        has_critical = False

        # Critical failures (distinct counts, data issues)
        all_critical = results['critical_failures'] + [(None, f) for f in data_failures]
        if all_critical:
            has_critical = True
            print("❌ FAILED - Critical issues:")
            for table, issue in all_critical:
                if table:
                    print(f"   {table}: {issue}")
                else:
                    print(f"   {issue}")

        # Histogram failures (large variance)
        if results['histogram_failures']:
            has_critical = True
            print("❌ FAILED - Histogram variance >50%:")
            for table, col, diff, rows in results['histogram_failures']:
                print(f"   {table}.{col}: {diff*100:.0f}% diff")

        # Final verdict
        if has_critical:
            print("=" * 60)
            return 1
        elif results['histogram_warnings']:
            print("✅ PASSED (with expected variance on small tables)")
            print("=" * 60)
            return 0
        else:
            print("✅ ALL TESTS PASSED")
            print("=" * 60)
            return 0

    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    sys.exit(main())
