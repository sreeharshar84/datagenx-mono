# DataGenX: Implementation Guide

This document describes the implementation details of DataGenX. For the high-level design, see [DATAGENX_DESIGN.md](DATAGENX_DESIGN.md).

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Entry Point                             │
│                        MasterRun.py                             │
└─────────────────────────────────────────────────────────────────┘
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                 ▼
┌───────────────────┐ ┌───────────────┐ ┌───────────────────────┐
│ lib/              │ │ datagenx/     │ │ datagenx/             │
│ schema_extractor  │ │ generation/   │ │ validation/           │
│                   │ │ GenerateDbgen │ │                       │
│ • MySQLExtractor  │ │               │ │ • ValidateTableStats  │
│ • SingleStore...  │ │ • annotate()  │ │ • compare_plans       │
│ • TiDBExtractor   │ │ • histogram() │ │ • validation_report   │
│ • OptimizerStats  │ │ • topn/mcv    │ │                       │
└───────────────────┘ │ • fk_expr()   │ └───────────────────────┘
                      └───────────────┘
```

## 2. Generic Layer

**Abstract Interface:** `lib/schema_extractor.py`

```python
@dataclass(frozen=True)
class HistogramBucket:
    ordinal: int
    frequency: float
    cumulative_frequency: float
    num_distinct: Optional[int] = None

@dataclass(frozen=True)
class TopNEntry:
    ordinal: int
    frequency: float
    count: Optional[int] = None

@dataclass(frozen=True)
class ColumnOptimizerStats:
    database_type: str
    table: str
    column: str
    row_count: Optional[int]
    ndv: Optional[int]
    histogram_type: Optional[str]
    histogram_buckets: List[HistogramBucket]
    topn: List[TopNEntry]

class SchemaExtractor(ABC):
    @abstractmethod
    def get_tables(self) -> List[str]

    @abstractmethod
    def get_columns(self, table: str) -> Dict[str, str]

    @abstractmethod
    def get_primary_keys(self, table: str) -> Set[str]

    @abstractmethod
    def get_foreign_keys(self, table: str) -> Dict[str, Tuple[str, str]]

    @abstractmethod
    def get_table_ddl(self, table: str) -> str

    @abstractmethod
    def get_column_histogram(self, table: str, column: str) -> Optional[dict]

    def get_column_topn(self, table: str, column: str) -> List[TopNEntry]

    def get_column_optimizer_stats(self, table: str, column: str) -> ColumnOptimizerStats

    @abstractmethod
    def get_table_dependencies(self) -> Dict[str, List[str]]
```

**Data Flow:**

```
1. get_tables()           → List of table names
2. get_table_dependencies() → Topological sort order
3. For each table (in order):
   a. get_table_ddl()     → Base CREATE TABLE
   b. get_columns()       → Column names + types
   c. get_primary_keys()  → PK columns
   d. get_foreign_keys()  → FK relationships
   e. get_column_optimizer_stats() → Per-column histograms, TopN/MCV, NDV
4. annotate_table_with_histogram() → Generate .dbgen
```

The extractor layer is the adapter boundary for database-specific optimizer
metadata. MySQL, TiDB, and SingleStore may expose different native catalogs, but
generation and validation should consume the normalized `ColumnOptimizerStats`
model where possible.

| Engine | Native Input | DataGenX Mapping |
|--------|--------------|------------------|
| MySQL | Singleton histogram buckets | `TopNEntry` ordinals with bucket probability masses |
| TiDB | `SHOW STATS_TOPN` | `TopNEntry` ordinals with native counts and probability masses |
| SingleStore | Histogram metadata today | `HistogramBucket`; native MCV support can map to `TopNEntry` |

`TopNEntry` intentionally does not contain the original literal value. It stores
a synthetic ordinal plus frequency/count, so preserving frequent-value shape
does not require preserving frequent-value text, dates, or numbers.

## 3. MySQL-Specific Layer

**Implementation:** `MySQLExtractor` in `lib/schema_extractor.py`

**Histogram Extraction:**
```python
def get_column_histogram(self, schema, table, column):
    cursor.execute("""
        SELECT HISTOGRAM
        FROM information_schema.COLUMN_STATISTICS
        WHERE SCHEMA_NAME = %s AND TABLE_NAME = %s AND COLUMN_NAME = %s
    """, (schema, table, column))
    row = cursor.fetchone()
    return json.loads(row[0]) if row else None
