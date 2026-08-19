# DataGenX: End-to-End Example

This document walks through how DataGenX generates synthetic data for TPC-H tables, progressing from simple to complex cases.

---

## 1. Simple Table: REGION (No FKs, Simple PK)

### Source Schema
```sql
CREATE TABLE region (
    R_REGIONKEY  INTEGER NOT NULL PRIMARY KEY,
    R_NAME       CHAR(25) NOT NULL,
    R_COMMENT    VARCHAR(152)
);
-- 5 rows
```

### Step 1: Extract Metadata
```python
# MasterRun.py queries:
row_count = 5
primary_keys = ['R_REGIONKEY']
foreign_keys = {}  # None
histograms = {
    'R_REGIONKEY': {'histogram-type': 'singleton', 'buckets': [[0,0.2], [1,0.4], [2,0.6], [3,0.8], [4,1.0]]},
    'R_NAME': {'histogram-type': 'singleton', 'buckets': [['AFRICA',0.2], ['AMERICA',0.4], ...]},
}
```

### Step 2: Generate Expressions

| Column | Type | Expression | Why |
|--------|------|------------|-----|
| R_REGIONKEY | PK (simple) | `rownum` | Sequential 1,2,3,4,5 guarantees uniqueness |
| R_NAME | String (low cardinality) | `CASE rand.weighted([0.2,0.2,0.2,0.2,0.2]) WHEN 1 THEN 'R_NAME_1...' ...` | Weighted CASE preserves distribution, synthetic values preserve privacy |
| R_COMMENT | String (high cardinality) | `rand.regex('[a-z]{50}')` | Random text, no histogram preservation needed |

### Step 3: Generated .dbgen Template
```sql
CREATE TABLE `region` (
  `R_REGIONKEY` int NOT NULL /*{{ @R_REGIONKEY := rownum }}*/,
  `R_NAME` char(25) NOT NULL /*{{ @R_NAME := case rand.weighted(array[0.2, 0.2, 0.2, 0.2, 0.2])
    when 1 then 'R_NAME_1_________________'
    when 2 then 'R_NAME_2_________________'
    when 3 then 'R_NAME_3_________________'
    when 4 then 'R_NAME_4_________________'
    when 5 then 'R_NAME_5_________________'
  end }}*/,
  `R_COMMENT` varchar(152) /*{{ @R_COMMENT := rand.regex('[a-z]{50}') }}*/,
  PRIMARY KEY (`R_REGIONKEY`)
)
```

### Step 4: dbgen Binary Execution
```bash
dbgen --rows 5 --template region.dbgen --output region.1.csv
```

### Distinct Count Preservation
- **R_REGIONKEY**: 5 distinct (rownum 1-5) ✓
- **R_NAME**: 5 distinct (weighted CASE with 5 options) ✓
- **R_COMMENT**: ~5 distinct (rand.regex may produce fewer) - NOTE status

### Histogram Preservation
- **R_REGIONKEY**: Perfect match (sequential values, same count per value)
- **R_NAME**: Perfect match (weights from source histogram)
- **R_COMMENT**: Not compared (high-cardinality text)

---

## 2. Table with FK: NATION (References REGION)

### Source Schema
```sql
CREATE TABLE nation (
    N_NATIONKEY  INTEGER NOT NULL PRIMARY KEY,
    N_NAME       CHAR(25) NOT NULL,
    N_REGIONKEY  INTEGER NOT NULL,  -- FK to region.R_REGIONKEY
    N_COMMENT    VARCHAR(152),
    FOREIGN KEY (N_REGIONKEY) REFERENCES region(R_REGIONKEY)
);
-- 25 rows
```

### Key Difference: FK Column Expression

For `N_REGIONKEY`, we must generate values that:
1. Exist in the target `region` table (referential integrity)
2. Match the source distribution (histogram preservation)

### Step 1: Analyze FK Column
```python
# MasterRun.py analyzes:
source_distinct = 5  # COUNT(DISTINCT N_REGIONKEY) from source
target_ref_count = 5  # COUNT(*) from target region table
coverage = 5/5 = 100%  # High coverage

# Decision: Use weighted CASE (sparse approach) because:
# - Low cardinality (5 values)
# - Need to preserve distribution
```

