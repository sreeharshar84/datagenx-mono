import re
import sys
import types
import unittest
from collections import Counter, defaultdict


mysql_pkg = types.ModuleType("mysql")
connector_mod = types.ModuleType("mysql.connector")


class Error(Exception):
    pass


connector_mod.Error = Error
connector_mod.connect = lambda **kwargs: None
mysql_pkg.connector = connector_mod
sys.modules.setdefault("mysql", mysql_pkg)
sys.modules.setdefault("mysql.connector", connector_mod)

from datagenx.generation.GenerateDbgen import topological_sort
import datagenx.orchestration.MasterRun as masterrun
from datagenx.orchestration.MasterRun import discover_tables_and_dependencies


class FakeCursor:
    def __init__(self):
        self._rows = []

    def execute(self, sql, params=None):
        if "FROM INFORMATION_SCHEMA.TABLES" in sql:
            self._rows = [(table,) for table in [
                "catalog_returns",
                "catalog_sales",
                "customer",
                "date_dim",
                "item",
                "store_returns",
                "store_sales",
                "web_returns",
                "web_sales",
            ]]
        elif "FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE" in sql:
            # Simulate benchmark source DDL without physical FK metadata.
            self._rows = []
        elif "FROM INFORMATION_SCHEMA.COLUMNS" in sql:
            columns = {
                "catalog_returns": ["cr_item_sk", "cr_order_number"],
                "catalog_sales": ["cs_item_sk", "cs_order_number"],
                "customer": ["c_customer_sk"],
                "date_dim": ["d_date_sk"],
                "item": ["i_item_sk"],
                "store_returns": ["sr_item_sk", "sr_ticket_number"],
                "store_sales": ["ss_item_sk", "ss_ticket_number"],
                "web_returns": ["wr_item_sk", "wr_order_number"],
                "web_sales": ["ws_item_sk", "ws_order_number"],
            }
            self._rows = [
                (table, column)
                for table, table_columns in columns.items()
                for column in table_columns
            ]
        else:
            raise AssertionError(f"Unexpected SQL: {sql}")

    def fetchall(self):
        return self._rows


class MasterRunDependencyTests(unittest.TestCase):
    def test_tpcds_fallback_dependencies_include_return_sales_composite_fks(self):
        tables, dependencies = discover_tables_and_dependencies(FakeCursor(), "src")
        sorted_tables = topological_sort(tables, dependencies)

        self.assertIn("catalog_sales", dependencies["catalog_returns"])
        self.assertIn("store_sales", dependencies["store_returns"])
        self.assertIn("web_sales", dependencies["web_returns"])
        self.assertLess(sorted_tables.index("catalog_sales"), sorted_tables.index("catalog_returns"))
        self.assertLess(sorted_tables.index("store_sales"), sorted_tables.index("store_returns"))
        self.assertLess(sorted_tables.index("web_sales"), sorted_tables.index("web_returns"))


