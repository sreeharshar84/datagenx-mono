#!/usr/bin/env python3
"""Build and apply source-literal to synthetic-literal mappings.

The mapping file is sensitive validation/debug metadata because it contains
source literals. Do not publish it with generated synthetic datasets.
"""

import argparse
import json
import re
from collections import defaultdict
from datetime import datetime, timedelta, timezone
from pathlib import Path

import mysql.connector

from datagenx.config import HOST, PASSWORD, SOURCE_SCHEMA, TARGET_SCHEMA, USER
from datagenx.generation.GenerateDbgen import (
    CHAR_TYPES,
    DATETIME_TYPES,
    SYNTHETIC_BASE_DATE,
    get_string_column_length,
    get_string_column_values,
    synthetic_string_value,
)


DEFAULT_OUTPUT_DIR = Path("generated/literal_mappings")


def connect(args):
    return mysql.connector.connect(
        host=args.host,
        user=args.user,
        password=args.password,
        autocommit=True,
    )


def get_tables(cursor, schema):
    cursor.execute(
        """
        SELECT TABLE_NAME
        FROM information_schema.tables
        WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_NAME
        """,
        (schema,),
    )
    return [row[0] for row in cursor.fetchall()]


def get_char_columns(cursor, schema, table):
    cursor.execute(
        """
        SELECT COLUMN_NAME, COLUMN_TYPE
        FROM information_schema.columns
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
        ORDER BY ORDINAL_POSITION
        """,
        (schema, table),
    )
    columns = []
    for column, col_type in cursor.fetchall():
        base_type = col_type.split("(", 1)[0].lower()
        if base_type in CHAR_TYPES:
            columns.append((column, col_type))
    return columns


def get_date_columns(cursor, schema, table):
    cursor.execute(
        """
        SELECT COLUMN_NAME, COLUMN_TYPE
        FROM information_schema.columns
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
        ORDER BY ORDINAL_POSITION
        """,
        (schema, table),
    )
    columns = []
    for column, col_type in cursor.fetchall():
        base_type = col_type.split("(", 1)[0].lower()
        if base_type in DATETIME_TYPES:
            columns.append((column, base_type))
    return columns


def mapping_output_path(source_schema, target_schema):
    return DEFAULT_OUTPUT_DIR / f"{source_schema}_to_{target_schema}.json"


def build_literal_mapping(cursor, source_schema, target_schema):
    mappings = {}
    date_mappings = {}
    for table in get_tables(cursor, source_schema):
        for column, col_type in get_char_columns(cursor, source_schema, table):
            values = get_string_column_values(cursor, source_schema, table, column)
            if not values:
                continue

            max_length = get_string_column_length(f"`{column}` {col_type}")
            entries = []
            for ordinal, (source_literal, pseudo_count) in enumerate(values, start=1):
                target_literal = synthetic_string_value(
                    column,
                    ordinal,
                    source_value=source_literal,
                    max_length=max_length,
                )
                entries.append(
                    {
                        "source_literal": source_literal,
                        "target_literal": target_literal,
                        "rank": ordinal,
                        "pseudo_count": pseudo_count,
                    }
                )

            if entries:
                mappings[f"{table}.{column}"] = entries

        for column, base_type in get_date_columns(cursor, source_schema, table):
            if base_type != "date":
                continue
            cursor.execute(f"SELECT MIN(`{column}`), MAX(`{column}`) FROM `{source_schema}`.`{table}`")
            source_min, source_max = cursor.fetchone()
            if source_min is None or source_max is None:
                continue
            date_mappings[f"{table}.{column}"] = {
                "source_min": str(source_min),
                "source_max": str(source_max),
                "target_base": SYNTHETIC_BASE_DATE,
                "type": base_type,
            }

    return {
        "meta": {
            "source_schema": source_schema,
            "target_schema": target_schema,
            "created_at_utc": datetime.now(timezone.utc).isoformat(),
            "sensitive": True,
            "warning": "Contains source literals. Use only for local validation/query rewriting.",
        },
        "mappings": mappings,
        "date_mappings": date_mappings,
    }


def load_mapping(path):
    return json.loads(Path(path).read_text())


def unique_literal_index(mapping):
    by_source = defaultdict(set)
    for entries in mapping.get("mappings", {}).values():
        for entry in entries:
            by_source[entry["source_literal"]].add(entry["target_literal"])

    unique = {}
    ambiguous = {}
    for source_literal, target_literals in by_source.items():
        if len(target_literals) == 1:
            unique[source_literal] = next(iter(target_literals))
        else:
            ambiguous[source_literal] = sorted(target_literals)
    return unique, ambiguous


def date_column_index(mapping):
    by_column = {}
    for qualified, info in mapping.get("date_mappings", {}).items():
        column = qualified.rsplit(".", 1)[-1]
        by_column.setdefault(column, []).append(info)
    return {
        column: infos[0]
        for column, infos in by_column.items()
        if len(infos) == 1
    }


def sql_unescape(value):
    return value.replace("''", "'").replace("\\'", "'")


def sql_escape(value):
    return value.replace("\\", "\\\\").replace("'", "''")