### Step 2: Build FK Expression
```python
# Get histogram for N_REGIONKEY
histogram = {'histogram-type': 'singleton', 'buckets': [[0,0.2], [1,0.4], [2,0.6], [3,0.8], [4,1.0]]}

# Extract weights: each region has 20% of nations
weights = [0.2, 0.2, 0.2, 0.2, 0.2]

# Sample actual values from TARGET region table (not source!)
cursor.execute("SELECT R_REGIONKEY FROM tpch_dbgenx.region")
target_values = [1, 2, 3, 4, 5]  # Synthetic PKs from target

# Build weighted CASE
expression = """case rand.weighted(array[0.2, 0.2, 0.2, 0.2, 0.2])
    when 1 then 1
    when 2 then 2
    when 3 then 3
    when 4 then 4
    when 5 then 5
end"""
```

### Generated .dbgen Template
```sql
CREATE TABLE `nation` (
  `N_NATIONKEY` int NOT NULL /*{{ @N_NATIONKEY := rownum }}*/,
  `N_NAME` char(25) NOT NULL /*{{ @N_NAME := case rand.weighted(array[...])
    when 1 then 'N_NAME_1_________________'
    ...
  end }}*/,
  `N_REGIONKEY` int NOT NULL /*{{ @N_REGIONKEY := case rand.weighted(array[0.2, 0.2, 0.2, 0.2, 0.2])
    when 1 then 1
    when 2 then 2
    when 3 then 3
    when 4 then 4
    when 5 then 5
  end }}*/,
  `N_COMMENT` varchar(152) /*{{ ... }}*/,
  PRIMARY KEY (`N_NATIONKEY`),
  FOREIGN KEY (`N_REGIONKEY`) REFERENCES `region`(`R_REGIONKEY`)
)
```

### Why This Works
- **Referential Integrity**: Values 1-5 exist in target region table ✓
- **Distribution Preserved**: Weighted CASE uses source histogram weights ✓
- **Privacy**: We use target PK values, not source FK values ✓

---

## 3. Composite PK (All FK): PARTSUPP

### Source Schema
```sql
CREATE TABLE partsupp (
    PS_PARTKEY   INTEGER NOT NULL,  -- FK to part.P_PARTKEY
    PS_SUPPKEY   INTEGER NOT NULL,  -- FK to supplier.S_SUPPKEY
    PS_AVAILQTY  INTEGER NOT NULL,
    PS_SUPPLYCOST DECIMAL(15,2) NOT NULL,
    PS_COMMENT   VARCHAR(199) NOT NULL,
    PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY),
    FOREIGN KEY (PS_PARTKEY) REFERENCES part(P_PARTKEY),
    FOREIGN KEY (PS_SUPPKEY) REFERENCES supplier(S_SUPPKEY)
);
-- SF1: 800,000 rows (200,000 parts × 4 suppliers each)
```

### Challenge: Composite PK Where All Columns Are FKs

Both PK columns reference other tables. We need to generate valid (PS_PARTKEY, PS_SUPPKEY) pairs that:
1. Are unique (PK constraint)
2. Reference existing values in target tables
3. Match source cardinality

### N-Cycling Strategy

```
Source statistics:
- 200,000 distinct PS_PARTKEY (references part)
- 10,000 distinct PS_SUPPKEY (references supplier)
- 800,000 total rows

Pattern: Each part has 4 supplier relationships (800K / 200K = 4)
```

**N-Cycling Expression:**
```python
# Largest dimension (PS_PARTKEY): Use div() for grouping
# Other dimension (PS_SUPPKEY): Use mod() for cycling

PS_PARTKEY = "div(rownum-1, 4) + 1"      # Groups: 1,1,1,1,2,2,2,2,3,3,3,3,...
PS_SUPPKEY = "mod(rownum-1, 10000) + 1"  # Cycles: 1,2,3,...,10000,1,2,3,...
```