class PartialFkPkAppendageCursor:
    def __init__(self):
        self.queries = []
        self._row = None
        self._rows = []

    def execute(self, sql, params=None):
        self.queries.append((sql, params))
        normalized = " ".join(sql.split())
        table = params[1] if params and len(params) > 1 else None

        if "FROM INFORMATION_SCHEMA.TABLES" in normalized:
            self._rows = [("item",), ("sales",)]
        elif normalized == "SELECT COUNT(*), COUNT(DISTINCT `item_sk`), MIN(`item_sk`), COUNT(DISTINCT `order_no`) FROM `tgt`.`sales`":
            self._row = (1000, 5, 1, 200)
            self._rows = [self._row]
        elif "REFERENCED_TABLE_NAME IS NOT NULL" in normalized:
            if table == "sales":
                self._rows = [("sales_item_fk", "item_sk", "item", "item_sk")]
            elif table == "returns":
                self._rows = [
                    ("returns_sales_fk", "item_sk", "sales", "item_sk"),
                    ("returns_sales_fk", "order_no", "sales", "order_no"),
                ]
            else:
                self._rows = []
        elif "CONSTRAINT_NAME = 'PRIMARY'" in normalized:
            if table in {"sales", "returns"}:
                self._rows = [("item_sk",), ("order_no",)]
            else:
                self._rows = []
        elif normalized == "SELECT COUNT(*) FROM `src`.`sales`":
            self._row = (1000,)
            self._rows = [self._row]
        elif normalized == "SELECT COUNT(*) FROM `src`.`returns`":
            self._row = (30,)
            self._rows = [self._row]
        elif "FROM INFORMATION_SCHEMA.COLUMNS" in normalized:
            self._row = ("int",)
            self._rows = [self._row]
        elif normalized == "SELECT COUNT(DISTINCT `order_no`) FROM `src`.`sales`":
            self._row = (200,)
            self._rows = [self._row]
        elif normalized == "SELECT COUNT(DISTINCT `item_sk`) FROM `src`.`sales`":
            self._row = (5,)
            self._rows = [self._row]
        elif normalized == "SELECT COUNT(DISTINCT `item_sk`) FROM `src`.`returns`":
            self._row = (5,)
            self._rows = [self._row]
        elif "SELECT COUNT(DISTINCT `item_sk`), MIN(`item_sk`), MAX(`item_sk`)" in normalized:
            self._row = (5, 1, 5)
            self._rows = [self._row]
        elif "SELECT frequency, COUNT(*) AS value_count" in normalized:
            if "FROM `src`.`sales`" in normalized:
                self._rows = [(200, 5)]
            elif "FROM `src`.`returns`" in normalized:
                self._rows = [(6, 5)]
            else:
                self._rows = []
            self._row = self._rows[0]
        else:
            raise AssertionError(f"Unexpected SQL: {sql}")

    def fetchone(self):
        return self._row

    def fetchall(self):
        return self._rows



# Groups shaped like TPC-H lineitem: parents holding 1, 2 or 3 children.
# Rows = 1*4 + 2*4 + 3*4 = 24; distinct parents = 12; partner max = 3.
MULTI_GROUPS = [(1, 4), (2, 4), (3, 4)]
MULTI_ROWS = sum(f * c for f, c in MULTI_GROUPS)
MULTI_DISTINCT = sum(c for _f, c in MULTI_GROUPS)
MULTI_PARTNER_DISTINCT = max(f for f, _c in MULTI_GROUPS)


class MultiGroupFkPkAppendageCursor(PartialFkPkAppendageCursor):
    """Same schema shape, but the FK has several distinct group sizes.

    A single frequency group cannot distinguish a per-group ordinal from a
    global cycle, which is why the regression this covers went unnoticed.
    """

    def execute(self, sql, params=None):
        normalized = " ".join(sql.split())
        if normalized == "SELECT COUNT(*), COUNT(DISTINCT `item_sk`), MIN(`item_sk`), COUNT(DISTINCT `order_no`) FROM `tgt`.`sales`":
            self.queries.append((sql, params))
            self._row = (MULTI_ROWS, MULTI_DISTINCT, 1, MULTI_PARTNER_DISTINCT)
            self._rows = [self._row]
            return
        if normalized == "SELECT COUNT(*) FROM `src`.`sales`":
            self.queries.append((sql, params))
            self._row = (MULTI_ROWS,)
            self._rows = [self._row]
            return
        if normalized == "SELECT COUNT(DISTINCT `order_no`) FROM `src`.`sales`":
            self.queries.append((sql, params))
            self._row = (MULTI_PARTNER_DISTINCT,)
            self._rows = [self._row]
            return
        if normalized == "SELECT COUNT(DISTINCT `item_sk`) FROM `src`.`sales`":
            self.queries.append((sql, params))
            self._row = (MULTI_DISTINCT,)
            self._rows = [self._row]
            return
        if normalized == "SELECT COUNT(DISTINCT `item_sk`), MIN(`item_sk`) FROM `tgt`.`item`":
            self.queries.append((sql, params))
            self._row = (MULTI_DISTINCT, 1)
            self._rows = [self._row]
            return
        if "SELECT COUNT(DISTINCT `item_sk`), MIN(`item_sk`), MAX(`item_sk`)" in normalized:
            self.queries.append((sql, params))
            self._row = (MULTI_DISTINCT, 1, MULTI_DISTINCT)
            self._rows = [self._row]
            return
        # With a small partner cardinality the grouped-sequence path also runs
        # before the frequency-shape path overrides it, exactly as on lineitem.
        if "SELECT group_size, COUNT(*) AS parent_groups" in normalized:
            self.queries.append((sql, params))
            self._rows = list(MULTI_GROUPS)
            self._row = self._rows[0]
            return
        if "SELECT frequency, COUNT(*) AS value_count" in normalized and "FROM `src`.`sales`" in normalized:
            self.queries.append((sql, params))
            self._rows = list(MULTI_GROUPS)
            self._row = self._rows[0]
            return
        super().execute(sql, params)


