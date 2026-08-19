# Composite FK+PK Cardinality Problem

## The Problem

When a column is both a foreign key (FK) and part of a composite primary key (PK), our current odometer-based generation can under-produce distinct values.

### Example: `inventory.inv_date_sk`

The `inventory` table has:
- **Composite PK**: `(inv_date_sk, inv_item_sk, inv_warehouse_sk)`
- **Row count**: 11,745,000 rows
- **Source distinct `inv_date_sk`**: 261 distinct dates


mysql> SELECT COUNT(DISTINCT inv_warehouse_sk) , COUNT(DISTINCT inv_date_sk) , COUNT(DISTINCT inv_item_sk) , COUNT(*) FROM tpcds.inventory;
+----------------------------------+-----------------------------+-----------------------------+----------+
| COUNT(DISTINCT inv_warehouse_sk) | COUNT(DISTINCT inv_date_sk) | COUNT(DISTINCT inv_item_sk) | COUNT(*) |
+----------------------------------+-----------------------------+-----------------------------+----------+
|                                5 |                         261 |                       18000 | 11745000 |
+----------------------------------+-----------------------------+-----------------------------+----------+
1 row in set (3.75 sec)

mysql> SELECT COUNT(DISTINCT inv_warehouse_sk) , COUNT(DISTINCT inv_date_sk) , COUNT(DISTINCT inv_item_sk) , COUNT(*) FROM tpcds_harsha.inventory;
+----------------------------------+-----------------------------+-----------------------------+----------+
| COUNT(DISTINCT inv_warehouse_sk) | COUNT(DISTINCT inv_date_sk) | COUNT(DISTINCT inv_item_sk) | COUNT(*) |
+----------------------------------+-----------------------------+-----------------------------+----------+
|                                5 |                         261 |                        9000 | 11745000 |
+----------------------------------+-----------------------------+-----------------------------+----------+
1 row in set (3.52 sec)

The current odometer approach:
```
inv_date_sk:     mod(div(rownum-1, 90000), 261) + 1
inv_item_sk:     mod(div(rownum-1, 6), 18000) + 1
inv_warehouse_sk: mod(rownum-1, 6) + 1
```

Where divisors come from reference table counts:
- `warehouse` has 6 rows → divisor for `inv_warehouse_sk` = 1, divisor for `inv_item_sk` = 6
- `item` has 18,000 rows → divisor for `inv_date_sk` = 6 × 18,000 = 90,000 (product of smaller dimensions)

### Why This Under-Generates

With 11,745,000 rows and divisor 90,000:
```
max(div(rownum-1, 90000)) = div(11,745,000 - 1, 90,000) = 130
```

So `inv_date_sk` only cycles through values 1-131, not 1-261.

**Result**: Validation shows `orig=261, replay=131` (50% divergence)

## The Root Cause

The current approach calculates divisors based on **reference table sizes** (what values *could* be used), not on **source table statistics** (what values *are* actually used).

For `inv_date_sk`:
- Reference table (`date_dim`) has 73,049 rows
- But source `inventory` only uses 261 distinct dates
- Current divisor (90,000) is based on product of other reference tables
- This divisor is too large relative to the 11.7M row count

## The Solution

Calculate the divisor based on **source distinct count**, not reference table size:

```python
# Current (wrong):
divisor = product_of_smaller_reference_tables  # 90,000

# Fixed:
source_distinct = COUNT(DISTINCT inv_date_sk) FROM inventory  # 261
divisor = total_rows / source_distinct  # 11,745,000 / 261 ≈ 45,000
```

With the corrected divisor:
```
max(div(rownum-1, 45000)) = div(11,745,000 - 1, 45,000) = 260
```

Now `inv_date_sk` cycles through values 0-260, producing 261 distinct values.

## Mathematical Proof of PK Uniqueness

The odometer pattern guarantees unique combinations:

```
rownum | div(r-1, 45000) | mod(div(r-1, 45000), 261) | inv_date_sk
-------|-----------------|---------------------------|-------------
1      | 0               | 0                         | 1
2      | 0               | 0                         | 1
...    | ...             | ...                       | ...
45001  | 1               | 1                         | 2
```

Each unique `(inv_date_sk, inv_item_sk, inv_warehouse_sk)` tuple maps to a unique rownum range:
- `inv_warehouse_sk` changes every row (mod 6)
- `inv_item_sk` changes every 6 rows (mod 18000)
- `inv_date_sk` changes every 45,000 rows (mod 261)

Product: 6 × 18,000 × 261 = 28,188,000 unique combinations (exceeds 11.7M rows)

## Privacy Compliance

Using `COUNT(DISTINCT column)` is privacy-safe:
- Returns only an integer count
- Does not reveal actual data values
- Does not expose MIN/MAX values
- Consistent with our statistical-patterns-only approach

## The Fundamental Constraint

With an odometer pattern, the product of distinct counts cannot exceed total rows:

```
product(distinct_counts) <= total_rows
```

For inventory:
- Source: 5 × 261 × 18000 = 23,490,000 combinations
- Rows: 11,745,000

The source data is **sparse** (only 50% of combinations exist). Our odometer generates **dense** combinations, so we can only match some dimensions' cardinality, not all.

## Sort Order Trade-off

Sorting by source_distinct determines which dimensions get full coverage:

**Ascending sort** (current): smaller → larger
- warehouse=5 ✓, date=261 ✓, item=11.7M/(5×261)=~9000 ✗

**Descending sort**: larger → smaller
- item=18000 ✓, date=261 ✓, warehouse=11.7M/(18000×261)=~3 ✗

We use ascending sort to preserve the sparser dimensions (dates).

## Implementation

In `MasterRun.py`, the FK+PK handling:

1. Query source distinct count for each FK+PK column
2. Sort by source_distinct ascending (prioritize smaller/sparser dimensions)
3. Use proper odometer: divisor = product of all smaller moduli
4. Accept that largest dimension may be under-generated

This maintains PK uniqueness while maximizing cardinality accuracy for sparser dimensions.