### Generated Pairs (First 12 Rows)
| rownum | PS_PARTKEY | PS_SUPPKEY |
|--------|------------|------------|
| 1 | 1 | 1 |
| 2 | 1 | 2 |
| 3 | 1 | 3 |
| 4 | 1 | 4 |
| 5 | 2 | 5 |
| 6 | 2 | 6 |
| 7 | 2 | 7 |
| 8 | 2 | 8 |
| 9 | 3 | 9 |
| 10 | 3 | 10 |
| 11 | 3 | 11 |
| 12 | 3 | 12 |

### Why N-Cycling Works
- **Uniqueness**: Each (partkey, suppkey) pair appears exactly once ✓
- **FK Validity**: Values 1-200000 exist in part, 1-10000 exist in supplier ✓
- **Distinct Counts**: 200,000 distinct partkeys, 10,000 distinct suppkeys ✓

### Histogram Impact
- PS_PARTKEY histogram: Matches (each partkey appears 4 times)
- PS_SUPPKEY histogram: Matches (each suppkey appears 80 times)

---

## 4. Composite PK (Mixed FK/Non-FK): LINEITEM

This is the most complex case in TPC-H.

### Source Schema
```sql
CREATE TABLE lineitem (
    L_ORDERKEY    INTEGER NOT NULL,      -- FK to orders + part of PK
    L_LINENUMBER  INTEGER NOT NULL,      -- Part of PK (NOT an FK)
    L_PARTKEY     INTEGER NOT NULL,      -- FK to partsupp (composite)
    L_SUPPKEY     INTEGER NOT NULL,      -- FK to partsupp (composite)
    L_QUANTITY    DECIMAL(15,2) NOT NULL,
    L_SHIPDATE    DATE NOT NULL,
    -- ... more columns ...
    PRIMARY KEY (L_ORDERKEY, L_LINENUMBER),
    FOREIGN KEY (L_ORDERKEY) REFERENCES orders(O_ORDERKEY),
    FOREIGN KEY (L_PARTKEY, L_SUPPKEY) REFERENCES partsupp(PS_PARTKEY, PS_SUPPKEY)
);
-- SF1: 6,001,215 rows
```

### Challenges

1. **Composite PK**: (L_ORDERKEY, L_LINENUMBER) must be unique
2. **L_ORDERKEY is both FK and PK**: Must reference orders AND be part of unique PK
3. **L_LINENUMBER is PK but not FK**: Small integer (1-7) with skewed distribution
4. **Composite FK**: (L_PARTKEY, L_SUPPKEY) must reference valid partsupp pairs

### Expression Strategy

```python
# Statistics:
source_rows = 6,001,215
distinct_orderkeys = 1,500,000
distinct_linenumbers = 7
avg_items_per_order = 4  # (6M / 1.5M)
```

#### Option A: Independent Cycling (Current Approach)
```python
L_ORDERKEY = "mod(rownum-1, 1500000) + 1"   # Cycles through all orders
L_LINENUMBER = "mod(rownum-1, 7) + 1"       # Cycles 1-7
```

**Problem**: L_LINENUMBER becomes uniform (14.3% each) instead of skewed.

**Source distribution**: Line 1: 25%, Line 2: 21%, Line 3: 18%... Line 7: 4%
**Generated distribution**: Line 1-7: 14.3% each

This causes the ~21% histogram divergence.

#### Option B: Grouped Generation (New Approach in MasterRun.py)

The recent code change adds `build_grouped_parent_sequence_appendages()` which:

1. Analyzes source group size distribution:
   ```sql
   SELECT group_size, COUNT(*) AS parent_groups
   FROM (
       SELECT L_ORDERKEY, COUNT(*) AS group_size
       FROM lineitem
       GROUP BY L_ORDERKEY
   ) grouped
   GROUP BY group_size
   ```

   Result:
   - 500,000 orders have 3 items
   - 400,000 orders have 4 items
   - 300,000 orders have 5 items
   - etc.

2. Generates banded CASE expressions:
   ```python
   L_ORDERKEY = """case
       when rownum <= 1500000 then 1 + div(rownum-1, 3)      -- Orders with 3 items
       when rownum <= 3100000 then 500001 + div(rownum-1500001, 4)  -- Orders with 4 items
       when rownum <= 4600000 then 900001 + div(rownum-3100001, 5)  -- Orders with 5 items
       ...
   end"""

   L_LINENUMBER = """case
       when rownum <= 1500000 then mod(rownum-1, 3) + 1      -- 1,2,3,1,2,3,...
       when rownum <= 3100000 then mod(rownum-1500001, 4) + 1  -- 1,2,3,4,1,2,3,4,...
       when rownum <= 4600000 then mod(rownum-3100001, 5) + 1  -- 1,2,3,4,5,...
       ...
   end"""
   ```