def evaluate_case(expression, rownum):
    """Evaluate a generated dbgen CASE expression for one rownum."""
    body = " ".join(expression.split())
    if not body.startswith("case"):
        return eval_scalar(body, rownum)
    for limit, expr in re.findall(
        r"when rownum <= (\d+) then (.*?)(?= when rownum <= | else )", body
    ):
        if rownum <= int(limit):
            return eval_scalar(expr, rownum)
    return eval_scalar(re.search(r" else (.*?) end$", body).group(1), rownum)


def eval_scalar(expr, rownum):
    expr = expr.strip().rstrip(",")
    expr = re.sub(r"\bdiv\(([^,]+),([^)]+)\)", r"((\1)//(\2))", expr)
    expr = re.sub(r"\bmod\(([^,]+),([^)]+)\)", r"((\1)%(\2))", expr)
    return eval(expr, {"__builtins__": {}}, {"rownum": rownum})


class MasterRunFkAppendageTests(unittest.TestCase):
    def test_partial_fk_pk_preserves_frequency_shape_without_source_literals(self):
        old_values = (
            masterrun.SOURCE_SCHEMA,
            masterrun.TARGET_SCHEMA,
            masterrun.DB_TYPE,
            masterrun.ROWS_OVERRIDE,
        )
        masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()
        masterrun.SOURCE_SCHEMA = "src"
        masterrun.TARGET_SCHEMA = "tgt"
        masterrun.DB_TYPE = "mysql"
        masterrun.ROWS_OVERRIDE = False
        try:
            cursor = PartialFkPkAppendageCursor()
            appendages = masterrun.build_fk_appendages(cursor, "sales")
        finally:
            (
                masterrun.SOURCE_SCHEMA,
                masterrun.TARGET_SCHEMA,
                masterrun.DB_TYPE,
                masterrun.ROWS_OVERRIDE,
            ) = old_values
            masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()

        self.assertIn("item_sk", appendages)
        self.assertIn("order_no", appendages)
        self.assertIn("when rownum <= 1000 then 1+div(rownum-1,200)", appendages["item_sk"])
        # Banded per group rather than a global cycle. With a single frequency
        # group the band is the whole table, so this stays equivalent to the
        # former "mod(rownum-1, 200)+1"; the two diverge once there is more
        # than one group (see the multi-group test below).
        self.assertIn("when rownum <= 1000 then mod(rownum-1,200)+1",
                      appendages["order_no"])

        source_literal_queries = [
            sql for sql, _params in cursor.queries
            if "SELECT `item_sk`" in sql
        ]
        self.assertEqual([], source_literal_queries)

    def test_child_composite_fk_reuses_registered_parent_frequency_shape(self):
        old_values = (
            masterrun.SOURCE_SCHEMA,
            masterrun.TARGET_SCHEMA,
            masterrun.DB_TYPE,
            masterrun.ROWS_OVERRIDE,
        )
        masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()
        masterrun.SOURCE_SCHEMA = "src"
        masterrun.TARGET_SCHEMA = "tgt"
        masterrun.DB_TYPE = "mysql"
        masterrun.ROWS_OVERRIDE = False
        try:
            cursor = PartialFkPkAppendageCursor()
            masterrun.build_fk_appendages(cursor, "sales")
            appendages = masterrun.build_fk_appendages(cursor, "returns")
        finally:
            (
                masterrun.SOURCE_SCHEMA,
                masterrun.TARGET_SCHEMA,
                masterrun.DB_TYPE,
                masterrun.ROWS_OVERRIDE,
            ) = old_values
            masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()

        self.assertIn("item_sk", appendages)
        self.assertIn("order_no", appendages)
        self.assertIn("when rownum <= 30 then 1+div(rownum-1,6)", appendages["item_sk"])
        self.assertIn("div(mod(rownum-1,6)*200,6)", appendages["order_no"])

        source_literal_queries = [
            sql for sql, _params in cursor.queries
            if "SELECT `item_sk`" in sql
        ]
        self.assertEqual([], source_literal_queries)

    def test_child_composite_fk_reconstructs_parent_frequency_shape_for_child_only_rerun(self):
        old_values = (
            masterrun.SOURCE_SCHEMA,
            masterrun.TARGET_SCHEMA,
            masterrun.DB_TYPE,
            masterrun.ROWS_OVERRIDE,
        )
        masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()
        masterrun.SOURCE_SCHEMA = "src"
        masterrun.TARGET_SCHEMA = "tgt"
        masterrun.DB_TYPE = "mysql"
        masterrun.ROWS_OVERRIDE = False
        try:
            cursor = PartialFkPkAppendageCursor()
            appendages = masterrun.build_fk_appendages(cursor, "returns")
        finally:
            (
                masterrun.SOURCE_SCHEMA,
                masterrun.TARGET_SCHEMA,
                masterrun.DB_TYPE,
                masterrun.ROWS_OVERRIDE,
            ) = old_values
            masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()

        self.assertIn("item_sk", appendages)
        self.assertIn("order_no", appendages)
        self.assertIn("when rownum <= 30 then 1+div(rownum-1,6)", appendages["item_sk"])
        self.assertIn("div(mod(rownum-1,6)*200,6)", appendages["order_no"])

        source_literal_queries = [
            sql for sql, _params in cursor.queries
            if "SELECT `item_sk`" in sql
        ]
        self.assertEqual([], source_literal_queries)

    def test_multi_group_partner_column_matches_source_frequency_shape(self):
        """The non-FK primary key column must be an ordinal within its group.

        Regression guard. A global cycle (mod(rownum-1, partner_distinct)+1)
        keeps the pair unique and so passes row-count and distinct-count
        checks, but flattens the partner column's distribution and lets a
        group straddle the wrap. That shipped undetected and showed up only as
        a histogram divergence on TPC-H lineitem.l_linenumber.
        """
        old_values = (
            masterrun.SOURCE_SCHEMA,
            masterrun.TARGET_SCHEMA,
            masterrun.DB_TYPE,
            masterrun.ROWS_OVERRIDE,
        )
        masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()
        masterrun.SOURCE_SCHEMA = "src"
        masterrun.TARGET_SCHEMA = "tgt"
        masterrun.DB_TYPE = "mysql"
        masterrun.ROWS_OVERRIDE = False
        try:
            appendages = masterrun.build_fk_appendages(
                MultiGroupFkPkAppendageCursor(), "sales"
            )
        finally:
            (
                masterrun.SOURCE_SCHEMA,
                masterrun.TARGET_SCHEMA,
                masterrun.DB_TYPE,
                masterrun.ROWS_OVERRIDE,
            ) = old_values
            masterrun.COMPOSITE_PK_FREQUENCY_REGISTRY.clear()

        self.assertIn("order_no", appendages)
        pairs = [
            (
                evaluate_case(appendages["item_sk"], rownum),
                evaluate_case(appendages["order_no"], rownum),
            )
            for rownum in range(1, MULTI_ROWS + 1)
        ]

        # Every group emits exactly 1..k, so the partner frequencies are the
        # count of groups at least that large.
        expected = Counter()
        for frequency, value_count in MULTI_GROUPS:
            for ordinal in range(1, frequency + 1):
                expected[ordinal] += value_count
        self.assertEqual(expected, Counter(partner for _fk, partner in pairs))

        # A global cycle would have produced a flat distribution instead.
        self.assertNotEqual(
            Counter({o: MULTI_ROWS // MULTI_PARTNER_DISTINCT
                     for o in range(1, MULTI_PARTNER_DISTINCT + 1)}),
            Counter(partner for _fk, partner in pairs),
        )

        # The composite primary key must still be unique, and each group's
        # ordinals contiguous from 1 rather than straddling a wrap.
        self.assertEqual(len(pairs), len(set(pairs)))
        by_fk = defaultdict(list)
        for fk, partner in pairs:
            by_fk[fk].append(partner)
        for fk, partners in by_fk.items():
            self.assertEqual(list(range(1, len(partners) + 1)), sorted(partners),
                             f"group {fk} is not numbered 1..k")


if __name__ == "__main__":
    unittest.main()
