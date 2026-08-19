# Histogram Sampling: The Root Cause of Distinct Count Errors

## The Problem

Many validation failures show distinct count mismatches:
- `cs_bill_cdemo_sk`: source=153,252, replay=190,436 (+24%)
- `cs_ship_cdemo_sk`: source=153,351, replay=190,622 (+24%)
- Similar patterns across multiple columns

These aren't bugs in our generation logic. They're caused by **MySQL histogram sampling**.

## How MySQL Builds Histograms

When you run `ANALYZE TABLE`, MySQL:

1. **Samples rows** based on `histogram_generation_max_mem_size` (default 20MB)
2. **Builds buckets** from sampled values
3. **Estimates `num_distinct`** per bucket using extrapolation

The sampling rate depends on table size vs memory limit:
```
sampling_rate = memory_limit / estimated_memory_needed
```

## The Extrapolation Error

With 16% sampling on `catalog_sales.cs_bill_cdemo_sk`:

| Step | What MySQL Does | Problem |
|------|-----------------|---------|
| 1 | Sample 16% of rows (~2,216 per bucket) | OK |
| 2 | Count distinct values in sample (~305) | OK |
| 3 | **Extrapolate**: 305 × (1/0.16) = 1,863 | **WRONG** |

### Why Extrapolation Fails

MySQL assumes: "If I saw 16% of rows, I saw 16% of distinct values."

**This is mathematically incorrect** for data with repetition.

Real scenario:
- Each distinct value appears ~8 times on average
- With 16% sampling, you see ~1.1 occurrences per value
- You actually see **~80% of distinct values**, not 16%
- Extrapolating by 6x massively over-estimates

### The Math

```
Actual distinct per bucket: ~1,530
Occurrences per value: ~8.8
Probability of seeing a value at least once with 16% sample:
  P = 1 - (1 - 0.163)^8.8 ≈ 80%

Sample sees: 1,530 × 0.80 ≈ 1,224 distinct
MySQL extrapolates: 305 × 6.1 = 1,863
Actual: 1,530
Error: +22%
```

## Impact on Our Generation

Our `histogram_to_case()` function:
```python
total_distinct = sum(bucket[3] for bucket in buckets)  # Uses num_distinct
# Generate total_distinct synthetic values
```

If histogram says 190,436 distinct, we generate 190,436 values.
But actual is only 153,252 → **24% over-generation**.

## Current Sampling Rates (with 1GB memory)

| Table | Rows | Sampling Rate | Memory for 100% |
|-------|------|---------------|-----------------|
| catalog_sales | 1.4M | 16% | 6GB |
| inventory | 11.7M | 39% | 2.6GB |
| store_sales | 800K | 42% | 2.4GB |
| customer_demographics | 1.9M | 52% | 1.9GB |
| web_sales | 456K | 58% | 1.7GB |

## The Solution

**Increase `histogram_generation_max_mem_size` to 6GB**

With 100% sampling:
- No extrapolation needed
- `num_distinct` is exact count
- Our generation matches source cardinality

```python
cursor.execute("SET GLOBAL histogram_generation_max_mem_size = 6000000000")  # 6GB
```

## Why This Wasn't Obvious

1. We initially set 1GB (50x the default), assuming it was enough
2. Validation errors looked like generation bugs, not histogram bugs
3. The extrapolation happens inside MySQL - not visible to us
4. `num_distinct` is presented as a count, not an estimate

## Verification

After increasing to 6GB, verify all tables have 100% sampling:
```sql
SELECT TABLE_NAME,
       HISTOGRAM->>'$."sampling-rate"' AS sampling_rate
FROM information_schema.COLUMN_STATISTICS
WHERE SCHEMA_NAME = 'tpcds'
  AND CAST(HISTOGRAM->>'$."sampling-rate"' AS DECIMAL(10,4)) < 1.0;
```

Should return empty result set.

## Other Affected Issues

Many issues in `VALIDATION_ISSUES.md` may resolve with proper sampling:

- **Non-FK _SK columns over-generating** → Histogram extrapolation
- **Dimension table date columns** → Partially histogram-related
- **Small table issues** → Different cause (too few rows for meaningful histogram)

The small table issues (income_band, store, warehouse) won't be fixed by sampling since they have <100 rows - the histogram approach itself is unsuitable for tiny tables.