**Result**: L_LINENUMBER histogram matches source because group sizes are preserved.

### Composite FK: (L_PARTKEY, L_SUPPKEY)

Must generate valid pairs that exist in partsupp.

```python
# N-cycling with mod wrapping:
partsupp_row_count = 800000

L_PARTKEY = "div(mod(rownum-1, 800000), 4) + 1"
L_SUPPKEY = "mod(mod(rownum-1, 800000), 10000) + 1"
```

This cycles through all 800,000 partsupp pairs, repeating as needed for 6M rows.

### Final .dbgen Template (Simplified)
```sql
CREATE TABLE `lineitem` (
  `L_ORDERKEY` int NOT NULL /*{{ @L_ORDERKEY := case
      when rownum <= 1500000 then 1 + div(rownum-1, 3)
      when rownum <= 3100000 then 500001 + div(rownum-1500001, 4)
      ...
  end }}*/,
  `L_LINENUMBER` int NOT NULL /*{{ @L_LINENUMBER := case
      when rownum <= 1500000 then mod(rownum-1, 3) + 1
      when rownum <= 3100000 then mod(rownum-1500001, 4) + 1
      ...
  end }}*/,
  `L_PARTKEY` int NOT NULL /*{{ @L_PARTKEY := div(mod(rownum-1, 800000), 4) + 1 }}*/,
  `L_SUPPKEY` int NOT NULL /*{{ @L_SUPPKEY := mod(mod(rownum-1, 800000), 10000) + 1 }}*/,
  ...
  PRIMARY KEY (`L_ORDERKEY`, `L_LINENUMBER`),
  FOREIGN KEY (`L_ORDERKEY`) REFERENCES `orders`(`O_ORDERKEY`),
  FOREIGN KEY (`L_PARTKEY`, `L_SUPPKEY`) REFERENCES `partsupp`(`PS_PARTKEY`, `PS_SUPPKEY`)
)
```

---

## Summary: How Distinct Counts and Histograms Are Maintained

### Distinct Count Preservation

| Column Type | Strategy | Distinct Count Match |
|-------------|----------|---------------------|
| Simple PK | `rownum` | ✓ Exact |
| FK (low cardinality) | Weighted CASE sampling from target | ✓ Exact |
| FK (high cardinality) | `rand.range(min, max)` or `mod()` cycling | ✓ Exact |
| Composite PK (all FK) | N-cycling: div() for largest, mod() for others | ✓ Exact |
| Composite PK (mixed) | Grouped generation or coordinated cycling | ✓ Exact |
| Composite FK | N-cycling with mod wrapping | ✓ Exact |
| String (low cardinality) | Weighted CASE with synthetic values | ✓ Exact |
| String (high cardinality) | `rand.regex()` | ✗ Under-generates (NOTE) |

### Histogram Preservation

| Column Type | Strategy | Histogram Match |
|-------------|----------|-----------------|
| FK columns | Weighted CASE uses source histogram weights | ✓ Matches |
| Numeric (equi-height) | Bucket-cycling CASE | ✓ Matches |
| String (singleton) | Weighted CASE | ✓ Matches |
| PK in composite (cycling) | Independent mod() cycling | ✗ Uniform (~21% divergence) |
| PK in composite (grouped) | Banded CASE preserving group sizes | ✓ Matches |
| Date columns | Synthetic base + rand.range(span) | ✓ Shape matches |

### Key Tradeoffs

1. **Uniqueness vs Distribution**: For composite PKs, ensuring uniqueness sometimes requires uniform cycling which doesn't match skewed source distributions.

2. **Privacy vs Accuracy**: We never use actual source values in expressions. Synthetic values preserve distribution shapes but not literal values.

3. **Comment Columns**: High-cardinality text columns use simple rand.regex() which under-generates distinct values. This is acceptable because comment columns don't affect query planning.
