#!/usr/bin/env python3
"""
Setup TPC-H schema at any scale factor with data, PKs, FKs, and histograms.

Usage:
    python3 scripts/setup_tpch_schema.py --scale-factor 10
    python3 scripts/setup_tpch_schema.py --scale-factor 5 --schema-name my_tpch

This script:
1. Creates schema tpch_sf{N} (or custom name)
2. Generates TPC-H data using dbgen
3. Creates tables with primary keys
4. Loads data from .tbl files
5. Adds foreign key constraints
6. Runs ANALYZE TABLE with full histogram sampling
"""

import argparse
import os
import subprocess
import sys
import time

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import mysql.connector
from mysql.connector import Error

from datagenx.config import (
    HOST, USER, PASSWORD, DB_PORT, DB_TYPE, REPO_ROOT,
    TPCH_DBGEN_DIR as _TPCH_DBGEN_DIR,
)

TPCH_DBGEN_DIR = str(_TPCH_DBGEN_DIR)

# Table creation order (respects FK dependencies)
TABLE_ORDER = ["region", "nation", "part", "supplier", "customer", "partsupp", "orders", "lineitem"]

# DDL statements with PRIMARY KEYS (based on dss.ddl + dss.ri)
TABLE_DDL = {
    "region": """
        CREATE TABLE region (
            R_REGIONKEY  INTEGER NOT NULL,
            R_NAME       CHAR(25) NOT NULL,
            R_COMMENT    VARCHAR(152),
            PRIMARY KEY (R_REGIONKEY)
        )
    """,
    "nation": """
        CREATE TABLE nation (
            N_NATIONKEY  INTEGER NOT NULL,
            N_NAME       CHAR(25) NOT NULL,
            N_REGIONKEY  INTEGER NOT NULL,
            N_COMMENT    VARCHAR(152),
            PRIMARY KEY (N_NATIONKEY)
        )
    """,
    "part": """
        CREATE TABLE part (
            P_PARTKEY     INTEGER NOT NULL,
            P_NAME        VARCHAR(55) NOT NULL,
            P_MFGR        CHAR(25) NOT NULL,
            P_BRAND       CHAR(10) NOT NULL,
            P_TYPE        VARCHAR(25) NOT NULL,
            P_SIZE        INTEGER NOT NULL,
            P_CONTAINER   CHAR(10) NOT NULL,
            P_RETAILPRICE DECIMAL(15,2) NOT NULL,
            P_COMMENT     VARCHAR(23) NOT NULL,
            PRIMARY KEY (P_PARTKEY)
        )
    """,
    "supplier": """
        CREATE TABLE supplier (
            S_SUPPKEY     INTEGER NOT NULL,
            S_NAME        CHAR(25) NOT NULL,
            S_ADDRESS     VARCHAR(40) NOT NULL,
            S_NATIONKEY   INTEGER NOT NULL,
            S_PHONE       CHAR(15) NOT NULL,
            S_ACCTBAL     DECIMAL(15,2) NOT NULL,
            S_COMMENT     VARCHAR(101) NOT NULL,
            PRIMARY KEY (S_SUPPKEY)
        )
    """,
    "customer": """
        CREATE TABLE customer (
            C_CUSTKEY     INTEGER NOT NULL,
            C_NAME        VARCHAR(25) NOT NULL,
            C_ADDRESS     VARCHAR(40) NOT NULL,
            C_NATIONKEY   INTEGER NOT NULL,
            C_PHONE       CHAR(15) NOT NULL,
            C_ACCTBAL     DECIMAL(15,2) NOT NULL,
            C_MKTSEGMENT  CHAR(10) NOT NULL,
            C_COMMENT     VARCHAR(117) NOT NULL,
            PRIMARY KEY (C_CUSTKEY)
        )
    """,
    "partsupp": """
        CREATE TABLE partsupp (
            PS_PARTKEY     INTEGER NOT NULL,
            PS_SUPPKEY     INTEGER NOT NULL,
            PS_AVAILQTY    INTEGER NOT NULL,
            PS_SUPPLYCOST  DECIMAL(15,2) NOT NULL,
            PS_COMMENT     VARCHAR(199) NOT NULL,
            PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY)
        )
    """,
    "orders": """
        CREATE TABLE orders (
            O_ORDERKEY       INTEGER NOT NULL,
            O_CUSTKEY        INTEGER NOT NULL,
            O_ORDERSTATUS    CHAR(1) NOT NULL,
            O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
            O_ORDERDATE      DATE NOT NULL,
            O_ORDERPRIORITY  CHAR(15) NOT NULL,
            O_CLERK          CHAR(15) NOT NULL,
            O_SHIPPRIORITY   INTEGER NOT NULL,
            O_COMMENT        VARCHAR(79) NOT NULL,
            PRIMARY KEY (O_ORDERKEY)
        )
    """,
    "lineitem": """
        CREATE TABLE lineitem (
            L_ORDERKEY       INTEGER NOT NULL,
            L_PARTKEY        INTEGER NOT NULL,
            L_SUPPKEY        INTEGER NOT NULL,
            L_LINENUMBER     INTEGER NOT NULL,
            L_QUANTITY       DECIMAL(15,2) NOT NULL,
            L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
            L_DISCOUNT       DECIMAL(15,2) NOT NULL,
            L_TAX            DECIMAL(15,2) NOT NULL,
            L_RETURNFLAG     CHAR(1) NOT NULL,
            L_LINESTATUS     CHAR(1) NOT NULL,
            L_SHIPDATE       DATE NOT NULL,
            L_COMMITDATE     DATE NOT NULL,
            L_RECEIPTDATE    DATE NOT NULL,
            L_SHIPINSTRUCT   CHAR(25) NOT NULL,
            L_SHIPMODE       CHAR(10) NOT NULL,
            L_COMMENT        VARCHAR(44) NOT NULL,
            PRIMARY KEY (L_ORDERKEY, L_LINENUMBER)
        )
    """
}

