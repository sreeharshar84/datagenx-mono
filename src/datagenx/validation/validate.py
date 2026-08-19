#!/usr/bin/env python3
"""
Unified validation CLI for DataGenX outputs.

This script intentionally delegates to the existing validation scripts so their
behavior stays unchanged while providing one organized entry point.
"""

import argparse
import re
import subprocess
import sys
import tempfile
from pathlib import Path

from datagenx.config import HOST, PASSWORD, SOURCE_SCHEMA, TARGET_SCHEMA, USER


REPO_ROOT = Path(__file__).resolve().parents[2]
SQL_VALIDATION_FILE = REPO_ROOT / "sql" / "data_validation.sql"


def run_script(script, args):
    module = f"datagenx.validation.{Path(script).stem}"
    cmd = [sys.executable, "-m", module, *args]
    print("+ " + " ".join(cmd), flush=True)
    return subprocess.run(cmd, cwd=REPO_ROOT).returncode


def add_connection_args(parser):
    parser.add_argument("--host", default=HOST)
    parser.add_argument("--user", default=USER)
    parser.add_argument("--password", default=PASSWORD)
    parser.add_argument("--source-schema", default=SOURCE_SCHEMA)
    parser.add_argument("--target-schema", default=TARGET_SCHEMA)


def add_sql_connection_args(parser):
    parser.add_argument("--host", default=HOST)
    parser.add_argument("--user", default=USER)
    parser.add_argument("--password", default=PASSWORD)
    parser.add_argument("--source-schema")
    parser.add_argument("--target-schema")


def stats_args(args):
    cmd = [
        "--host", args.host,
        "--user", args.user,
        "--password", args.password,
        "--source-schema", args.source_schema,
        "--target-schema", args.target_schema,
    ]
    if args.table:
        cmd.extend(["--table", args.table])
    if args.skip_distinct:
        cmd.append("--skip-distinct")
    if args.verbose:
        cmd.append("--verbose")
    return cmd


def replay_args(args):
    cmd = [
        "--host", args.host,
        "--user", args.user,
        "--password", args.password,
        "--source-schema", args.source_schema,
        "--ddl-file", args.ddl_file,
        "--insert-file", args.insert_file,
    ]
    if args.keep_schema:
        cmd.append("--keep-schema")
    return cmd


def plan_args(args):
    cmd = [
        "--host", args.host,
        "--user", args.user,
        "--password", args.password,
        "--source-schema", args.source_schema,
        "--target-schema", args.target_schema,
    ]
    if args.queries_dir:
        cmd.extend(["--queries-dir", args.queries_dir])
    if args.output_file:
        cmd.extend(["--output-file", args.output_file])
    if args.literal_mapping_file:
        cmd.extend(["--literal-mapping-file", args.literal_mapping_file])
    return cmd


def query_args(args):
    cmd = [
        args.query,
        "--host", args.host,
        "--user", args.user,
        "--password", args.password,
        "--source-schema", args.source_schema,
        "--target-schema", args.target_schema,
    ]
    if args.queries_dir:
        cmd.extend(["--queries-dir", args.queries_dir])
    if args.literal_mapping_file:
        cmd.extend(["--literal-mapping-file", args.literal_mapping_file])
    return cmd


def command_stats(args):
    return run_script("ValidateTableStats.py", stats_args(args))


def command_replay(args):
    return run_script("PopulateNewTableAndValidate.py", replay_args(args))


def command_sakila_replay(args):
    return run_script("replay_and_validate_sakila.py", replay_args(args))


def command_plans(args):
    return run_script("run_tpch_comparison.py", plan_args(args))


def command_query(args):
    return run_script("run_single_query.py", query_args(args))


def command_literal_map(args):
    cmd = [
        "build",
        "--host", args.host,
        "--user", args.user,
        "--password", args.password,
        "--source-schema", args.source_schema,
        "--target-schema", args.target_schema,
    ]
    if args.output:
        cmd.extend(["--output", args.output])
    return run_script("literal_mapping.py", cmd)


def command_rewrite_query(args):
    cmd = ["rewrite", "--mapping-file", args.mapping_file]
    if args.query_file:
        cmd.extend(["--query-file", args.query_file])
    else:
        cmd.extend(["--sql", args.sql])
    if args.output_file:
        cmd.extend(["--output-file", args.output_file])
    return run_script("literal_mapping.py", cmd)


def command_tpch_queries(args):
    cmd = []
    if args.template_dir:
        cmd.extend(["--template-dir", args.template_dir])
    if args.output_dir:
        cmd.extend(["--output-dir", args.output_dir])
    return run_script("tpch_queries.py", cmd)


