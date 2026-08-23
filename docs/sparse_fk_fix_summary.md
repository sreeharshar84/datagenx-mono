# Sparse FK Fix for Distinct Count Divergence

**Date:** 2026-04-13

**Files Modified:**
- `GenerateDbgen.py` - Added `build_single_fk_expression()` function
- `MasterRun.py` - Updated to call consolidated FK function

---

## Problem

Foreign key columns whose source data uses only a small subset of the referenced
table diverged sharply in distinct value counts: the dense approach generates
uniformly across the whole FK range, so the replay carries more distinct values
than the source.

**Root cause**: FK columns used `rand.range(min, max)` across entire referenced table range, ignoring the actual distribution in source data.

---

## Solution: Sparse vs Dense FK Approach

| FK Type | Detection | Expression |
|---------|-----------|------------|
| **Sparse** (low cardinality) | Singleton histogram | Weighted CASE with sampled values |
| **Dense** (high cardinality) | Equi-height histogram | `rand.range(min, max)` |

---

## Implementation

Created unified `build_single_fk_expression()` in `GenerateDbgen.py`:

1. Check FK column's histogram type in **source** schema
2. If **singleton** (sparse):
   - Sample N evenly-spaced values from **target** table
   - Apply source frequency weights
3. If **equi-height** (dense): use existing range approach

### Code Change Example

```python
# Before (dense approach for all FKs)
rand.range(1, 73050)  # 73K possible values

# After (sparse approach for low-cardinality FKs)
case rand.weighted(array[0.08,0.12,0.08,0.12,0.08,0.12,0.08,0.12,0.08,0.12])
  when 1 then 7305 when 2 then 14610 when 3 then 21915 ...
end  # exactly 10 values with correct frequency distribution
```

### Key Functions

- `build_single_fk_expression()` - Main entry point, tries sparse then falls back to dense
- `_try_sparse_fk_expression()` - Checks for singleton histogram, samples values, builds weighted CASE
- `_build_dense_fk_expression()` - Original range-based approach

---

## Result

Affected columns generate only as many distinct values as the source uses, so
distinct counts track the source instead of the full referenced range. Very
low-cardinality columns retain some sampling variance.

---

## Architecture Note

Previously, FK logic was duplicated:
- `MasterRun.py:build_fk_appendages()` - Actually used
- `GenerateDbgen.py` - Dead code when running via MasterRun

**Fix:** Consolidated all FK logic into `GenerateDbgen.py`. MasterRun now calls `build_single_fk_expression()` instead of having inline logic.

---

## Remaining Issues

1. **Small table sampling variance** - Tables with few rows (e.g., 25) may not hit all distinct values due to random sampling
2. **Dense FK columns** - High-cardinality FKs like `ss_sold_date_sk` still use range approach and may diverge
3. **Date columns** - Non-FK date columns like `rec_start_date` still diverge (separate issue)