# Foreign key constraints (based on dss.ri)
FK_CONSTRAINTS = [
    ("nation", "NATION_FK1", "N_REGIONKEY", "region", "R_REGIONKEY"),
    ("supplier", "SUPPLIER_FK1", "S_NATIONKEY", "nation", "N_NATIONKEY"),
    ("customer", "CUSTOMER_FK1", "C_NATIONKEY", "nation", "N_NATIONKEY"),
    ("partsupp", "PARTSUPP_FK1", "PS_SUPPKEY", "supplier", "S_SUPPKEY"),
    ("partsupp", "PARTSUPP_FK2", "PS_PARTKEY", "part", "P_PARTKEY"),
    ("orders", "ORDERS_FK1", "O_CUSTKEY", "customer", "C_CUSTKEY"),
    ("lineitem", "LINEITEM_FK1", "L_ORDERKEY", "orders", "O_ORDERKEY"),
    # Composite FK
    ("lineitem", "LINEITEM_FK2", "L_PARTKEY, L_SUPPKEY", "partsupp", "PS_PARTKEY, PS_SUPPKEY"),
]


def find_dbgen_binary():
    """Find the dbgen binary, checking common locations."""
    # Check in TPCH_DBGEN_DIR
    dbgen_path = os.path.join(TPCH_DBGEN_DIR, "dbgen")
    if os.path.isfile(dbgen_path) and os.access(dbgen_path, os.X_OK):
        return dbgen_path

    # Check for Windows executable
    dbgen_exe = os.path.join(TPCH_DBGEN_DIR, "dbgen.exe")
    if os.path.isfile(dbgen_exe):
        return dbgen_exe

    # Check if it's in PATH
    import shutil
    dbgen_in_path = shutil.which("dbgen")
    if dbgen_in_path:
        return dbgen_in_path

    return None


def scale_label(scale_factor: float) -> str:
    """Identifier-safe label for a scale factor: 5 -> "5", 0.5 -> "0_5"."""
    return f"{scale_factor:g}".replace(".", "_")


def scale_arg(scale_factor: float) -> str:
    """Scale factor as dbgen expects it on the command line: 5 -> "5"."""
    return f"{scale_factor:g}"