def command_all(args):
    code = command_stats(args)
    if code != 0:
        return code
    return command_plans(args)


def quote_identifier(name):
    if not name or not re.fullmatch(r"[A-Za-z0-9_]+", name):
        raise ValueError(f"Unsafe MySQL identifier: {name!r}")
    return f"`{name}`"


def strip_non_sql_preamble(sql_text):
    first_comment = sql_text.find("--")
    first_select = sql_text.lower().find("select")
    starts = [pos for pos in (first_comment, first_select) if pos >= 0]
    if not starts:
        return sql_text
    return sql_text[min(starts):]


def benchmark_sql_block(sql_text, benchmark):
    marker = {
        "tpch": "TPC-H SYNTHETIC DATA VALIDATION SQL",
        "tpcds": "TPC-DS SYNTHETIC DATA VALIDATION SQL",
    }[benchmark]
    start = sql_text.find(marker)
    if start < 0:
        raise ValueError(f"Could not find {benchmark} validation block in {SQL_VALIDATION_FILE}")
    start = sql_text.rfind("\n", 0, start) + 1

    next_marker = sql_text.find("SYNTHETIC DATA VALIDATION SQL", start + len(marker))
    if next_marker >= 0:
        line_start = sql_text.rfind("\n", 0, next_marker)
        return sql_text[start:line_start]
    return sql_text[start:]


def remove_source_artifacts(sql_text):
    clean_lines = []
    for line in sql_text.splitlines():
        if re.fullmatch(r"\s*\d+\s*\|\s*", line):
            continue
        clean_lines.append(line)
    return "\n".join(clean_lines)


def has_sql_content(sql_text):
    for line in sql_text.splitlines():
        stripped = line.strip()
        if stripped and not stripped.startswith("--"):
            return True
    return False


def complete_statements(sql_text):
    statements = []
    current = []
    in_single = False
    in_double = False
    in_backtick = False
    escape = False

    for char in sql_text:
        current.append(char)

        if escape:
            escape = False
            continue
        if char == "\\" and (in_single or in_double):
            escape = True
            continue
        if char == "'" and not in_double and not in_backtick:
            in_single = not in_single
        elif char == '"' and not in_single and not in_backtick:
            in_double = not in_double
        elif char == "`" and not in_single and not in_double:
            in_backtick = not in_backtick
        elif char == ";" and not in_single and not in_double and not in_backtick:
            statement = "".join(current).strip()
            if statement:
                statements.append(statement)
            current = []

    remainder = "".join(current).strip()
    return statements, remainder


def render_sql_validation(args):
    source_schema = args.source_schema or args.benchmark
    target_schema = args.target_schema or f"{args.benchmark}_harsha"

    sql_text = SQL_VALIDATION_FILE.read_text()
    sql_text = strip_non_sql_preamble(sql_text)
    sql_text = benchmark_sql_block(sql_text, args.benchmark)
    sql_text = remove_source_artifacts(sql_text)
    statements, remainder = complete_statements(sql_text)

    rendered = "\n\n".join(statements)
    rendered = rendered.replace("`src`.", f"{quote_identifier(source_schema)}.")
    rendered = rendered.replace("`gen`.", f"{quote_identifier(target_schema)}.")

    header = [
        f"-- DataGenX SQL validation for {args.benchmark}",
        f"-- source schema: {source_schema}",
        f"-- target schema: {target_schema}",
        "SET time_zone = '+00:00';",
    ]
    if has_sql_content(remainder):
        header.append("-- WARNING: ignored an incomplete trailing SQL statement from data_validation.sql")

    return "\n".join(header) + "\n\n" + rendered + "\n"


def command_sql(args):
    try:
        rendered_sql = render_sql_validation(args)
    except ValueError as exc:
        print(f"SQL validation setup failed: {exc}")
        return 2

    if args.render_only:
        output = Path(args.output_sql) if args.output_sql else REPO_ROOT / f"{args.benchmark}_validation_rendered.sql"
        output.write_text(rendered_sql)
        print(f"Rendered SQL validation to {output}")
        return 0

    cmd = [
        args.mysql_binary,
        "-h", args.host,
        "-u", args.user,
        f"-p{args.password}",
        "--table",
    ]
    print("+ " + " ".join(cmd[:5] + ["-p********", "--table"]), flush=True)
    with tempfile.NamedTemporaryFile("w", suffix=".sql", delete=False) as tmp:
        tmp.write(rendered_sql)
        tmp_path = tmp.name

    try:
        sql = Path(tmp_path).read_text()
        return subprocess.run(cmd, input=sql, text=True, cwd=REPO_ROOT).returncode
    finally:
        Path(tmp_path).unlink(missing_ok=True)


