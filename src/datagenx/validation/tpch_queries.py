#!/usr/bin/env python3
"""Render TPC-H dbgen query templates into runnable MySQL SQL files."""

import argparse
import re
from pathlib import Path


from datagenx.config import TPCH_TEMPLATE_DIR

DEFAULT_TEMPLATE_DIR = TPCH_TEMPLATE_DIR
DEFAULT_OUTPUT_DIR = Path("generated/tpch_queries_mysql")


TPCH_PARAMETERS = {
    "1": {"1": "90"},
    "2": {"1": "15", "2": "BRASS", "3": "EUROPE"},
    "3": {"1": "BUILDING", "2": "1995-03-15"},
    "4": {"1": "1993-07-01"},
    "5": {"1": "ASIA", "2": "1994-01-01"},
    "6": {"1": "1994-01-01", "2": "0.06", "3": "24"},
    "7": {"1": "FRANCE", "2": "GERMANY"},
    "8": {"1": "BRAZIL", "2": "AMERICA", "3": "ECONOMY ANODIZED STEEL"},
    "9": {"1": "green"},
    "10": {"1": "1993-10-01"},
    "11": {"1": "GERMANY", "2": "0.0001"},
    "12": {"1": "MAIL", "2": "SHIP", "3": "1994-01-01"},
    "13": {"1": "special", "2": "requests"},
    "14": {"1": "1995-09-01"},
    "15": {"1": "1996-01-01"},
    "16": {
        "1": "Brand#45",
        "2": "MEDIUM POLISHED",
        "3": "49",
        "4": "14",
        "5": "23",
        "6": "45",
        "7": "19",
        "8": "3",
        "9": "36",
        "10": "9",
    },
    "17": {"1": "Brand#23", "2": "MED BOX"},
    "18": {"1": "300"},
    "19": {"1": "Brand#12", "2": "Brand#23", "3": "Brand#34", "4": "1", "5": "10", "6": "20"},
    "20": {"1": "forest", "2": "1994-01-01", "3": "CANADA"},
    "21": {"1": "SAUDI ARABIA"},
    "22": {"1": "13", "2": "31", "3": "23", "4": "29", "5": "30", "6": "18", "7": "17"},
}


def strip_template_directives(sql_text):
    lines = []
    for line in sql_text.splitlines():
        stripped = line.strip()
        if stripped.startswith("--"):
            continue
        if re.fullmatch(r":[a-z](?:\s+.*)?", stripped):
            continue
        lines.append(line)
    return "\n".join(lines).strip()


def substitute_parameters(sql_text, params):
    rendered = sql_text
    for key in sorted(params, key=lambda item: len(item), reverse=True):
        rendered = rendered.replace(f":{key}", params[key])
    return rendered


def normalize_mysql_syntax(sql_text):
    sql_text = sql_text.replace("AIR REG", "REG AIR")
    sql_text = re.sub(r"interval\s+'([^']+)'\s+(day|month|year)", r"interval \1 \2", sql_text, flags=re.IGNORECASE)
    sql_text = re.sub(r"interval\s+(\d+)\s+day\s+\(\d+\)", r"interval \1 day", sql_text, flags=re.IGNORECASE)
    return sql_text


def convert_q15_to_cte(sql_text):
    view_match = re.search(
        r"create\s+view\s+revenue:s\s*\(supplier_no,\s*total_revenue\)\s+as\s*(.*?)\s*;\s*select",
        sql_text,
        flags=re.IGNORECASE | re.DOTALL,
    )
    if not view_match:
        return sql_text.replace("revenue:s", "revenue")

    view_query = view_match.group(1).strip()
    select_start = view_match.end() - len("select")
    select_sql = sql_text[select_start:]
    select_sql = re.sub(r"drop\s+view\s+revenue:s\s*;?", "", select_sql, flags=re.IGNORECASE).strip()
    select_sql = select_sql.replace("revenue:s", "revenue")
    return f"with revenue (supplier_no, total_revenue) as (\n{view_query}\n)\n{select_sql}"


def render_query(query_number, sql_text):
    params = TPCH_PARAMETERS[query_number]
    rendered = strip_template_directives(sql_text)
    rendered = substitute_parameters(rendered, params)
    if query_number == "15":
        rendered = convert_q15_to_cte(rendered)
    rendered = normalize_mysql_syntax(rendered)
    if not rendered.rstrip().endswith(";"):
        rendered += ";"
    return rendered + "\n"


def command_render(args):
    template_dir = Path(args.template_dir)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    rendered = []
    for query_number in sorted(TPCH_PARAMETERS, key=lambda value: int(value)):
        source_file = template_dir / f"{query_number}.sql"
        if not source_file.exists():
            print(f"Skipping q{query_number}: missing {source_file}")
            continue
        output_file = output_dir / f"q{query_number}.sql"
        output_file.write_text(render_query(query_number, source_file.read_text()))
        rendered.append(output_file)

    print(f"Rendered {len(rendered)} TPC-H querie(s) to {output_dir}")
    for output_file in rendered:
        print(f"  {output_file}")
    return 0


def build_parser():
    parser = argparse.ArgumentParser(description="Render TPC-H query templates into runnable MySQL SQL files.")
    parser.add_argument("--template-dir", default=str(DEFAULT_TEMPLATE_DIR))
    parser.add_argument("--output-dir", default=str(DEFAULT_OUTPUT_DIR))
    parser.set_defaults(func=command_render)
    return parser


def main():
    args = build_parser().parse_args()
    raise SystemExit(args.func(args))


if __name__ == "__main__":
    main()