def generate_tpch_data(scale_factor: float, output_dir: str):
    """Generate TPC-H data files using dbgen."""
    dbgen = find_dbgen_binary()
    if not dbgen:
        print(f"ERROR: dbgen binary not found in {TPCH_DBGEN_DIR}")
        print("Please build dbgen first: cd tpch/tpch-dbgen && make")
        sys.exit(1)

    print(f"  Using dbgen: {dbgen}")
    print(f"  Output directory: {output_dir}")

    # Create output directory if needed
    os.makedirs(output_dir, exist_ok=True)

    # Run dbgen
    # -s: scale factor
    # -f: force overwrite
    # -v: verbose
    cmd = [dbgen, "-s", scale_arg(scale_factor), "-f", "-v"]

    print(f"  Running: {' '.join(cmd)}")

    try:
        # dbgen generates files in current directory, so we need to run from output_dir
        # But dbgen also needs dists.dss file in its directory
        # Solution: copy dists.dss to output_dir or run from dbgen dir and move files

        # Run from dbgen directory (where dists.dss is)
        result = subprocess.run(
            cmd,
            cwd=TPCH_DBGEN_DIR,
            capture_output=True,
            text=True,
            timeout=3600  # 1 hour timeout for large scale factors
        )

        if result.returncode != 0:
            print(f"  ERROR: dbgen failed with code {result.returncode}")
            print(f"  stderr: {result.stderr}")
            sys.exit(1)

        # Move generated .tbl files to output_dir if different
        if os.path.abspath(output_dir) != os.path.abspath(TPCH_DBGEN_DIR):
            import shutil
            for table in TABLE_ORDER:
                src = os.path.join(TPCH_DBGEN_DIR, f"{table}.tbl")
                dst = os.path.join(output_dir, f"{table}.tbl")
                if os.path.exists(src):
                    shutil.move(src, dst)
                    print(f"  Moved {table}.tbl")

        print("  Data generation complete")

    except subprocess.TimeoutExpired:
        print("  ERROR: dbgen timed out after 1 hour")
        sys.exit(1)
    except Exception as e:
        print(f"  ERROR: Failed to run dbgen: {e}")
        sys.exit(1)


def connect_to_mysql():
    """Connect to MySQL using config.py settings."""
    try:
        conn = mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            port=DB_PORT if DB_PORT else 3306,
            autocommit=True,
            allow_local_infile=True,
        )
        # Enable LOAD DATA LOCAL INFILE on server side
        cursor = conn.cursor()
        try:
            cursor.execute("SET GLOBAL local_infile = 1")
        except Error:
            pass  # May not have SUPER privilege
        cursor.close()
        return conn
    except Error as e:
        print(f"ERROR: MySQL connection failed: {e}")
        sys.exit(1)


def create_schema(cursor, schema_name: str):
    """Create the schema if it doesn't exist."""
    cursor.execute(f"CREATE DATABASE IF NOT EXISTS `{schema_name}`")
    cursor.execute(f"USE `{schema_name}`")
    print(f"  Created/using schema: {schema_name}")


def create_tables(cursor, schema_name: str):
    """Create all TPC-H tables with primary keys."""
    cursor.execute(f"USE `{schema_name}`")

    for table in TABLE_ORDER:
        # Drop if exists
        cursor.execute(f"DROP TABLE IF EXISTS `{table}`")
        # Create table
        cursor.execute(TABLE_DDL[table])
        print(f"  Created table: {table}")


def load_data(cursor, schema_name: str, data_dir: str):
    """Load data from .tbl files into tables."""
    cursor.execute(f"USE `{schema_name}`")
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0")

    for table in TABLE_ORDER:
        tbl_file = os.path.join(data_dir, f"{table}.tbl")
        if not os.path.exists(tbl_file):
            print(f"  WARNING: {tbl_file} not found, skipping {table}")
            continue

        # Get file size for progress indication
        file_size = os.path.getsize(tbl_file) / (1024 * 1024)  # MB

        print(f"  Loading {table} ({file_size:.1f} MB)...", end=" ", flush=True)
        start = time.time()

        # TPC-H .tbl files use | as delimiter and have trailing |
        load_sql = f"""
            LOAD DATA LOCAL INFILE '{tbl_file}'
            INTO TABLE `{table}`
            FIELDS TERMINATED BY '|'
            LINES TERMINATED BY '|\\n'
        """

        try:
            cursor.execute(load_sql)
            elapsed = time.time() - start

            # Get row count
            cursor.execute(f"SELECT COUNT(*) FROM `{table}`")
            row_count = cursor.fetchone()[0]

            print(f"{row_count:,} rows in {elapsed:.1f}s")
        except Error as e:
            print(f"FAILED: {e}")
            sys.exit(1)

    cursor.execute("SET FOREIGN_KEY_CHECKS = 1")


def add_foreign_keys(cursor, schema_name: str):
    """Add foreign key constraints."""
    cursor.execute(f"USE `{schema_name}`")

    for table, fk_name, fk_cols, ref_table, ref_cols in FK_CONSTRAINTS:
        sql = f"""
            ALTER TABLE `{table}`
            ADD CONSTRAINT `{fk_name}`
            FOREIGN KEY ({fk_cols}) REFERENCES `{ref_table}`({ref_cols})
        """
        try:
            cursor.execute(sql)
            print(f"  Added FK: {table}.{fk_cols} -> {ref_table}.{ref_cols}")
        except Error as e:
            print(f"  WARNING: Failed to add FK {fk_name}: {e}")