def build_parser():
    parser = argparse.ArgumentParser(
        description="Run DataGenX validations from one organized entry point."
    )
    add_connection_args(parser)
    parser.add_argument("--table", help="Validate one table in the stats mode")
    parser.add_argument("--skip-distinct", action="store_true",
                        help="Skip distinct count comparison in stats mode")
    parser.add_argument("--verbose", "-v", action="store_true",
                        help="Show verbose stats validation output")

    subparsers = parser.add_subparsers(dest="command")

    stats = subparsers.add_parser("stats", help="Compare source and target schema statistics")
    add_connection_args(stats)
    stats.add_argument("--table")
    stats.add_argument("--skip-distinct", action="store_true")
    stats.add_argument("--verbose", "-v", action="store_true")
    stats.set_defaults(func=command_stats)

    replay = subparsers.add_parser("replay", help="Replay one generated table and validate it")
    add_connection_args(replay)
    replay.add_argument("--ddl-file", required=True)
    replay.add_argument("--insert-file", required=True)
    replay.add_argument("--keep-schema", action="store_true")
    replay.set_defaults(func=command_replay)

    sakila = subparsers.add_parser("sakila-replay", help="Run the Sakila replay validator")
    add_connection_args(sakila)
    sakila.add_argument("--ddl-file", required=True)
    sakila.add_argument("--insert-file", required=True)
    sakila.add_argument("--keep-schema", action="store_true")
    sakila.set_defaults(func=command_sakila_replay)

    plans = subparsers.add_parser("plans", help="Compare TPC-H EXPLAIN plan shapes")
    add_connection_args(plans)
    plans.add_argument("--queries-dir")
    plans.add_argument("--output-file")
    plans.add_argument("--literal-mapping-file",
                       help="Rewrite target-side string literals using this sensitive mapping file")
    plans.set_defaults(func=command_plans)

    sql = subparsers.add_parser("sql", help="Run benchmark-specific SQL validation checks")
    add_sql_connection_args(sql)
    sql.add_argument("benchmark", choices=("tpch", "tpcds"),
                     help="Run only this benchmark's block from data_validation.sql")
    sql.add_argument("--mysql-binary", default="mysql")
    sql.add_argument("--render-only", action="store_true",
                     help="Write the benchmark-specific SQL file instead of executing it")
    sql.add_argument("--output-sql",
                     help="Path used with --render-only")
    sql.set_defaults(func=command_sql)

    query = subparsers.add_parser("query", help="Explain and compare one TPC-H query")
    add_connection_args(query)
    query.add_argument("query", help="Query prefix, for example q3 or q11")
    query.add_argument("--queries-dir")
    query.add_argument("--literal-mapping-file",
                       help="Rewrite target-side string literals using this sensitive mapping file")
    query.set_defaults(func=command_query)

    literal_map = subparsers.add_parser(
        "literal-map",
        help="Build a sensitive source-literal to synthetic-literal mapping file",
    )
    add_connection_args(literal_map)
    literal_map.add_argument("--output")
    literal_map.set_defaults(func=command_literal_map)

    rewrite_query = subparsers.add_parser(
        "rewrite-query",
        help="Rewrite SQL string literals using a sensitive literal mapping file",
    )
    rewrite_query.add_argument("--mapping-file", required=True)
    rewrite_input = rewrite_query.add_mutually_exclusive_group(required=True)
    rewrite_input.add_argument("--query-file")
    rewrite_input.add_argument("--sql")
    rewrite_query.add_argument("--output-file")
    rewrite_query.set_defaults(func=command_rewrite_query)

    tpch_queries = subparsers.add_parser(
        "tpch-queries",
        help="Render original TPC-H query templates into runnable MySQL SQL files",
    )
    tpch_queries.add_argument("--template-dir", default="/home/hmaduri/contribs/tpch-dbgen/queries")
    tpch_queries.add_argument("--output-dir", default="generated/tpch_queries_mysql")
    tpch_queries.set_defaults(func=command_tpch_queries)

    all_checks = subparsers.add_parser("all", help="Run stats validation, then plan comparison")
    add_connection_args(all_checks)
    all_checks.add_argument("--table")
    all_checks.add_argument("--skip-distinct", action="store_true")
    all_checks.add_argument("--verbose", "-v", action="store_true")
    all_checks.add_argument("--queries-dir")
    all_checks.add_argument("--output-file")
    all_checks.add_argument("--literal-mapping-file",
                            help="Rewrite target-side string literals for plan comparison")
    all_checks.set_defaults(func=command_all)

    parser.set_defaults(func=command_stats)
    return parser


def main():
    parser = build_parser()
    args = parser.parse_args()
    sys.exit(args.func(args))


if __name__ == "__main__":
    main()
