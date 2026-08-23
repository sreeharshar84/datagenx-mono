# N-Cycling Approach for Composite FK+PK Tables

## Problem Statement

Tables with composite primary keys where **all columns are also foreign keys** fail to achieve full coverage of all FK dimensions when using the traditional odometer approach.

### Affected Tables

| Schema | Table | PK Columns | Issue |
|--------|-------|------------|-------|
| TPC-H | PARTSUPP | ps_partkey, ps_suppkey | 2-column composite FK+PK |
| TPC-DS | inventory | inv_item_sk, inv_date_sk, inv_warehouse_sk | 3-column composite FK+PK |

### Failure Mode (Before Fix)

With the odometer approach, only the fastest-moving dimension of a composite
FK+PK achieves full coverage. Every other dimension is truncated to
`total_rows / (product of the other dimensions)` distinct values, which for a
wide dimension against a large table collapses to a small fraction of the
source cardinality.

### Cascading Effect

LINEITEM references PARTSUPP via composite FK. When PARTSUPP only has 80 distinct ps_partkey values:
- LINEITEM generates l_partkey values 1-200,000
- FK constraint rejects rows where l_partkey > 80
- Result: 6,001,215 rows → 2,480 rows (99.96% row loss)

---

## Why Odometer Fails

The odometer pattern chains divisors like a mechanical counter:

```
C_N     = mod(rownum-1, D_N)
C_{N-1} = mod(div(rownum-1, D_N), D_{N-1})
...
C_1     = mod(div(rownum-1, D_N * ... * D_2), D_1)
```

**The largest dimension achieves only:** `R / (D_N * D_{N-1} * ... * D_2)` values

| Table | Largest Dim | Divisor | Achievable | Needed |
|-------|-------------|---------|------------|--------|
| PARTSUPP | ps_partkey | 10,000 | 80 | 200,000 |
| inventory | inv_item_sk | 261 × 5 = 1,305 | 9,000 | 18,000 |

**Odometer works when:** `R ≈ D1 × D2 × ... × DN` (need all combinations)

**Odometer fails when:** `R << product` (need full coverage of each dimension, but sparse combinations)

---

## N-Cycling Solution

### Key Insight

Instead of chaining divisors, use:
- **One column for grouping** (div) — the largest dimension
- **All other columns cycle independently** (mod)

### Generalized Algorithm (Any N columns)

```python
# Sort columns by source_distinct DESCENDING
pk_fk_info.sort(key=lambda x: x[3], reverse=True)

rows_per_largest = R // D1  # where D1 is the largest distinct count

for i, (col, ..., source_distinct, ..., min_val) in enumerate(pk_fk_info):
    if i == 0:
        # Largest dimension: grouped via div
        expr = f"div(rownum-1, {rows_per_largest})+{min_val}"
    else:
        # All other dimensions: cycling via mod
        expr = f"mod(rownum-1, {source_distinct})+{min_val}"
```

**One loop. No special cases for 2, 3, or N columns.**

### Generated Expressions

**PARTSUPP (2 columns):**
```
rows_per_largest = 800,000 / 200,000 = 4

ps_partkey = div(rownum-1, 4) + 1       # 1,1,1,1,2,2,2,2,3,3,3,3,...
ps_suppkey = mod(rownum-1, 10000) + 1   # 1,2,3,4,5,6,7,8,9,10,...
```

**inventory (3 columns):**
```
rows_per_largest = 11,745,000 / 18,000 = 652

inv_item_sk      = div(rownum-1, 652) + 1    # grouped by item
inv_date_sk      = mod(rownum-1, 261) + 1    # cycling through dates
inv_warehouse_sk = mod(rownum-1, 5) + 1      # cycling through warehouses
```

---

## Correctness Proofs

### Full Coverage

For each column Ci with distinct count Di:

- **Largest (div):** `div(rownum-1, rows_per_largest)` for R rows gives `R / rows_per_largest = D1` values ✓
- **Others (mod):** `mod(rownum-1, Di)` cycles through all Di values ✓

### Uniqueness

For a duplicate tuple to occur at rows `a` and `b`:
- Same largest column: `a` and `b` in same `rows_per_largest`-sized block
- Same all other columns: `a ≡ b (mod LCM(D2, D3, ..., DN))`

For both conditions: `a` and `b` must be within `rows_per_largest` rows AND differ by `LCM(D2, ..., DN)`.

**Impossible when:** `LCM(D2, ..., DN) >= rows_per_largest`

**This constraint is automatically satisfied** when `R <= D1 × D2 × ... × DN` (required for any valid PK).

**Proof:**
- `rows_per_largest = R / D1`
- `LCM(D2, ..., DN) >= D2` (LCM is at least as large as any factor)
- Need: `D2 >= R / D1`, i.e., `D1 × D2 >= R`
- This holds because `D1 × D2 × ... × DN >= R` (feasibility constraint for unique PKs)

---

## Examples with Verification

### PARTSUPP (2 columns)

