#!/usr/bin/env python3
"""
Generate INSERT statements from .dbgen files using dbgen binary.
Engineer-facing tool - fully standalone, no database connection required.
"""

import argparse
import os
import subprocess
import sys


def find_dbgen_binary():
    """Try to locate dbgen binary in common locations."""
    common_paths = [
        os.path.expanduser("~/dbgen_binary"),
        "/usr/local/bin/dbgen",
        "/usr/bin/dbgen",
        os.path.expanduser("~/dbgen/target/release/dbgen"),
        "./dbgen",
    ]

    for path in common_paths:
        if os.path.isfile(path) and os.access(path, os.X_OK):
            return path

    return None


def main():
    parser = argparse.ArgumentParser(
        description='Generate INSERT statements from .dbgen template files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  # Generate 100K rows
  %(prog)s --input-dir dbgen_files/ --rows 100000

  # Generate 1M rows with custom output location
  %(prog)s --input-dir dbgen_files/ --output-dir sql_output/ --rows 1000000

  # Specify dbgen binary location
  %(prog)s --input-dir dbgen_files/ --rows 10000 --dbgen-binary /path/to/dbgen
        '''
    )

    parser.add_argument('--input-dir', default='dbgen_files',
                        help='Input directory containing .dbgen files')
    parser.add_argument('--output-dir', default='dbgen_tmp_out',
                        help='Output directory for .sql files')
    parser.add_argument('--rows', type=int, default=1000,
                        help='Number of rows to generate per table')
    parser.add_argument('--dbgen-binary',
                        help='Path to dbgen binary (auto-detected if not specified)')
    parser.add_argument('--files-count', default='1',
                        help='Number of files to generate (default: 1)')
    parser.add_argument('--format', choices=['sql', 'csv'], default='csv',
                        help='Output format (default: csv)')
    parser.add_argument('--verbose', action='store_true',
                        help='Show verbose output')

    args = parser.parse_args()

    # Find dbgen binary
    dbgen_binary = args.dbgen_binary
    if not dbgen_binary:
        dbgen_binary = find_dbgen_binary()
        if not dbgen_binary:
            print("Error: Could not find dbgen binary.", file=sys.stderr)
            print("Please specify --dbgen-binary or install dbgen in a standard location.", file=sys.stderr)
            sys.exit(1)
        if args.verbose:
            print(f"Found dbgen binary: {dbgen_binary}")

    # Verify dbgen binary exists and is executable
    if not os.path.isfile(dbgen_binary):
        print(f"Error: dbgen binary not found at {dbgen_binary}", file=sys.stderr)
        sys.exit(1)
    if not os.access(dbgen_binary, os.X_OK):
        print(f"Error: dbgen binary at {dbgen_binary} is not executable", file=sys.stderr)
        sys.exit(1)

    # Verify input directory exists
    if not os.path.isdir(args.input_dir):
        print(f"Error: Input directory {args.input_dir} does not exist", file=sys.stderr)
        sys.exit(1)

    # Find all .dbgen files
    dbgen_files = [f for f in os.listdir(args.input_dir) if f.endswith('.dbgen')]
    if not dbgen_files:
        print(f"Error: No .dbgen files found in {args.input_dir}", file=sys.stderr)
        sys.exit(1)

    print(f"Found {len(dbgen_files)} .dbgen file(s) in {args.input_dir}")

    # Create output directory
    os.makedirs(args.output_dir, exist_ok=True)

    # Process each .dbgen file
    success_count = 0
    for dbgen_file in sorted(dbgen_files):
        table_name = dbgen_file[:-6]  # Remove .dbgen extension
        template_path = os.path.join(args.input_dir, dbgen_file)

        print(f"\nProcessing {table_name}...")

        cmd = [
            dbgen_binary,
            "--out-dir", args.output_dir,
            "--files-count", args.files_count,
            "--rows-per-file", str(args.rows),
            "--rows-count", str(args.rows),
            "--template", template_path,
            "--format", args.format,
            "--quiet",
        ]
        if args.verbose:
            print(f"  Command: {' '.join(cmd)}")

        try:
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            if args.verbose and result.stdout:
                print(f"  Output: {result.stdout}")
            print(f"  ✓ Generated {args.rows} rows for {table_name}")
            success_count += 1
        except subprocess.CalledProcessError as e:
            print(f"  ✗ Failed to generate data for {table_name}")
            if e.stderr:
                print(f"    Error: {e.stderr}", file=sys.stderr)
            continue

    # Summary
    print(f"\n{'='*60}")
    print(f"Summary: {success_count}/{len(dbgen_files)} tables processed successfully")
    print(f"Output location: {args.output_dir}/")

    if success_count < len(dbgen_files):
        sys.exit(1)


if __name__ == "__main__":
    main()
