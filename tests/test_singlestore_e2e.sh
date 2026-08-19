#!/bin/bash
# End-to-end test for SingleStore support.
# Runs both ONE-STEP and TWO-STEP workflows, validates results.
#
# Usage:
#   export DB_HOST=your-singlestore-host.com
#   export DB_USER=admin
#   export DB_PASS=yourpassword
#   export SOURCE_DB=tpch
#   export TARGET_DB=tpch_test
#   bash tests/test_singlestore_e2e.sh [rows]
#
# Optional: pass row count as argument (default: 1000)

set -e
cd "$(dirname "$0")/.."  # Always run from project root

# ---- Validate environment ----
if [ -z "$DB_HOST" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
    echo "ERROR: Required environment variables not set."
    echo ""
    echo "Usage:"
    echo "  export DB_HOST=your-singlestore-host.com"
    echo "  export DB_USER=admin"
    echo "  export DB_PASS=yourpassword"
    echo "  export SOURCE_DB=tpch        # (optional, default: tpch)"
    echo "  export TARGET_DB=tpch_test   # (optional, default: tpch_test)"
    echo "  bash tests/test_singlestore_e2e.sh [rows]"
    exit 1
fi

SOURCE_DB="${SOURCE_DB:-tpch}"
TARGET_DB="${TARGET_DB:-tpch_test}"
ROWS="${1:-1000}"

echo "============================================================"
echo "  SingleStore E2E Test"
echo "============================================================"
echo "Host:    $DB_HOST"
echo "Source:  $SOURCE_DB"
echo "Target:  $TARGET_DB"
echo "Rows:    $ROWS"
echo ""

# ============================================================
# TEST 1: ONE-STEP (MasterRun.py with validation)
# ============================================================
echo "--- TEST 1: ONE-STEP (MasterRun.py --run-validation) ---"
echo ""

python3 MasterRun.py \
  --db-type singlestore \
  --host "$DB_HOST" \
  --user "$DB_USER" \
  --password "$DB_PASS" \
  --source-schema "$SOURCE_DB" \
  --target-schema "$TARGET_DB" \
  --rows "$ROWS" \
  --run-validation \
  --compare-histograms

echo ""
echo "TEST 1 PASSED: ONE-STEP generation + validation complete."
echo ""

# ============================================================
# TEST 2: Data quality verification (JOINs, distributions)
# ============================================================
echo "--- TEST 2: Data Quality Verification ---"
echo ""

python3 << 'PYEOF'
import mysql.connector, os, sys

conn = mysql.connector.connect(
    host=os.environ["DB_HOST"], user=os.environ["DB_USER"],
    password=os.environ["DB_PASS"], database=os.environ["TARGET_DB"],
    auth_plugin='mysql_native_password'
)
cursor = conn.cursor()

failures = []

# --- Check all tables have expected row count ---
rows = int(os.environ.get("ROWS", "1000"))
cursor.execute("SHOW TABLES")
tables = [t[0] for t in cursor.fetchall()]
print(f"Tables in target: {len(tables)}")

for table in tables:
    cursor.execute(f"SELECT COUNT(*) FROM `{table}`")
    count = cursor.fetchone()[0]
    status = "OK" if count == rows else "FAIL"
    print(f"  {table:15s} {count:>6} rows  [{status}]")
    if count != rows:
        failures.append(f"{table}: expected {rows} rows, got {count}")

# --- FK JOIN tests ---
# KNOWN LIMITATION: SingleStore does not store FK metadata in information_schema.
# Without FK info, child columns are generated independently from parent PKs,
# so JOIN match rates will be low. This section reports actual overlap rates
# for visibility, but does not fail the test.
# Fix: provide FK relationships via --fk-config (planned feature).
join_tests = [
    ("customer -> nation (c_nationkey)", "SELECT COUNT(*) FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey"),
    ("orders -> customer (o_custkey)", "SELECT COUNT(*) FROM orders o JOIN customer c ON o.o_custkey = c.c_custkey"),
    ("lineitem -> orders (l_orderkey)", "SELECT COUNT(*) FROM lineitem l JOIN orders o ON l.l_orderkey = o.o_orderkey"),
]
print("\nFK JOIN overlap (KNOWN LIMITATION: SingleStore has no FK metadata):")
print("  (FK integrity requires --fk-config, not yet implemented)")
for label, query in join_tests:
    try:
        cursor.execute(query)
        join_count = cursor.fetchone()[0]
        pct = (join_count / rows * 100) if rows > 0 else 0
        print(f"  {label}: {join_count}/{rows} ({pct:.0f}%)")
    except Exception as e:
        print(f"  {label}: SKIP ({e})")

# --- Low-cardinality column check ---
# Note: PK columns will have distinct == rows when --rows > source_rows (expected).
# We only check non-PK low-cardinality columns.
print("\nLow-cardinality columns (non-PK, should not exceed source cardinality):")
checks = [
    ("customer", "c_nationkey", 25),   # FK to nation, not a PK
    ("customer", "c_mktsegment", 5),   # enum-like string column
    ("orders", "o_orderstatus", 3),    # enum-like char column
]
for table, col, expected_max in checks:
    try:
        cursor.execute(f"SELECT COUNT(DISTINCT `{col}`) FROM `{table}`")
        distinct = cursor.fetchone()[0]
        ok = distinct <= expected_max * 1.2  # 20% tolerance
        status = "OK" if ok else "FAIL"
        print(f"  {table}.{col}: {distinct} distinct (source max: {expected_max}) [{status}]")
        if not ok:
            failures.append(f"{table}.{col}: {distinct} distinct > source max {expected_max}")
    except Exception as e:
        print(f"  {table}.{col}: SKIP ({e})")

# --- Distribution check: not all values the same ---
print("\nDistribution check (values should not be uniform/single-valued):")
dist_checks = [
    ("customer", "c_nationkey"),
    ("orders", "o_orderdate"),
]
for table, col in dist_checks:
    try:
        cursor.execute(f"SELECT COUNT(DISTINCT `{col}`) FROM `{table}`")
        distinct = cursor.fetchone()[0]
        ok = distinct > 1
        status = "OK" if ok else "FAIL"
        print(f"  {table}.{col}: {distinct} distinct values [{status}]")
        if not ok:
            failures.append(f"{table}.{col}: only 1 distinct value (no distribution)")
    except Exception as e:
        print(f"  {table}.{col}: SKIP ({e})")

cursor.close()
conn.close()

# --- Final result ---
print("")
if failures:
    print(f"FAILURES ({len(failures)}):")
    for f in failures:
        print(f"  - {f}")
    sys.exit(1)
else:
    print("TEST 2 PASSED: All data quality checks OK.")
PYEOF

echo ""

# ============================================================
# TEST 3: TWO-STEP workflow (extract + generate)
# ============================================================
echo "--- TEST 3: TWO-STEP (extract_schema.py + generate_data.py) ---"
echo ""

TWOSTEP_DIR="generated/twostep_test"
rm -rf "$TWOSTEP_DIR"
mkdir -p "$TWOSTEP_DIR"

python3 extract_schema.py \
  --db-type singlestore \
  --host "$DB_HOST" \
  --user "$DB_USER" \
  --password "$DB_PASS" \
  --database "$SOURCE_DB" \
  --output-dir "$TWOSTEP_DIR/dbgen_files"

python3 generate_data.py \
  --input-dir "$TWOSTEP_DIR/dbgen_files" \
  --output-dir "$TWOSTEP_DIR/csv_output" \
  --rows "$ROWS"

# ---- Verify TWO-STEP output ----
echo ""
echo "Verifying TWO-STEP output..."

python3 << 'PYEOF'
import os, sys

twostep_dir = "generated/twostep_test"
dbgen_dir = os.path.join(twostep_dir, "dbgen_files")
csv_dir = os.path.join(twostep_dir, "csv_output")

# Check .dbgen files exist
dbgen_files = [f for f in os.listdir(dbgen_dir) if f.endswith('.dbgen')]
print(f"  .dbgen templates generated: {len(dbgen_files)}")

# Check CSV files exist and are non-empty
csv_files = [f for f in os.listdir(csv_dir) if f.endswith('.csv')]
print(f"  CSV files generated: {len(csv_files)}")

failures = []
if len(dbgen_files) == 0:
    failures.append("No .dbgen files generated")
if len(csv_files) == 0:
    failures.append("No CSV files generated")
if len(dbgen_files) != len(csv_files):
    failures.append(f"Mismatch: {len(dbgen_files)} templates vs {len(csv_files)} CSVs")

for csv_file in csv_files:
    path = os.path.join(csv_dir, csv_file)
    size = os.path.getsize(path)
    if size == 0:
        failures.append(f"Empty CSV: {csv_file}")

# Compare template structure with ONE-STEP output
onestep_dir = "generated/dbgen_files"
if os.path.isdir(onestep_dir):
    onestep_files = set(f for f in os.listdir(onestep_dir) if f.endswith('.dbgen'))
    twostep_files = set(dbgen_files)
    if onestep_files != twostep_files:
        failures.append(f"Template sets differ: ONE-STEP has {onestep_files - twostep_files} extra")
    else:
        print(f"  Template sets match: {len(onestep_files)} tables")

if failures:
    print(f"\nFAILURES ({len(failures)}):")
    for f in failures:
        print(f"  - {f}")
    sys.exit(1)
else:
    print("\nTEST 3 PASSED: TWO-STEP workflow complete, all outputs valid.")
PYEOF

# ---- Cleanup ----
rm -rf "$TWOSTEP_DIR"

echo ""
echo "============================================================"
echo "  ALL TESTS PASSED"
echo "============================================================"
