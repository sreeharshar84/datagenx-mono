# Literal Mapping and Query Rewriting

DataGenX normally validates distribution shape without preserving source
literals. For query testing, some predicates use source string literals:

```sql
WHERE l_returnflag = 'R'
WHERE l_shipmode IN ('MAIL', 'SHIP')
```

The synthetic target uses synthetic values, so the target-side query needs the
corresponding synthetic literals.

Date literals are also rewritten for target-side queries because generated date
values are shifted to a synthetic base date.

## Render TPC-H Templates

The original TPC-H files under `tpch-dbgen/queries` are templates with
placeholders such as `:1`, `:2`, and `:3`. Render them explicitly before query
or plan comparison:

```bash
python3 validate.py tpch-queries \
  --template-dir /path/to/tpch-dbgen/queries \
  --output-dir generated/tpch_queries_mysql
```

This command writes runnable files like:

```text
generated/tpch_queries_mysql/q12.sql
```

It is optional and is not run by default.

## Sensitive Mapping File

Build a local mapping file:

```bash
python3 validate.py literal-map \
  --source-schema tpch_vanilla \
  --target-schema tpch_dbgenx
```

Default output:

```text
generated/literal_mappings/tpch_vanilla_to_tpch_dbgenx.json
```

This file is **sensitive** because it contains source literals. It is ignored by
git and should stay local.

Example mapping:

```json
{
  "lineitem.l_returnflag": [
    {
      "source_literal": "N",
      "target_literal": "1",
      "rank": 1
    },
    {
      "source_literal": "R",
      "target_literal": "2",
      "rank": 2
    }
  ]
}
```

## Rewrite a Query

Rewrite SQL text:

```bash
python3 validate.py rewrite-query \
  --mapping-file generated/literal_mappings/tpch_vanilla_to_tpch_dbgenx.json \
  --sql "select * from lineitem where l_returnflag = 'R';"
```

Rewrite a SQL file:

```bash
python3 validate.py rewrite-query \
  --mapping-file generated/literal_mappings/tpch_vanilla_to_tpch_dbgenx.json \
  --query-file queries_mysql/q12.sql \
  --output-file /tmp/q12_target.sql
```

The rewrite is conservative:

```text
unique source literal      -> rewritten
ambiguous source literal   -> left unchanged and reported
unmapped source literal    -> left unchanged
```

## Run Query/Plan Validation With Mapping

Use the original query for the source schema and the rewritten query for the
target schema. String and date literals are rewritten only for the target-side
SQL:

```bash
python3 validate.py query q12 \
  --queries-dir generated/tpch_queries_mysql \
  --literal-mapping-file generated/literal_mappings/tpch_vanilla_to_tpch_dbgenx.json
```

Run all plan comparisons with target-side literal rewriting:

```bash
python3 validate.py plans \
  --queries-dir generated/tpch_queries_mysql \
  --literal-mapping-file generated/literal_mappings/tpch_vanilla_to_tpch_dbgenx.json
```

## Privacy Note

The mapping file is not part of the synthetic dataset. It is a local validation
tool that bridges source query literals to synthetic target literals. Sharing it
would expose source literals, so keep it private.