def map_date_literal(date_text, info):
    source_min = datetime.strptime(info["source_min"][:10], "%Y-%m-%d").date()
    source_date = datetime.strptime(date_text, "%Y-%m-%d").date()
    target_base = datetime.strptime(info["target_base"], "%Y-%m-%d").date()
    offset = (source_date - source_min).days
    return (target_base + timedelta(days=offset)).isoformat()


def rewrite_sql_dates(sql_text, mapping):
    date_index = date_column_index(mapping)
    rewritten = 0

    def column_name(raw_column):
        return raw_column.split(".")[-1].strip("`")

    between_pattern = re.compile(
        r"(?P<column>`?\w+`?(?:\.`?\w+`?)?)\s+between\s+date\s+'(?P<start>\d{4}-\d{2}-\d{2})'\s+and\s+date\s+'(?P<end>\d{4}-\d{2}-\d{2})'",
        flags=re.IGNORECASE,
    )

    def replace_between(match):
        nonlocal rewritten
        col = column_name(match.group("column"))
        if col not in date_index:
            return match.group(0)
        rewritten += 2
        start = map_date_literal(match.group("start"), date_index[col])
        end = map_date_literal(match.group("end"), date_index[col])
        return f"{match.group('column')} between date '{start}' and date '{end}'"

    sql_text = between_pattern.sub(replace_between, sql_text)

    comparison_pattern = re.compile(
        r"(?P<column>`?\w+`?(?:\.`?\w+`?)?)\s*(?P<op>=|<=|>=|<|>)\s*date\s+'(?P<date>\d{4}-\d{2}-\d{2})'",
        flags=re.IGNORECASE,
    )

    def replace_comparison(match):
        nonlocal rewritten
        col = column_name(match.group("column"))
        if col not in date_index:
            return match.group(0)
        rewritten += 1
        mapped = map_date_literal(match.group("date"), date_index[col])
        return f"{match.group('column')} {match.group('op')} date '{mapped}'"

    return comparison_pattern.sub(replace_comparison, sql_text), rewritten


def rewrite_sql_literals(sql_text, mapping):
    literal_map, ambiguous = unique_literal_index(mapping)
    rewritten = 0
    skipped_ambiguous = set()

    pattern = re.compile(r"'((?:''|\\'|[^'])*)'")

    def replace(match):
        nonlocal rewritten
        literal = sql_unescape(match.group(1))
        if literal in ambiguous:
            skipped_ambiguous.add(literal)
            return match.group(0)
        if literal not in literal_map:
            return match.group(0)
        rewritten += 1
        return f"'{sql_escape(literal_map[literal])}'"

    rewritten_sql = pattern.sub(replace, sql_text)
    rewritten_sql, rewritten_dates = rewrite_sql_dates(rewritten_sql, mapping)
    return rewritten_sql, {
        "rewritten_literals": rewritten,
        "rewritten_dates": rewritten_dates,
        "skipped_ambiguous_literals": sorted(skipped_ambiguous),
    }


def command_build(args):
    conn = connect(args)
    cursor = conn.cursor()
    try:
        mapping = build_literal_mapping(cursor, args.source_schema, args.target_schema)
    finally:
        cursor.close()
        conn.close()

    output = Path(args.output) if args.output else mapping_output_path(args.source_schema, args.target_schema)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(mapping, indent=2, sort_keys=True))
    total = sum(len(entries) for entries in mapping["mappings"].values())
    print(f"Wrote literal mapping to {output}")
    print(f"Mapped {total} literal(s) across {len(mapping['mappings'])} column(s)")
    print("WARNING: mapping contains source literals; keep it local/private.")
    return 0


def command_rewrite(args):
    mapping = load_mapping(args.mapping_file)
    sql_text = Path(args.query_file).read_text() if args.query_file else args.sql
    rewritten_sql, stats = rewrite_sql_literals(sql_text, mapping)

    if args.output_file:
        Path(args.output_file).write_text(rewritten_sql)
        print(f"Wrote rewritten SQL to {args.output_file}")
    else:
        print(rewritten_sql)

    print(f"-- rewritten literals: {stats['rewritten_literals']}")
    print(f"-- rewritten dates: {stats['rewritten_dates']}")
    if stats["skipped_ambiguous_literals"]:
        print(f"-- skipped ambiguous literals: {', '.join(stats['skipped_ambiguous_literals'])}")
    return 0


def build_parser():
    parser = argparse.ArgumentParser(description="Build or apply source-to-synthetic literal mappings.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    build = subparsers.add_parser("build", help="Build a literal mapping from source histogram metadata")
    build.add_argument("--host", default=HOST)
    build.add_argument("--user", default=USER)
    build.add_argument("--password", default=PASSWORD)
    build.add_argument("--source-schema", default=SOURCE_SCHEMA)
    build.add_argument("--target-schema", default=TARGET_SCHEMA)
    build.add_argument("--output")
    build.set_defaults(func=command_build)

    rewrite = subparsers.add_parser("rewrite", help="Rewrite SQL string literals using a mapping file")
    rewrite.add_argument("--mapping-file", required=True)
    rewrite_input = rewrite.add_mutually_exclusive_group(required=True)
    rewrite_input.add_argument("--query-file")
    rewrite_input.add_argument("--sql")
    rewrite.add_argument("--output-file")
    rewrite.set_defaults(func=command_rewrite)

    return parser


def main():
    args = build_parser().parse_args()
    raise SystemExit(args.func(args))


if __name__ == "__main__":
    main()