| Row | ps_partkey | ps_suppkey | Unique? |
|-----|------------|------------|---------|
| 1 | div(0,4)+1 = 1 | mod(0,10000)+1 = 1 | (1,1) ✓ |
| 2 | 1 | 2 | (1,2) ✓ |
| 3 | 1 | 3 | (1,3) ✓ |
| 4 | 1 | 4 | (1,4) ✓ |
| 5 | div(4,4)+1 = 2 | 5 | (2,5) ✓ |
| ... | | | |
| 10000 | 2500 | 10000 | (2500,10000) ✓ |
| 10001 | 2501 | 1 | (2501,1) ✓ ← supplier wraps, new part |
| ... | | | |
| 800000 | 200000 | 10000 | (200000,10000) ✓ |

**Coverage:** 200,000 parts ✓, 10,000 suppliers ✓

### inventory (3 columns)

| Row | inv_item_sk | inv_date_sk | inv_warehouse_sk |
|-----|-------------|-------------|------------------|
| 1 | div(0,652)+1 = 1 | mod(0,261)+1 = 1 | mod(0,5)+1 = 1 |
| 2 | 1 | 2 | 2 |
| ... | | | |
| 652 | 1 | 131 | 2 |
| 653 | 2 | 132 | 3 |
| ... | | | |

**Uniqueness check for inventory:**
- Same item: rows in same 652-row block
- Same (date, warehouse): rows differ by LCM(261, 5) = 1305
- Since 1305 > 652, no collision within an item block ✓

**Coverage:** 18,000 items ✓, 261 dates ✓, 5 warehouses ✓

---

## Implementation

### Location
`MasterRun.py:build_fk_appendages()` around line 276

### Code (Generalized N-Cycling)

```python
if len(pk_fk_info) >= 2:
    # N-CYCLING: One column groups (div), all others cycle (mod)
    # Works for any number of columns.

    # Sort by source_distinct DESCENDING (largest first)
    pk_fk_info.sort(key=lambda x: x[3], reverse=True)

    rows_per_largest = max(1, source_row_count // pk_fk_info[0][3])

    for i, (col, ref_table, ref_col, source_distinct, ref_distinct, min_val) in enumerate(pk_fk_info):
        if i == 0:
            # Largest dimension: grouped via div
            expr = f"div(rownum-1, {rows_per_largest})+{min_val}"
        else:
            # All other dimensions: cycling via mod
            expr = f"mod(rownum-1, {source_distinct})+{min_val}"
        appendages[col] = expr
```

---

## Code Paths in MasterRun.py

| Condition | Lines | Pattern | Affected by N-Cycling? |
|-----------|-------|---------|------------------------|
| All PK are FK | 250-350 | **N-Cycling** | YES - composite PK where all cols are FK |
| Partial FK+PK | 352-393 | mod() cycling | NO |
| Single-column FK | 396-410 | build_single_fk_expression() | NO |
| Composite FK reference | 389-438 | **N-Cycling** | YES - must match referenced table |

---

## Composite FK References (LINEITEM → PARTSUPP)

When a table has a composite FK referencing another table's composite key, it must generate pairs that **exist** in the referenced table. Since the referenced table uses n-cycling, the referencing table must use the same pattern.

**Example:** LINEITEM references PARTSUPP via `(l_partkey, l_suppkey)`

PARTSUPP n-cycling (800,000 rows):
```
ps_partkey = div(rownum-1, 4) + 1       # grouped
ps_suppkey = mod(rownum-1, 10000) + 1   # cycling
```

LINEITEM must use same formula, wrapped to cycle through all 800,000 pairs:
```
l_partkey = div(mod(rownum-1, 800000), 4) + 1
l_suppkey = mod(mod(rownum-1, 800000), 10000) + 1
```

This ensures LINEITEM generates pairs like (1,1), (1,2), (1,3), (1,4), (2,5)... which exist in PARTSUPP.

---

## Validation

After implementation, verify:

```sql
-- PARTSUPP coverage
SELECT COUNT(DISTINCT ps_partkey), COUNT(DISTINCT ps_suppkey), COUNT(*)
FROM tpch_harsha.PARTSUPP;
-- Expected: 200000, 10000, 800000

-- LINEITEM coverage (references PARTSUPP)
SELECT COUNT(DISTINCT l_partkey), COUNT(DISTINCT l_suppkey), COUNT(*)
FROM tpch_harsha.LINEITEM;
-- Expected: 200000, 10000, 6001215

-- inventory coverage
SELECT COUNT(DISTINCT inv_item_sk), COUNT(DISTINCT inv_date_sk),
       COUNT(DISTINCT inv_warehouse_sk), COUNT(*)
FROM tpcds_harsha.inventory;
-- Expected: 18000, 261, 5, 11745000
```

---

## Summary

| Approach | Largest Dim | Other Dims | Uniqueness | Scalability |
|----------|-------------|------------|------------|-------------|
| Odometer | R/product(others) | Full | ✓ | Any N |
| **N-Cycling** | **Full** | **Full** | **✓** | **Any N** |

**N-Cycling is strictly better** when full coverage of all dimensions is needed.