```

**Histogram Regeneration (Full Scan):**
```python
# Ensure accurate histograms by avoiding sampling
cursor.execute("SET GLOBAL histogram_generation_max_mem_size = 1000000000")
cursor.execute(f"ANALYZE TABLE `{schema}`.`{table}` UPDATE HISTOGRAM ON ...")
```

**FK Relationship Extraction:**
```python
def get_foreign_keys(self, schema, table):
    cursor.execute("""
        SELECT COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
        FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
          AND REFERENCED_TABLE_NAME IS NOT NULL
    """, (schema, table))
    return {col: (ref_table, ref_col) for col, ref_table, ref_col in cursor}
```

**Distinct Count Query:**
```python
def get_distinct_count(self, schema, table, column):
    cursor.execute(f"SELECT COUNT(DISTINCT `{column}`) FROM `{schema}`.`{table}`")
    return cursor.fetchone()[0]
```

Where supported, distinct counts should come from optimizer statistics instead
of full table scans. TiDB maps `SHOW STATS_HISTOGRAMS.distinct_count`; MySQL can
derive approximate NDV from histogram bucket metadata when a histogram exists,
and falls back to exact counts only where the current generation decision
requires it.

## 4. Expression Generation (GenerateDbgen.py)

**Main Entry Point:**
```python
def annotate_table_with_histogram(host, user, password, database, table,
                                   target_database=None, generated_appendages=None):
    """
    Generate .dbgen file for a single table.

    Args:
        database: Source schema (for metadata extraction)
        target_database: Target schema (for FK value ranges)
        generated_appendages: Pre-computed FK expressions from MasterRun

    Returns:
        Annotated DDL string
    """
```

**Expression Generators:**

| Function | Column Type | Output |
|----------|-------------|--------|
| `rownum` | Single PK | `rownum` or `rownum - 1 + min` |
| `build_single_fk_expression()` | FK | sparse CASE or `rand.range()` |
| `histogram_to_case()` | Numeric (equi-height) | Bucket-cycling CASE |
| `string_values_to_case()` | String (low card) | Weighted CASE with synthetic values |
| `string_histogram_to_case()` | String (high card) | Bucket NDV cycling with synthetic values |
| `get_date_range_expression()` | Date | `TIMESTAMP + INTERVAL rand.range()` |

**Histogram to CASE (Numeric):**
```python
def histogram_to_case(buckets, row_count, column_name, is_small_table):
    """
    Generate deterministic CASE expression from equi-height histogram.

    Strategy:
    - Outer CASE: mod(rownum-1, num_buckets) selects bucket
    - Inner: mod(div(rownum-1, num_buckets), num_distinct) cycles within bucket

    Example output:
    CASE mod(rownum-1, 100) + 1
      WHEN 1 THEN mod(div(rownum-1, 100), 50) + 0
      WHEN 2 THEN mod(div(rownum-1, 100), 50) + 50
      ...
    END
    """
```

**String Values to CASE:**
```python
def string_values_to_case(value_counts, column_name, col_length):
    """
    Generate weighted CASE with synthetic string values.

    Input: [(count1, 'actual_val1'), (count2, 'actual_val2'), ...]
    Output: CASE rand.weighted([freq1, freq2, ...])
              WHEN 1 THEN 'column_name_1___________'
              WHEN 2 THEN 'column_name_2___________'
            END

    Note: Actual values discarded; only counts used for weights.
    """
```

**High-Cardinality String Histograms:**
```python
def string_histogram_to_case(histogram_info, column_name, max_length, row_count):
    """
    Use equi-height bucket probability and bucket num_distinct from optimizer
    statistics to generate synthetic strings such as column_1, column_2, ...
    without collapsing a high-NDV string column to one value per bucket.
    """
```

## 5. FK Expression Generation (MasterRun.py)

**Pre-computation in MasterRun:**
```python
def build_fk_appendages(table, fk_info, conn):
    """
    Generate FK expressions BEFORE calling GenerateDbgen.

    Returns: Dict[column_name, expression_string]

    Decision tree:
    1. Coverage > 80%? → rand.range(min, max+1)
    2. Singleton histogram? → weighted CASE sampling from target
    3. Composite FK? → N-cycling (div + mod)
    4. Default → mod(rownum-1, distinct) + min
    """
```

**N-Cycling for Composite FK+PK:**
```python
def build_composite_fk_expression(columns, ref_table, ref_row_count):
    """
    When ALL PK columns are also FKs (e.g., PARTSUPP).

    Strategy:
    - Largest dimension: div(rownum-1, rows_per_largest) + min
    - Other dimensions: mod(rownum-1, distinct_count) + min

    Example (PARTSUPP: 200K parts × 10K suppliers = 800K rows):
    ps_partkey = div(rownum-1, 4) + 1       # grouped
    ps_suppkey = mod(rownum-1, 10000) + 1   # cycling
    """