def analyze_tables(cursor, schema_name: str):
    """Run ANALYZE TABLE with full histogram sampling."""
    cursor.execute(f"USE `{schema_name}`")

    # Increase histogram memory to avoid sampling
    try:
        cursor.execute("SET GLOBAL histogram_generation_max_mem_size = 1000000000")
        cursor.fetchall()  # Consume any results
    except Error:
        pass  # May not have permission

    for table in TABLE_ORDER:
        print(f"  Analyzing {table}...", end=" ", flush=True)
        start = time.time()

        # Get all columns
        cursor.execute(f"SHOW COLUMNS FROM `{table}`")
        columns = [row[0] for row in cursor.fetchall()]

        # Update histogram on all columns
        cols_str = ", ".join(f"`{c}`" for c in columns)
        try:
            cursor.execute(f"ANALYZE TABLE `{table}` UPDATE HISTOGRAM ON {cols_str}")
            cursor.fetchall()  # Consume results from ANALYZE TABLE
            elapsed = time.time() - start
            print(f"done ({elapsed:.1f}s)")
        except Error as e:
            print(f"failed: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Setup TPC-H schema with data, PKs, FKs, and histograms"
    )
    parser.add_argument(
        "--scale-factor", "-s",
        type=float,
        required=True,
        help="TPC-H scale factor; fractional values are allowed (0.5, 1, 5, 10, ...)"
    )
    parser.add_argument(
        "--schema-name",
        type=str,
        default=None,
        help="Schema name (default: tpch_sf{N})"
    )
    parser.add_argument(
        "--data-dir",
        type=str,
        default=None,
        help="Directory for .tbl files (default: tpch/tpch-dbgen)"
    )
    parser.add_argument(
        "--skip-generate",
        action="store_true",
        help="Skip data generation (use existing .tbl files)"
    )
    parser.add_argument(
        "--skip-load",
        action="store_true",
        help="Skip data loading (tables must already exist with data)"
    )

    args = parser.parse_args()

    scale_factor = args.scale_factor
    schema_name = args.schema_name or f"tpch_sf{scale_label(scale_factor)}"
    data_dir = args.data_dir or TPCH_DBGEN_DIR

    print("=" * 60)
    print(f"TPC-H SCHEMA SETUP")
    print("=" * 60)
    print(f"Scale factor: {scale_factor}")
    print(f"Schema name:  {schema_name}")
    print(f"Data dir:     {data_dir}")
    print(f"DB host:      {HOST}:{DB_PORT or 3306}")
    print()

    # Step 1: Generate data
    if not args.skip_generate:
        print("[1/5] Generating TPC-H data...")
        generate_tpch_data(scale_factor, data_dir)
    else:
        print("[1/5] Skipping data generation (--skip-generate)")
    print()

    # Connect to MySQL
    conn = connect_to_mysql()
    cursor = conn.cursor()

    # Step 2: Create schema
    print("[2/5] Creating schema...")
    create_schema(cursor, schema_name)
    print()

    # Step 3: Create tables
    print("[3/5] Creating tables...")
    create_tables(cursor, schema_name)
    print()

    # Step 4: Load data
    if not args.skip_load:
        print("[4/5] Loading data...")
        load_data(cursor, schema_name, data_dir)
    else:
        print("[4/5] Skipping data loading (--skip-load)")
    print()

    # Step 5: Add foreign keys
    print("[5/5] Adding foreign keys...")
    add_foreign_keys(cursor, schema_name)
    print()

    # Step 6: Analyze tables
    print("[6/5] Analyzing tables (generating histograms)...")
    analyze_tables(cursor, schema_name)
    print()

    # Summary
    print("=" * 60)
    print("SETUP COMPLETE")
    print("=" * 60)
    print(f"Schema '{schema_name}' is ready.")
    print()
    print("To run DataGenX:")
    print(f"  PYTHONPATH=. python3 -u datagenx/orchestration/MasterRun.py \\")
    print(f"    --source-schema {schema_name} \\")
    print(f"    --target-schema {schema_name}_dbgenx \\")
    print(f"    --run-validation --compare-histograms")

    cursor.close()
    conn.close()


if __name__ == "__main__":
    main()
