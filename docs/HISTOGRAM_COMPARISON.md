# Histogram Comparison

DataGenX validates histograms as **distribution shapes**, not as literal source
values. This is intentional: synthetic data should preserve optimizer-relevant
frequency patterns while allowing the actual generated values to differ.

## Inputs

Validation reads MySQL histogram metadata from:

```sql
information_schema.column_statistics
```

For every column that has a histogram in the source or target schema, validation
uses:

```text
histogram-type
buckets
cumulative bucket probabilities
number of buckets
column type
whether the column is indexed
```

## What Is Compared

For each source/target histogram pair:

1. Extract bucket probability mass from cumulative probabilities.
2. Sort bucket masses from largest to smallest.
3. Pad the shorter list with zeroes.
4. Compute half of the L1 distance between the two mass lists.

In simplified form:

```python
source_masses = sorted(source_bucket_masses, reverse=True)
target_masses = sorted(target_bucket_masses, reverse=True)

pad shorter list with 0.0

distribution_diff = 0.5 * sum(abs(source_masses[i] - target_masses[i]))
```

This compares the frequency shape of the buckets:

```text
50%, 25%, 25%
```

matches:

```text
50%, 25%, 25%
```

even if the actual bucket values are different.

## What Is Not Compared

Validation intentionally does **not** require these to match:

```text
actual string literals
actual numeric endpoint values
actual date endpoint values
source bucket labels
target bucket labels
```

Example:

```text
source l_returnflag:
N -> 50.5%
R -> 24.8%
A -> 24.7%

target l_returnflag:
1 -> 50.4%
2 -> 24.8%
3 -> 24.8%
```

This should pass as distribution-equivalent because the shape matches, even
though the domain values changed.

## Bucket Count Still Matters

The shorter bucket-mass list is padded with zeroes before comparison. This means
missing or extra buckets still contribute to drift.

Example:

```text
source: 40%, 30%, 20%, 10%
target: 40%, 30%, 30%
```

is compared as:

```text
source: 40%, 30%, 20%, 10%
target: 40%, 30%, 30%,  0%
```

The resulting difference captures both frequency drift and bucket-count drift.

## PASS, NOTE, FAIL

Histogram status uses this policy:

```text
PASS  distribution_diff < 5%
NOTE  distribution_diff >= 5% for an unindexed string column
NOTE  distribution_diff >= 5% for an unindexed decimal/numeric column
FAIL  distribution_diff >= 5% for indexed or otherwise critical columns
```

The reason for `NOTE`: unindexed string/decimal histograms can drift without
necessarily affecting key optimizer behavior as much as indexed columns,
join-key columns, or numeric/date predicates. They are still visible in the
report so they can be reviewed.

## Where This Is Used

The same distribution-shape comparison is used by:

```text
datagenx/validation/ValidateTableStats.py
datagenx/validation/PopulateNewTableAndValidate.py
datagenx/validation/replay_and_validate_sakila.py
datagenx/validation/validation_report.py
```

The HTML report additionally shows:

```text
source bucket count
target bucket count
source histogram type
target histogram type
distribution diff %
status
```

## Interpretation

Use histogram comparison to answer:

```text
Does the synthetic table preserve the optimizer-visible distribution shape?
```

Do not use it to answer:

```text
Did DataGenX preserve the exact source values?
```

Exact source-value preservation is intentionally not the goal. For checking
whether synthetic data differs from source data, use the report's exact row
overlap/privacy section.

## Generation Notes

Low-cardinality string histograms are generated with deterministic bucket
assignment instead of random weighted selection. This avoids random collisions
where a synthetic value is repeated and another bucket is missed.

For example, if the source has:

```text
25 buckets, each with 4% frequency
```

the generated target assigns exactly 4% of rows to each synthetic bucket value,
rather than drawing randomly from 25 values.

This deterministic behavior is used for both singleton and equi-height string
histograms when the histogram has at most `STRING_CARDINALITY_THRESHOLD`
buckets.