```

**Grouped Parent + Sequence Composite PK:**
```python
def build_grouped_parent_sequence_appendages():
    """
    Detect PRIMARY KEY(parent_fk, sequence_col), where parent_fk references a
    parent table and sequence_col is an integer position inside each parent
    group. Generate both columns from the source child-count-per-parent
    distribution.

    Example: TPC-H lineitem(l_orderkey, l_linenumber)
      - preserve number of lineitems per order
      - generate l_linenumber as 1..k within each order
      - preserve PK uniqueness and FK validity
    """
```

For TPC-H 0.01 this learns:

```text
1x2100, 2x2183, 3x2091, 4x2188, 5x2117, 6x2148, 7x2173
```

That means 2100 orders have one lineitem, 2183 orders have two lineitems, and
so on. The generated target then matches both the `l_linenumber` histogram and
the `orders -> lineitem` fanout distribution.

## 6. Processing Pipeline

```
Step 1: Regenerate Histograms
    SET histogram_generation_max_mem_size = 1GB
    ANALYZE TABLE ... UPDATE HISTOGRAM ON all_columns
    Verify sampling_rate = 1.0

Step 2: Build FK Appendages
    For each table (topological order):
        For each FK column:
            Determine approach (sparse/dense/cycling)
            Generate expression
            Store in appendages dict

Step 3: Generate .dbgen Files
    For each table:
        Get DDL
        For each column:
            If FK: use pre-computed appendage
            If PK: rownum or cycling
            If Date: synthetic range
            If Numeric: histogram CASE
            If String: weighted synthetic CASE
        Write annotated DDL to .dbgen file

Step 4: Run dbgen Binary
    Input: .dbgen file + row count
    Output: CSV with generated data

Step 5: Load and Validate
    CREATE TABLE in target schema
    LOAD DATA from CSV
    ANALYZE TABLE
    Compare statistics (cardinality, histograms)
```

## 7. Key Files Reference

| File | Purpose |
|------|---------|
| `MasterRun.py` | Orchestration, FK appendage generation |
| `GenerateDbgen.py` | Expression generation, .dbgen file creation |
| `lib/schema_extractor.py` | Database-agnostic metadata extraction |
| `config.py` | Database credentials, schema names, paths |
| `dbgen_files/*.dbgen` | Generated annotated DDL files |
| `dbgen_tmp_out/*.csv` | Generated data files |

---

## Appendix: Expression Examples

### A.1 Primary Key (Simple)
```sql
`n_nationkey` int NOT NULL /*{{ @n_nationkey := rownum }}*/
```

### A.2 Primary Key (Composite with Grouping)
```sql
`ss_ticket_number` int NOT NULL /*{{ @ss_ticket_number := div(rownum-1, 10) + 1 }}*/
`ss_item_sk` int NOT NULL /*{{ @ss_item_sk := mod(rownum-1, 18000) + 1 }}*/
```

### A.3 Foreign Key (Dense Range)
```sql
`o_custkey` int /*{{ @o_custkey := rand.range(1, 150001) }}*/
```

### A.4 Foreign Key (Sparse Weighted)
```sql
`n_regionkey` int /*{{ @n_regionkey := case rand.weighted(array[0.2, 0.2, 0.2, 0.2, 0.2])
  when 1 then 1 when 2 then 2 when 3 then 3 when 4 then 4 when 5 then 5
end }}*/
```

### A.5 Date (Synthetic Range)
```sql
`d_date` date /*{{ @d_date := TIMESTAMP '2000-01-01 00:00:00' + INTERVAL rand.range(0, 73049) DAY }}*/
```

### A.6 Numeric (Equi-height Histogram)
```sql
`ps_availqty` int /*{{ @ps_availqty := case mod(rownum-1, 100) + 1
  when 1 then mod(div(rownum-1, 100), 99) + 0
  when 2 then mod(div(rownum-1, 100), 100) + 99
  when 3 then mod(div(rownum-1, 100), 100) + 199
  ...
end }}*/
```

### A.7 String (Weighted Synthetic)
```sql
`n_name` char(25) /*{{ @n_name := case rand.weighted(array[0.04, 0.04, 0.04, ...])
  when 1 then 'n_name_1_________________'
  when 2 then 'n_name_2_________________'
  when 3 then 'n_name_3_________________'
  ...
end }}*/
```
