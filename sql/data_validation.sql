Run started
Initializing environment
Installing packages
Running code
-- ############################################################

-- MYSQL 8.0+ : TPC-H SYNTHETIC DATA VALIDATION SQL

-- ############################################################

653 |

-- ============================================================
-- TPC-H: 1) ROW COUNT
-- ============================================================

SELECT 'region' AS table_name,
       (SELECT COUNT(*) FROM `src`.`region`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`region`) AS generated_count;

SELECT 'nation' AS table_name,
       (SELECT COUNT(*) FROM `src`.`nation`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`nation`) AS generated_count;

SELECT 'supplier' AS table_name,
       (SELECT COUNT(*) FROM `src`.`supplier`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`supplier`) AS generated_count;

SELECT 'customer' AS table_name,
       (SELECT COUNT(*) FROM `src`.`customer`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`customer`) AS generated_count;

SELECT 'part' AS table_name,
       (SELECT COUNT(*) FROM `src`.`part`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`part`) AS generated_count;

SELECT 'partsupp' AS table_name,
       (SELECT COUNT(*) FROM `src`.`partsupp`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`partsupp`) AS generated_count;

SELECT 'orders' AS table_name,
       (SELECT COUNT(*) FROM `src`.`orders`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`orders`) AS generated_count;

SELECT 'lineitem' AS table_name,
       (SELECT COUNT(*) FROM `src`.`lineitem`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`lineitem`) AS generated_count;

-- ============================================================
-- TPC-H: 2) DISTINCT COUNT ON PK / FK / PREDICATE COLS
-- ============================================================

SELECT 'region' AS table_name,
       'r_regionkey' AS column_name,
       (SELECT COUNT(DISTINCT `r_regionkey`) FROM `src`.`region`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `r_regionkey`) FROM `gen`.`region`) AS generated_distinct_count;

SELECT 'region' AS table_name,
       'r_name' AS column_name,
       (SELECT COUNT(DISTINCT `r_name`) FROM `src`.`region`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `r_name`) FROM `gen`.`region`) AS generated_distinct_count;

SELECT 'nation' AS table_name,
       'n_nationkey' AS column_name,
       (SELECT COUNT(DISTINCT `n_nationkey`) FROM `src`.`nation`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `n_nationkey`) FROM `gen`.`nation`) AS generated_distinct_count;

SELECT 'nation' AS table_name,
       'n_regionkey' AS column_name,
       (SELECT COUNT(DISTINCT `n_regionkey`) FROM `src`.`nation`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `n_regionkey`) FROM `gen`.`nation`) AS generated_distinct_count;

SELECT 'nation' AS table_name,
       'n_name' AS column_name,
       (SELECT COUNT(DISTINCT `n_name`) FROM `src`.`nation`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `n_name`) FROM `gen`.`nation`) AS generated_distinct_count;

SELECT 'supplier' AS table_name,
       's_suppkey' AS column_name,
       (SELECT COUNT(DISTINCT `s_suppkey`) FROM `src`.`supplier`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `s_suppkey`) FROM `gen`.`supplier`) AS generated_distinct_count;

SELECT 'supplier' AS table_name,
       's_nationkey' AS column_name,
       (SELECT COUNT(DISTINCT `s_nationkey`) FROM `src`.`supplier`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `s_nationkey`) FROM `gen`.`supplier`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_custkey' AS column_name,
       (SELECT COUNT(DISTINCT `c_custkey`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_custkey`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_nationkey' AS column_name,
       (SELECT COUNT(DISTINCT `c_nationkey`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_nationkey`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_mktsegment' AS column_name,
       (SELECT COUNT(DISTINCT `c_mktsegment`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_mktsegment`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'part' AS table_name,
       'p_partkey' AS column_name,
       (SELECT COUNT(DISTINCT `p_partkey`) FROM `src`.`part`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_partkey`) FROM `gen`.`part`) AS generated_distinct_count;

SELECT 'part' AS table_name,
       'p_brand' AS column_name,
       (SELECT COUNT(DISTINCT `p_brand`) FROM `src`.`part`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_brand`) FROM `gen`.`part`) AS generated_distinct_count;

SELECT 'part' AS table_name,
       'p_type' AS column_name,
       (SELECT COUNT(DISTINCT `p_type`) FROM `src`.`part`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_type`) FROM `gen`.`part`) AS generated_distinct_count;

SELECT 'part' AS table_name,
       'p_size' AS column_name,
       (SELECT COUNT(DISTINCT `p_size`) FROM `src`.`part`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_size`) FROM `gen`.`part`) AS generated_distinct_count;

SELECT 'part' AS table_name,
       'p_container' AS column_name,
       (SELECT COUNT(DISTINCT `p_container`) FROM `src`.`part`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_container`) FROM `gen`.`part`) AS generated_distinct_count;

SELECT 'partsupp' AS table_name,
       'ps_partkey' AS column_name,
       (SELECT COUNT(DISTINCT `ps_partkey`) FROM `src`.`partsupp`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ps_partkey`) FROM `gen`.`partsupp`) AS generated_distinct_count;

SELECT 'partsupp' AS table_name,
       'ps_suppkey' AS column_name,
       (SELECT COUNT(DISTINCT `ps_suppkey`) FROM `src`.`partsupp`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ps_suppkey`) FROM `gen`.`partsupp`) AS generated_distinct_count;

SELECT 'orders' AS table_name,
       'o_orderkey' AS column_name,
       (SELECT COUNT(DISTINCT `o_orderkey`) FROM `src`.`orders`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `o_orderkey`) FROM `gen`.`orders`) AS generated_distinct_count;

SELECT 'orders' AS table_name,
       'o_custkey' AS column_name,
       (SELECT COUNT(DISTINCT `o_custkey`) FROM `src`.`orders`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `o_custkey`) FROM `gen`.`orders`) AS generated_distinct_count;

SELECT 'orders' AS table_name,
       'o_orderstatus' AS column_name,
       (SELECT COUNT(DISTINCT `o_orderstatus`) FROM `src`.`orders`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `o_orderstatus`) FROM `gen`.`orders`) AS generated_distinct_count;

SELECT 'orders' AS table_name,
       'o_orderpriority' AS column_name,
       (SELECT COUNT(DISTINCT `o_orderpriority`) FROM `src`.`orders`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `o_orderpriority`) FROM `gen`.`orders`) AS generated_distinct_count;

SELECT 'orders' AS table_name,
       'o_orderdate' AS column_name,
       (SELECT COUNT(DISTINCT `o_orderdate`) FROM `src`.`orders`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `o_orderdate`) FROM `gen`.`orders`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_orderkey' AS column_name,
       (SELECT COUNT(DISTINCT `l_orderkey`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_orderkey`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_linenumber' AS column_name,
       (SELECT COUNT(DISTINCT `l_linenumber`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_linenumber`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_partkey' AS column_name,
       (SELECT COUNT(DISTINCT `l_partkey`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_partkey`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_suppkey' AS column_name,
       (SELECT COUNT(DISTINCT `l_suppkey`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_suppkey`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_returnflag' AS column_name,
       (SELECT COUNT(DISTINCT `l_returnflag`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_returnflag`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_linestatus' AS column_name,
       (SELECT COUNT(DISTINCT `l_linestatus`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_linestatus`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_shipdate' AS column_name,
       (SELECT COUNT(DISTINCT `l_shipdate`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_shipdate`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_commitdate' AS column_name,
       (SELECT COUNT(DISTINCT `l_commitdate`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_commitdate`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_receiptdate' AS column_name,
       (SELECT COUNT(DISTINCT `l_receiptdate`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_receiptdate`) FROM `gen`.`lineitem`) AS generated_distinct_count;

SELECT 'lineitem' AS table_name,
       'l_shipmode' AS column_name,
       (SELECT COUNT(DISTINCT `l_shipmode`) FROM `src`.`lineitem`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `l_shipmode`) FROM `gen`.`lineitem`) AS generated_distinct_count;

-- ============================================================
-- TPC-H: 3) GENERATED FK DISTRIBUTION SUMMARY
-- ============================================================

WITH freq AS (
    SELECT `n_regionkey`, COUNT(*) AS cnt
    FROM `gen`.`nation`
    WHERE `n_regionkey` IS NOT NULL
    GROUP BY `n_regionkey`
)
SELECT 'nation' AS child_table,
       'n_regionkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `s_nationkey`, COUNT(*) AS cnt
    FROM `gen`.`supplier`
    WHERE `s_nationkey` IS NOT NULL
    GROUP BY `s_nationkey`
)
SELECT 'supplier' AS child_table,
       's_nationkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `c_nationkey`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_nationkey` IS NOT NULL
    GROUP BY `c_nationkey`
)
SELECT 'customer' AS child_table,
       'c_nationkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ps_partkey`, COUNT(*) AS cnt
    FROM `gen`.`partsupp`
    WHERE `ps_partkey` IS NOT NULL
    GROUP BY `ps_partkey`
)
SELECT 'partsupp' AS child_table,
       'ps_partkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ps_suppkey`, COUNT(*) AS cnt
    FROM `gen`.`partsupp`
    WHERE `ps_suppkey` IS NOT NULL
    GROUP BY `ps_suppkey`
)
SELECT 'partsupp' AS child_table,
       'ps_suppkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `o_custkey`, COUNT(*) AS cnt
    FROM `gen`.`orders`
    WHERE `o_custkey` IS NOT NULL
    GROUP BY `o_custkey`
)
SELECT 'orders' AS child_table,
       'o_custkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `l_orderkey`, COUNT(*) AS cnt
    FROM `gen`.`lineitem`
    WHERE `l_orderkey` IS NOT NULL
    GROUP BY `l_orderkey`
)
SELECT 'lineitem' AS child_table,
       'l_orderkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `l_partkey`, COUNT(*) AS cnt
    FROM `gen`.`lineitem`
    WHERE `l_partkey` IS NOT NULL
    GROUP BY `l_partkey`
)
SELECT 'lineitem' AS child_table,
       'l_partkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `l_suppkey`, COUNT(*) AS cnt
    FROM `gen`.`lineitem`
    WHERE `l_suppkey` IS NOT NULL
    GROUP BY `l_suppkey`
)
SELECT 'lineitem' AS child_table,
       'l_suppkey' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

-- ============================================================
-- TPC-H: 4) FK DISTRIBUTION VARIANCE VS SOURCE
-- ============================================================

WITH src_freq AS (
    SELECT `n_regionkey`, COUNT(*) AS cnt
    FROM `src`.`nation`
    WHERE `n_regionkey` IS NOT NULL
    GROUP BY `n_regionkey`
),
gen_freq AS (
    SELECT `n_regionkey`, COUNT(*) AS cnt
    FROM `gen`.`nation`
    WHERE `n_regionkey` IS NOT NULL
    GROUP BY `n_regionkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'nation' AS child_table,
       'n_regionkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `s_nationkey`, COUNT(*) AS cnt
    FROM `src`.`supplier`
    WHERE `s_nationkey` IS NOT NULL
    GROUP BY `s_nationkey`
),
gen_freq AS (
    SELECT `s_nationkey`, COUNT(*) AS cnt
    FROM `gen`.`supplier`
    WHERE `s_nationkey` IS NOT NULL
    GROUP BY `s_nationkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'supplier' AS child_table,
       's_nationkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `c_nationkey`, COUNT(*) AS cnt
    FROM `src`.`customer`
    WHERE `c_nationkey` IS NOT NULL
    GROUP BY `c_nationkey`
),
gen_freq AS (
    SELECT `c_nationkey`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_nationkey` IS NOT NULL
    GROUP BY `c_nationkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'customer' AS child_table,
       'c_nationkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ps_partkey`, COUNT(*) AS cnt
    FROM `src`.`partsupp`
    WHERE `ps_partkey` IS NOT NULL
    GROUP BY `ps_partkey`
),
gen_freq AS (
    SELECT `ps_partkey`, COUNT(*) AS cnt
    FROM `gen`.`partsupp`
    WHERE `ps_partkey` IS NOT NULL
    GROUP BY `ps_partkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'partsupp' AS child_table,
       'ps_partkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ps_suppkey`, COUNT(*) AS cnt
    FROM `src`.`partsupp`
    WHERE `ps_suppkey` IS NOT NULL
    GROUP BY `ps_suppkey`
),
gen_freq AS (
    SELECT `ps_suppkey`, COUNT(*) AS cnt
    FROM `gen`.`partsupp`
    WHERE `ps_suppkey` IS NOT NULL
    GROUP BY `ps_suppkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'partsupp' AS child_table,
       'ps_suppkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `o_custkey`, COUNT(*) AS cnt
    FROM `src`.`orders`
    WHERE `o_custkey` IS NOT NULL
    GROUP BY `o_custkey`
),
gen_freq AS (
    SELECT `o_custkey`, COUNT(*) AS cnt
    FROM `gen`.`orders`
    WHERE `o_custkey` IS NOT NULL
    GROUP BY `o_custkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'orders' AS child_table,
       'o_custkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `l_orderkey`, COUNT(*) AS cnt
    FROM `src`.`lineitem`
    WHERE `l_orderkey` IS NOT NULL
    GROUP BY `l_orderkey`
),
gen_freq AS (
    SELECT `l_orderkey`, COUNT(*) AS cnt
    FROM `gen`.`lineitem`
    WHERE `l_orderkey` IS NOT NULL
    GROUP BY `l_orderkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'lineitem' AS child_table,
       'l_orderkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `l_partkey`, COUNT(*) AS cnt
    FROM `src`.`lineitem`
    WHERE `l_partkey` IS NOT NULL
    GROUP BY `l_partkey`
),
gen_freq AS (
    SELECT `l_partkey`, COUNT(*) AS cnt
    FROM `gen`.`lineitem`
    WHERE `l_partkey` IS NOT NULL
    GROUP BY `l_partkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'lineitem' AS child_table,
       'l_partkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `l_suppkey`, COUNT(*) AS cnt
    FROM `src`.`lineitem`
    WHERE `l_suppkey` IS NOT NULL
    GROUP BY `l_suppkey`
),
gen_freq AS (
    SELECT `l_suppkey`, COUNT(*) AS cnt
    FROM `gen`.`lineitem`
    WHERE `l_suppkey` IS NOT NULL
    GROUP BY `l_suppkey`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'lineitem' AS child_table,
       'l_suppkey' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

-- ============================================================
-- TPC-H: 5) GENERATED FK PARENT COVERAGE
-- ============================================================

SELECT 'nation' AS child_table,
       'n_regionkey' AS fk_column,
       'region' AS parent_table,
       (SELECT COUNT(DISTINCT `n_regionkey`)
          FROM `gen`.`nation`
         WHERE `n_regionkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`region`) AS total_parent_keys;

SELECT 'supplier' AS child_table,
       's_nationkey' AS fk_column,
       'nation' AS parent_table,
       (SELECT COUNT(DISTINCT `s_nationkey`)
          FROM `gen`.`supplier`
         WHERE `s_nationkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`nation`) AS total_parent_keys;

SELECT 'customer' AS child_table,
       'c_nationkey' AS fk_column,
       'nation' AS parent_table,
       (SELECT COUNT(DISTINCT `c_nationkey`)
          FROM `gen`.`customer`
         WHERE `c_nationkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`nation`) AS total_parent_keys;

SELECT 'partsupp' AS child_table,
       'ps_partkey' AS fk_column,
       'part' AS parent_table,
       (SELECT COUNT(DISTINCT `ps_partkey`)
          FROM `gen`.`partsupp`
         WHERE `ps_partkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`part`) AS total_parent_keys;

SELECT 'partsupp' AS child_table,
       'ps_suppkey' AS fk_column,
       'supplier' AS parent_table,
       (SELECT COUNT(DISTINCT `ps_suppkey`)
          FROM `gen`.`partsupp`
         WHERE `ps_suppkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`supplier`) AS total_parent_keys;

SELECT 'orders' AS child_table,
       'o_custkey' AS fk_column,
       'customer' AS parent_table,
       (SELECT COUNT(DISTINCT `o_custkey`)
          FROM `gen`.`orders`
         WHERE `o_custkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`customer`) AS total_parent_keys;

SELECT 'lineitem' AS child_table,
       'l_orderkey' AS fk_column,
       'orders' AS parent_table,
       (SELECT COUNT(DISTINCT `l_orderkey`)
          FROM `gen`.`lineitem`
         WHERE `l_orderkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`orders`) AS total_parent_keys;

SELECT 'lineitem' AS child_table,
       'l_partkey' AS fk_column,
       'part' AS parent_table,
       (SELECT COUNT(DISTINCT `l_partkey`)
          FROM `gen`.`lineitem`
         WHERE `l_partkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`part`) AS total_parent_keys;

SELECT 'lineitem' AS child_table,
       'l_suppkey' AS fk_column,
       'supplier' AS parent_table,
       (SELECT COUNT(DISTINCT `l_suppkey`)
          FROM `gen`.`lineitem`
         WHERE `l_suppkey` IS NOT NULL) AS referenced_parent_keys,
       (SELECT COUNT(*)
          FROM `gen`.`supplier`) AS total_parent_keys;

-- ============================================================
-- TPC-H: 6) GENERATED FK REFERENTIAL INTEGRITY
-- ============================================================

SELECT 'nation' AS child_table,
       'n_regionkey' AS fk_column,
       'region' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`nation` c
LEFT JOIN `gen`.`region` p
  ON c.`n_regionkey` = p.`r_regionkey`
WHERE c.`n_regionkey` IS NOT NULL
  AND p.`r_regionkey` IS NULL;

SELECT 'supplier' AS child_table,
       's_nationkey' AS fk_column,
       'nation' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`supplier` c
LEFT JOIN `gen`.`nation` p
  ON c.`s_nationkey` = p.`n_nationkey`
WHERE c.`s_nationkey` IS NOT NULL
  AND p.`n_nationkey` IS NULL;

SELECT 'customer' AS child_table,
       'c_nationkey' AS fk_column,
       'nation' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`customer` c
LEFT JOIN `gen`.`nation` p
  ON c.`c_nationkey` = p.`n_nationkey`
WHERE c.`c_nationkey` IS NOT NULL
  AND p.`n_nationkey` IS NULL;

SELECT 'partsupp' AS child_table,
       'ps_partkey' AS fk_column,
       'part' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`partsupp` c
LEFT JOIN `gen`.`part` p
  ON c.`ps_partkey` = p.`p_partkey`
WHERE c.`ps_partkey` IS NOT NULL
  AND p.`p_partkey` IS NULL;

SELECT 'partsupp' AS child_table,
       'ps_suppkey' AS fk_column,
       'supplier' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`partsupp` c
LEFT JOIN `gen`.`supplier` p
  ON c.`ps_suppkey` = p.`s_suppkey`
WHERE c.`ps_suppkey` IS NOT NULL
  AND p.`s_suppkey` IS NULL;

SELECT 'orders' AS child_table,
       'o_custkey' AS fk_column,
       'customer' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`orders` c
LEFT JOIN `gen`.`customer` p
  ON c.`o_custkey` = p.`c_custkey`
WHERE c.`o_custkey` IS NOT NULL
  AND p.`c_custkey` IS NULL;

SELECT 'lineitem' AS child_table,
       'l_orderkey' AS fk_column,
       'orders' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`lineitem` c
LEFT JOIN `gen`.`orders` p
  ON c.`l_orderkey` = p.`o_orderkey`
WHERE c.`l_orderkey` IS NOT NULL
  AND p.`o_orderkey` IS NULL;

SELECT 'lineitem' AS child_table,
       'l_partkey' AS fk_column,
       'part' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`lineitem` c
LEFT JOIN `gen`.`part` p
  ON c.`l_partkey` = p.`p_partkey`
WHERE c.`l_partkey` IS NOT NULL
  AND p.`p_partkey` IS NULL;

SELECT 'lineitem' AS child_table,
       'l_suppkey' AS fk_column,
       'supplier' AS parent_table,
       COUNT(*) AS orphan_count
FROM `gen`.`lineitem` c
LEFT JOIN `gen`.`supplier` p
  ON c.`l_suppkey` = p.`s_suppkey`
WHERE c.`l_suppkey` IS NOT NULL
  AND p.`s_suppkey` IS NULL;

-- ============================================================
-- TPC-H: 7) FK NULL COUNT
-- ============================================================

SELECT 'nation' AS child_table,
       'n_regionkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`nation` WHERE `n_regionkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`nation` WHERE `n_regionkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`nation` WHERE `n_regionkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`nation` WHERE `n_regionkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`nation` WHERE `n_regionkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`nation` WHERE `n_regionkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'supplier' AS child_table,
       's_nationkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`supplier` WHERE `s_nationkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`supplier` WHERE `s_nationkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`supplier` WHERE `s_nationkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`supplier` WHERE `s_nationkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`supplier` WHERE `s_nationkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`supplier` WHERE `s_nationkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'customer' AS child_table,
       'c_nationkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`customer` WHERE `c_nationkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`customer` WHERE `c_nationkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`customer` WHERE `c_nationkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`customer` WHERE `c_nationkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`customer` WHERE `c_nationkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`customer` WHERE `c_nationkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'partsupp' AS child_table,
       'ps_partkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_partkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`partsupp` WHERE `ps_partkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_partkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`partsupp` WHERE `ps_partkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_partkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_partkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'partsupp' AS child_table,
       'ps_suppkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_suppkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`partsupp` WHERE `ps_suppkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_suppkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`partsupp` WHERE `ps_suppkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_suppkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`partsupp` WHERE `ps_suppkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'orders' AS child_table,
       'o_custkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`orders` WHERE `o_custkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`orders` WHERE `o_custkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`orders` WHERE `o_custkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`orders` WHERE `o_custkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`orders` WHERE `o_custkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`orders` WHERE `o_custkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'lineitem' AS child_table,
       'l_orderkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_orderkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`lineitem` WHERE `l_orderkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_orderkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`lineitem` WHERE `l_orderkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_orderkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_orderkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'lineitem' AS child_table,
       'l_partkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_partkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`lineitem` WHERE `l_partkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_partkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`lineitem` WHERE `l_partkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_partkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_partkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

SELECT 'lineitem' AS child_table,
       'l_suppkey' AS fk_column,
       (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_suppkey` IS NULL) AS source_null_count,
       (SELECT COUNT(*) FROM `gen`.`lineitem` WHERE `l_suppkey` IS NULL) AS generated_null_count,
       CASE
         WHEN (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_suppkey` IS NULL) = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (SELECT COUNT(*) FROM `gen`.`lineitem` WHERE `l_suppkey` IS NULL) -
             (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_suppkey` IS NULL)
           ) / NULLIF(
             (SELECT COUNT(*) FROM `src`.`lineitem` WHERE `l_suppkey` IS NULL),
             0
           ),
           2
         )
       END AS null_count_pct_diff;

-- ============================================================
-- TPC-H: 8) GENERATED FK VALUE FREQUENCY DETAIL
-- ============================================================

SELECT 'nation' AS child_table,
       'n_regionkey' AS fk_column,
       `n_regionkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`nation`
WHERE `n_regionkey` IS NOT NULL
GROUP BY `n_regionkey`
ORDER BY `n_regionkey`;

SELECT 'supplier' AS child_table,
       's_nationkey' AS fk_column,
       `s_nationkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`supplier`
WHERE `s_nationkey` IS NOT NULL
GROUP BY `s_nationkey`
ORDER BY `s_nationkey`;

SELECT 'customer' AS child_table,
       'c_nationkey' AS fk_column,
       `c_nationkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`customer`
WHERE `c_nationkey` IS NOT NULL
GROUP BY `c_nationkey`
ORDER BY `c_nationkey`;

SELECT 'partsupp' AS child_table,
       'ps_partkey' AS fk_column,
       `ps_partkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`partsupp`
WHERE `ps_partkey` IS NOT NULL
GROUP BY `ps_partkey`
ORDER BY `ps_partkey`;

SELECT 'partsupp' AS child_table,
       'ps_suppkey' AS fk_column,
       `ps_suppkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`partsupp`
WHERE `ps_suppkey` IS NOT NULL
GROUP BY `ps_suppkey`
ORDER BY `ps_suppkey`;

SELECT 'orders' AS child_table,
       'o_custkey' AS fk_column,
       `o_custkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`orders`
WHERE `o_custkey` IS NOT NULL
GROUP BY `o_custkey`
ORDER BY `o_custkey`;

SELECT 'lineitem' AS child_table,
       'l_orderkey' AS fk_column,
       `l_orderkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`lineitem`
WHERE `l_orderkey` IS NOT NULL
GROUP BY `l_orderkey`
ORDER BY `l_orderkey`;

SELECT 'lineitem' AS child_table,
       'l_partkey' AS fk_column,
       `l_partkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`lineitem`
WHERE `l_partkey` IS NOT NULL
GROUP BY `l_partkey`
ORDER BY `l_partkey`;

SELECT 'lineitem' AS child_table,
       'l_suppkey' AS fk_column,
       `l_suppkey` AS fk_value,
       COUNT(*) AS freq
FROM `gen`.`lineitem`
WHERE `l_suppkey` IS NOT NULL
GROUP BY `l_suppkey`
ORDER BY `l_suppkey`;

-- ============================================================
-- TPC-H: 9) GENERATED PK UNIQUENESS
-- ============================================================

SELECT 'region' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `r_regionkey`
    FROM `gen`.`region`
    GROUP BY `r_regionkey`
    HAVING COUNT(*) > 1
) AS d;

SELECT 'nation' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `n_nationkey`
    FROM `gen`.`nation`
    GROUP BY `n_nationkey`
    HAVING COUNT(*) > 1
) AS d;

SELECT 'supplier' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `s_suppkey`
    FROM `gen`.`supplier`
    GROUP BY `s_suppkey`
    HAVING COUNT(*) > 1
) AS d;

SELECT 'customer' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `c_custkey`
    FROM `gen`.`customer`
    GROUP BY `c_custkey`
    HAVING COUNT(*) > 1
) AS d;

SELECT 'part' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `p_partkey`
    FROM `gen`.`part`
    GROUP BY `p_partkey`
    HAVING COUNT(*) > 1
) AS d;

SELECT 'partsupp' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `ps_partkey`, `ps_suppkey`
    FROM `gen`.`partsupp`
    GROUP BY `ps_partkey`, `ps_suppkey`
    HAVING COUNT(*) > 1
) AS d;

SELECT 'orders' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `o_orderkey`
    FROM `gen`.`orders`
    GROUP BY `o_orderkey`
    HAVING COUNT(*) > 1
) AS d;

SELECT 'lineitem' AS table_name,
       COUNT(*) AS duplicate_pk_group_count
FROM (
    SELECT `l_orderkey`, `l_linenumber`
    FROM `gen`.`lineitem`
    GROUP BY `l_orderkey`, `l_linenumber`
    HAVING COUNT(*) > 1
) AS d;

-- ============================================================
-- TPC-H: EXTRA CHECKS
-- ============================================================

SELECT 'lineitem' AS child_table,
       '(l_partkey,l_suppkey)' AS fk_column_pair,
       'partsupp' AS parent_table,
       COUNT(*) AS invalid_pair_count
FROM `gen`.`lineitem` l
LEFT JOIN `gen`.`partsupp` ps
  ON l.`l_partkey` = ps.`ps_partkey`
 AND l.`l_suppkey` = ps.`ps_suppkey`
WHERE l.`l_partkey` IS NOT NULL
  AND l.`l_suppkey` IS NOT NULL
  AND ps.`ps_partkey` IS NULL;
662 |

-- ############################################################

-- MYSQL 8.0+ : TPC-DS SYNTHETIC DATA VALIDATION SQL

-- ############################################################

666 |

-- ============================================================
-- TPC-DS: 1) ROW COUNT
-- ============================================================

SELECT 'date_dim' AS table_name,
       (SELECT COUNT(*) FROM `src`.`date_dim`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`date_dim`) AS generated_count;

SELECT 'time_dim' AS table_name,
       (SELECT COUNT(*) FROM `src`.`time_dim`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`time_dim`) AS generated_count;

SELECT 'customer' AS table_name,
       (SELECT COUNT(*) FROM `src`.`customer`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`customer`) AS generated_count;

SELECT 'customer_address' AS table_name,
       (SELECT COUNT(*) FROM `src`.`customer_address`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`customer_address`) AS generated_count;

SELECT 'customer_demographics' AS table_name,
       (SELECT COUNT(*) FROM `src`.`customer_demographics`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`customer_demographics`) AS generated_count;

SELECT 'household_demographics' AS table_name,
       (SELECT COUNT(*) FROM `src`.`household_demographics`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`household_demographics`) AS generated_count;

SELECT 'income_band' AS table_name,
       (SELECT COUNT(*) FROM `src`.`income_band`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`income_band`) AS generated_count;

SELECT 'item' AS table_name,
       (SELECT COUNT(*) FROM `src`.`item`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`item`) AS generated_count;

SELECT 'promotion' AS table_name,
       (SELECT COUNT(*) FROM `src`.`promotion`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`promotion`) AS generated_count;

SELECT 'reason' AS table_name,
       (SELECT COUNT(*) FROM `src`.`reason`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`reason`) AS generated_count;

SELECT 'ship_mode' AS table_name,
       (SELECT COUNT(*) FROM `src`.`ship_mode`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`ship_mode`) AS generated_count;

SELECT 'store' AS table_name,
       (SELECT COUNT(*) FROM `src`.`store`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`store`) AS generated_count;

SELECT 'warehouse' AS table_name,
       (SELECT COUNT(*) FROM `src`.`warehouse`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`warehouse`) AS generated_count;

SELECT 'web_site' AS table_name,
       (SELECT COUNT(*) FROM `src`.`web_site`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`web_site`) AS generated_count;

SELECT 'web_page' AS table_name,
       (SELECT COUNT(*) FROM `src`.`web_page`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`web_page`) AS generated_count;

SELECT 'catalog_page' AS table_name,
       (SELECT COUNT(*) FROM `src`.`catalog_page`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`catalog_page`) AS generated_count;

SELECT 'call_center' AS table_name,
       (SELECT COUNT(*) FROM `src`.`call_center`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`call_center`) AS generated_count;

SELECT 'store_sales' AS table_name,
       (SELECT COUNT(*) FROM `src`.`store_sales`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`store_sales`) AS generated_count;

SELECT 'store_returns' AS table_name,
       (SELECT COUNT(*) FROM `src`.`store_returns`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`store_returns`) AS generated_count;

SELECT 'catalog_sales' AS table_name,
       (SELECT COUNT(*) FROM `src`.`catalog_sales`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`catalog_sales`) AS generated_count;

SELECT 'catalog_returns' AS table_name,
       (SELECT COUNT(*) FROM `src`.`catalog_returns`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`catalog_returns`) AS generated_count;

SELECT 'web_sales' AS table_name,
       (SELECT COUNT(*) FROM `src`.`web_sales`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`web_sales`) AS generated_count;

SELECT 'web_returns' AS table_name,
       (SELECT COUNT(*) FROM `src`.`web_returns`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`web_returns`) AS generated_count;

SELECT 'inventory' AS table_name,
       (SELECT COUNT(*) FROM `src`.`inventory`) AS source_count,
       (SELECT COUNT(*) FROM `gen`.`inventory`) AS generated_count;

-- ============================================================
-- TPC-DS: 2) DISTINCT COUNT ON PK / FK / PREDICATE COLS
-- ============================================================

SELECT 'date_dim' AS table_name,
       'd_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `d_date_sk`) FROM `src`.`date_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `d_date_sk`) FROM `gen`.`date_dim`) AS generated_distinct_count;

SELECT 'date_dim' AS table_name,
       'd_year' AS column_name,
       (SELECT COUNT(DISTINCT `d_year`) FROM `src`.`date_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `d_year`) FROM `gen`.`date_dim`) AS generated_distinct_count;

SELECT 'date_dim' AS table_name,
       'd_moy' AS column_name,
       (SELECT COUNT(DISTINCT `d_moy`) FROM `src`.`date_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `d_moy`) FROM `gen`.`date_dim`) AS generated_distinct_count;

SELECT 'date_dim' AS table_name,
       'd_qoy' AS column_name,
       (SELECT COUNT(DISTINCT `d_qoy`) FROM `src`.`date_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `d_qoy`) FROM `gen`.`date_dim`) AS generated_distinct_count;

SELECT 'date_dim' AS table_name,
       'd_date' AS column_name,
       (SELECT COUNT(DISTINCT `d_date`) FROM `src`.`date_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `d_date`) FROM `gen`.`date_dim`) AS generated_distinct_count;

SELECT 'time_dim' AS table_name,
       't_time_sk' AS column_name,
       (SELECT COUNT(DISTINCT `t_time_sk`) FROM `src`.`time_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `t_time_sk`) FROM `gen`.`time_dim`) AS generated_distinct_count;

SELECT 'time_dim' AS table_name,
       't_hour' AS column_name,
       (SELECT COUNT(DISTINCT `t_hour`) FROM `src`.`time_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `t_hour`) FROM `gen`.`time_dim`) AS generated_distinct_count;

SELECT 'time_dim' AS table_name,
       't_minute' AS column_name,
       (SELECT COUNT(DISTINCT `t_minute`) FROM `src`.`time_dim`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `t_minute`) FROM `gen`.`time_dim`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `c_customer_sk`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_customer_sk`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_current_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `c_current_cdemo_sk`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_current_cdemo_sk`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_current_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `c_current_hdemo_sk`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_current_hdemo_sk`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_current_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `c_current_addr_sk`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_current_addr_sk`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_first_shipto_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `c_first_shipto_date_sk`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_first_shipto_date_sk`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_first_sales_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `c_first_sales_date_sk`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_first_sales_date_sk`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_customer_id' AS column_name,
       (SELECT COUNT(DISTINCT `c_customer_id`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_customer_id`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_salutation' AS column_name,
       (SELECT COUNT(DISTINCT `c_salutation`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_salutation`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer' AS table_name,
       'c_preferred_cust_flag' AS column_name,
       (SELECT COUNT(DISTINCT `c_preferred_cust_flag`) FROM `src`.`customer`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `c_preferred_cust_flag`) FROM `gen`.`customer`) AS generated_distinct_count;

SELECT 'customer_address' AS table_name,
       'ca_address_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ca_address_sk`) FROM `src`.`customer_address`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ca_address_sk`) FROM `gen`.`customer_address`) AS generated_distinct_count;

SELECT 'customer_address' AS table_name,
       'ca_state' AS column_name,
       (SELECT COUNT(DISTINCT `ca_state`) FROM `src`.`customer_address`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ca_state`) FROM `gen`.`customer_address`) AS generated_distinct_count;

SELECT 'customer_address' AS table_name,
       'ca_zip' AS column_name,
       (SELECT COUNT(DISTINCT `ca_zip`) FROM `src`.`customer_address`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ca_zip`) FROM `gen`.`customer_address`) AS generated_distinct_count;

SELECT 'customer_address' AS table_name,
       'ca_country' AS column_name,
       (SELECT COUNT(DISTINCT `ca_country`) FROM `src`.`customer_address`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ca_country`) FROM `gen`.`customer_address`) AS generated_distinct_count;

SELECT 'customer_demographics' AS table_name,
       'cd_demo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cd_demo_sk`) FROM `src`.`customer_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cd_demo_sk`) FROM `gen`.`customer_demographics`) AS generated_distinct_count;

SELECT 'customer_demographics' AS table_name,
       'cd_gender' AS column_name,
       (SELECT COUNT(DISTINCT `cd_gender`) FROM `src`.`customer_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cd_gender`) FROM `gen`.`customer_demographics`) AS generated_distinct_count;

SELECT 'customer_demographics' AS table_name,
       'cd_marital_status' AS column_name,
       (SELECT COUNT(DISTINCT `cd_marital_status`) FROM `src`.`customer_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cd_marital_status`) FROM `gen`.`customer_demographics`) AS generated_distinct_count;

SELECT 'customer_demographics' AS table_name,
       'cd_education_status' AS column_name,
       (SELECT COUNT(DISTINCT `cd_education_status`) FROM `src`.`customer_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cd_education_status`) FROM `gen`.`customer_demographics`) AS generated_distinct_count;

SELECT 'household_demographics' AS table_name,
       'hd_demo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `hd_demo_sk`) FROM `src`.`household_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `hd_demo_sk`) FROM `gen`.`household_demographics`) AS generated_distinct_count;

SELECT 'household_demographics' AS table_name,
       'hd_income_band_sk' AS column_name,
       (SELECT COUNT(DISTINCT `hd_income_band_sk`) FROM `src`.`household_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `hd_income_band_sk`) FROM `gen`.`household_demographics`) AS generated_distinct_count;

SELECT 'household_demographics' AS table_name,
       'hd_buy_potential' AS column_name,
       (SELECT COUNT(DISTINCT `hd_buy_potential`) FROM `src`.`household_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `hd_buy_potential`) FROM `gen`.`household_demographics`) AS generated_distinct_count;

SELECT 'household_demographics' AS table_name,
       'hd_dep_count' AS column_name,
       (SELECT COUNT(DISTINCT `hd_dep_count`) FROM `src`.`household_demographics`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `hd_dep_count`) FROM `gen`.`household_demographics`) AS generated_distinct_count;

SELECT 'income_band' AS table_name,
       'ib_income_band_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ib_income_band_sk`) FROM `src`.`income_band`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ib_income_band_sk`) FROM `gen`.`income_band`) AS generated_distinct_count;

SELECT 'income_band' AS table_name,
       'ib_lower_bound' AS column_name,
       (SELECT COUNT(DISTINCT `ib_lower_bound`) FROM `src`.`income_band`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ib_lower_bound`) FROM `gen`.`income_band`) AS generated_distinct_count;

SELECT 'income_band' AS table_name,
       'ib_upper_bound' AS column_name,
       (SELECT COUNT(DISTINCT `ib_upper_bound`) FROM `src`.`income_band`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ib_upper_bound`) FROM `gen`.`income_band`) AS generated_distinct_count;

SELECT 'item' AS table_name,
       'i_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `i_item_sk`) FROM `src`.`item`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `i_item_sk`) FROM `gen`.`item`) AS generated_distinct_count;

SELECT 'item' AS table_name,
       'i_item_id' AS column_name,
       (SELECT COUNT(DISTINCT `i_item_id`) FROM `src`.`item`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `i_item_id`) FROM `gen`.`item`) AS generated_distinct_count;

SELECT 'item' AS table_name,
       'i_brand' AS column_name,
       (SELECT COUNT(DISTINCT `i_brand`) FROM `src`.`item`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `i_brand`) FROM `gen`.`item`) AS generated_distinct_count;

SELECT 'item' AS table_name,
       'i_class' AS column_name,
       (SELECT COUNT(DISTINCT `i_class`) FROM `src`.`item`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `i_class`) FROM `gen`.`item`) AS generated_distinct_count;

SELECT 'item' AS table_name,
       'i_category' AS column_name,
       (SELECT COUNT(DISTINCT `i_category`) FROM `src`.`item`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `i_category`) FROM `gen`.`item`) AS generated_distinct_count;

SELECT 'item' AS table_name,
       'i_manufact' AS column_name,
       (SELECT COUNT(DISTINCT `i_manufact`) FROM `src`.`item`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `i_manufact`) FROM `gen`.`item`) AS generated_distinct_count;

SELECT 'promotion' AS table_name,
       'p_promo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `p_promo_sk`) FROM `src`.`promotion`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_promo_sk`) FROM `gen`.`promotion`) AS generated_distinct_count;

SELECT 'promotion' AS table_name,
       'p_start_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `p_start_date_sk`) FROM `src`.`promotion`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_start_date_sk`) FROM `gen`.`promotion`) AS generated_distinct_count;

SELECT 'promotion' AS table_name,
       'p_end_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `p_end_date_sk`) FROM `src`.`promotion`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_end_date_sk`) FROM `gen`.`promotion`) AS generated_distinct_count;

SELECT 'promotion' AS table_name,
       'p_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `p_item_sk`) FROM `src`.`promotion`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_item_sk`) FROM `gen`.`promotion`) AS generated_distinct_count;

SELECT 'promotion' AS table_name,
       'p_channel_email' AS column_name,
       (SELECT COUNT(DISTINCT `p_channel_email`) FROM `src`.`promotion`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_channel_email`) FROM `gen`.`promotion`) AS generated_distinct_count;

SELECT 'promotion' AS table_name,
       'p_channel_event' AS column_name,
       (SELECT COUNT(DISTINCT `p_channel_event`) FROM `src`.`promotion`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_channel_event`) FROM `gen`.`promotion`) AS generated_distinct_count;

SELECT 'promotion' AS table_name,
       'p_discount_active' AS column_name,
       (SELECT COUNT(DISTINCT `p_discount_active`) FROM `src`.`promotion`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `p_discount_active`) FROM `gen`.`promotion`) AS generated_distinct_count;

SELECT 'reason' AS table_name,
       'r_reason_sk' AS column_name,
       (SELECT COUNT(DISTINCT `r_reason_sk`) FROM `src`.`reason`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `r_reason_sk`) FROM `gen`.`reason`) AS generated_distinct_count;

SELECT 'reason' AS table_name,
       'r_reason_desc' AS column_name,
       (SELECT COUNT(DISTINCT `r_reason_desc`) FROM `src`.`reason`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `r_reason_desc`) FROM `gen`.`reason`) AS generated_distinct_count;

SELECT 'ship_mode' AS table_name,
       'sm_ship_mode_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sm_ship_mode_sk`) FROM `src`.`ship_mode`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sm_ship_mode_sk`) FROM `gen`.`ship_mode`) AS generated_distinct_count;

SELECT 'ship_mode' AS table_name,
       'sm_type' AS column_name,
       (SELECT COUNT(DISTINCT `sm_type`) FROM `src`.`ship_mode`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sm_type`) FROM `gen`.`ship_mode`) AS generated_distinct_count;

SELECT 'ship_mode' AS table_name,
       'sm_carrier' AS column_name,
       (SELECT COUNT(DISTINCT `sm_carrier`) FROM `src`.`ship_mode`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sm_carrier`) FROM `gen`.`ship_mode`) AS generated_distinct_count;

SELECT 'store' AS table_name,
       's_store_sk' AS column_name,
       (SELECT COUNT(DISTINCT `s_store_sk`) FROM `src`.`store`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `s_store_sk`) FROM `gen`.`store`) AS generated_distinct_count;

SELECT 'store' AS table_name,
       's_store_id' AS column_name,
       (SELECT COUNT(DISTINCT `s_store_id`) FROM `src`.`store`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `s_store_id`) FROM `gen`.`store`) AS generated_distinct_count;

SELECT 'store' AS table_name,
       's_state' AS column_name,
       (SELECT COUNT(DISTINCT `s_state`) FROM `src`.`store`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `s_state`) FROM `gen`.`store`) AS generated_distinct_count;

SELECT 'store' AS table_name,
       's_county' AS column_name,
       (SELECT COUNT(DISTINCT `s_county`) FROM `src`.`store`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `s_county`) FROM `gen`.`store`) AS generated_distinct_count;

SELECT 'warehouse' AS table_name,
       'w_warehouse_sk' AS column_name,
       (SELECT COUNT(DISTINCT `w_warehouse_sk`) FROM `src`.`warehouse`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `w_warehouse_sk`) FROM `gen`.`warehouse`) AS generated_distinct_count;

SELECT 'warehouse' AS table_name,
       'w_warehouse_name' AS column_name,
       (SELECT COUNT(DISTINCT `w_warehouse_name`) FROM `src`.`warehouse`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `w_warehouse_name`) FROM `gen`.`warehouse`) AS generated_distinct_count;

SELECT 'warehouse' AS table_name,
       'w_state' AS column_name,
       (SELECT COUNT(DISTINCT `w_state`) FROM `src`.`warehouse`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `w_state`) FROM `gen`.`warehouse`) AS generated_distinct_count;

SELECT 'web_site' AS table_name,
       'web_site_sk' AS column_name,
       (SELECT COUNT(DISTINCT `web_site_sk`) FROM `src`.`web_site`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `web_site_sk`) FROM `gen`.`web_site`) AS generated_distinct_count;

SELECT 'web_site' AS table_name,
       'web_open_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `web_open_date_sk`) FROM `src`.`web_site`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `web_open_date_sk`) FROM `gen`.`web_site`) AS generated_distinct_count;

SELECT 'web_site' AS table_name,
       'web_close_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `web_close_date_sk`) FROM `src`.`web_site`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `web_close_date_sk`) FROM `gen`.`web_site`) AS generated_distinct_count;

SELECT 'web_site' AS table_name,
       'web_name' AS column_name,
       (SELECT COUNT(DISTINCT `web_name`) FROM `src`.`web_site`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `web_name`) FROM `gen`.`web_site`) AS generated_distinct_count;

SELECT 'web_site' AS table_name,
       'web_class' AS column_name,
       (SELECT COUNT(DISTINCT `web_class`) FROM `src`.`web_site`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `web_class`) FROM `gen`.`web_site`) AS generated_distinct_count;

SELECT 'web_site' AS table_name,
       'web_company_name' AS column_name,
       (SELECT COUNT(DISTINCT `web_company_name`) FROM `src`.`web_site`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `web_company_name`) FROM `gen`.`web_site`) AS generated_distinct_count;

SELECT 'web_page' AS table_name,
       'wp_web_page_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wp_web_page_sk`) FROM `src`.`web_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wp_web_page_sk`) FROM `gen`.`web_page`) AS generated_distinct_count;

SELECT 'web_page' AS table_name,
       'wp_creation_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wp_creation_date_sk`) FROM `src`.`web_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wp_creation_date_sk`) FROM `gen`.`web_page`) AS generated_distinct_count;

SELECT 'web_page' AS table_name,
       'wp_access_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wp_access_date_sk`) FROM `src`.`web_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wp_access_date_sk`) FROM `gen`.`web_page`) AS generated_distinct_count;

SELECT 'web_page' AS table_name,
       'wp_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wp_customer_sk`) FROM `src`.`web_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wp_customer_sk`) FROM `gen`.`web_page`) AS generated_distinct_count;

SELECT 'web_page' AS table_name,
       'wp_web_page_id' AS column_name,
       (SELECT COUNT(DISTINCT `wp_web_page_id`) FROM `src`.`web_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wp_web_page_id`) FROM `gen`.`web_page`) AS generated_distinct_count;

SELECT 'web_page' AS table_name,
       'wp_type' AS column_name,
       (SELECT COUNT(DISTINCT `wp_type`) FROM `src`.`web_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wp_type`) FROM `gen`.`web_page`) AS generated_distinct_count;

SELECT 'catalog_page' AS table_name,
       'cp_catalog_page_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cp_catalog_page_sk`) FROM `src`.`catalog_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cp_catalog_page_sk`) FROM `gen`.`catalog_page`) AS generated_distinct_count;

SELECT 'catalog_page' AS table_name,
       'cp_start_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cp_start_date_sk`) FROM `src`.`catalog_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cp_start_date_sk`) FROM `gen`.`catalog_page`) AS generated_distinct_count;

SELECT 'catalog_page' AS table_name,
       'cp_end_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cp_end_date_sk`) FROM `src`.`catalog_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cp_end_date_sk`) FROM `gen`.`catalog_page`) AS generated_distinct_count;

SELECT 'catalog_page' AS table_name,
       'cp_department' AS column_name,
       (SELECT COUNT(DISTINCT `cp_department`) FROM `src`.`catalog_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cp_department`) FROM `gen`.`catalog_page`) AS generated_distinct_count;

SELECT 'catalog_page' AS table_name,
       'cp_catalog_number' AS column_name,
       (SELECT COUNT(DISTINCT `cp_catalog_number`) FROM `src`.`catalog_page`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cp_catalog_number`) FROM `gen`.`catalog_page`) AS generated_distinct_count;

SELECT 'call_center' AS table_name,
       'cc_call_center_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cc_call_center_sk`) FROM `src`.`call_center`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cc_call_center_sk`) FROM `gen`.`call_center`) AS generated_distinct_count;

SELECT 'call_center' AS table_name,
       'cc_open_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cc_open_date_sk`) FROM `src`.`call_center`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cc_open_date_sk`) FROM `gen`.`call_center`) AS generated_distinct_count;

SELECT 'call_center' AS table_name,
       'cc_closed_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cc_closed_date_sk`) FROM `src`.`call_center`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cc_closed_date_sk`) FROM `gen`.`call_center`) AS generated_distinct_count;

SELECT 'call_center' AS table_name,
       'cc_name' AS column_name,
       (SELECT COUNT(DISTINCT `cc_name`) FROM `src`.`call_center`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cc_name`) FROM `gen`.`call_center`) AS generated_distinct_count;

SELECT 'call_center' AS table_name,
       'cc_class' AS column_name,
       (SELECT COUNT(DISTINCT `cc_class`) FROM `src`.`call_center`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cc_class`) FROM `gen`.`call_center`) AS generated_distinct_count;

SELECT 'call_center' AS table_name,
       'cc_county' AS column_name,
       (SELECT COUNT(DISTINCT `cc_county`) FROM `src`.`call_center`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cc_county`) FROM `gen`.`call_center`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_sold_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_sold_date_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_sold_date_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_sold_time_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_sold_time_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_sold_time_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_item_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_item_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_customer_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_customer_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_cdemo_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_cdemo_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_hdemo_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_hdemo_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_addr_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_addr_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_store_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_store_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_store_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_sales' AS table_name,
       'ss_promo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ss_promo_sk`) FROM `src`.`store_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ss_promo_sk`) FROM `gen`.`store_sales`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_returned_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_returned_date_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_returned_date_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_return_time_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_return_time_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_return_time_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_item_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_item_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_customer_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_customer_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_cdemo_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_cdemo_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_hdemo_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_hdemo_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_addr_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_addr_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_store_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_store_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_store_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'store_returns' AS table_name,
       'sr_reason_sk' AS column_name,
       (SELECT COUNT(DISTINCT `sr_reason_sk`) FROM `src`.`store_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `sr_reason_sk`) FROM `gen`.`store_returns`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_sold_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_sold_date_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_sold_date_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_sold_time_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_sold_time_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_sold_time_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_ship_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_ship_date_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_ship_date_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_bill_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_bill_customer_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_bill_customer_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_bill_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_bill_cdemo_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_bill_cdemo_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_bill_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_bill_hdemo_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_bill_hdemo_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_bill_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_bill_addr_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_bill_addr_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_ship_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_ship_customer_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_ship_customer_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_ship_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_ship_cdemo_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_ship_cdemo_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_ship_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_ship_hdemo_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_ship_hdemo_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_ship_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_ship_addr_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_ship_addr_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_call_center_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_call_center_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_call_center_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_catalog_page_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_catalog_page_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_catalog_page_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_ship_mode_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_ship_mode_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_ship_mode_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_warehouse_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_warehouse_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_warehouse_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_item_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_item_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_sales' AS table_name,
       'cs_promo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cs_promo_sk`) FROM `src`.`catalog_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cs_promo_sk`) FROM `gen`.`catalog_sales`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_returned_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_returned_date_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_returned_date_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_returned_time_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_returned_time_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_returned_time_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_item_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_item_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_refunded_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_refunded_customer_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_refunded_customer_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_refunded_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_refunded_cdemo_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_refunded_cdemo_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_refunded_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_refunded_hdemo_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_refunded_hdemo_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_refunded_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_refunded_addr_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_refunded_addr_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_returning_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_returning_customer_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_returning_customer_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_returning_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_returning_cdemo_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_returning_cdemo_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_returning_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_returning_hdemo_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_returning_hdemo_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_returning_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_returning_addr_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_returning_addr_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_call_center_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_call_center_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_call_center_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_catalog_page_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_catalog_page_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_catalog_page_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_ship_mode_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_ship_mode_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_ship_mode_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_warehouse_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_warehouse_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_warehouse_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'catalog_returns' AS table_name,
       'cr_reason_sk' AS column_name,
       (SELECT COUNT(DISTINCT `cr_reason_sk`) FROM `src`.`catalog_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `cr_reason_sk`) FROM `gen`.`catalog_returns`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_sold_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_sold_date_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_sold_date_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_sold_time_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_sold_time_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_sold_time_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_ship_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_ship_date_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_ship_date_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_item_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_item_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_bill_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_bill_customer_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_bill_customer_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_bill_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_bill_cdemo_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_bill_cdemo_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_bill_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_bill_hdemo_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_bill_hdemo_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_bill_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_bill_addr_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_bill_addr_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_ship_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_ship_customer_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_ship_customer_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_ship_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_ship_cdemo_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_ship_cdemo_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_ship_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_ship_hdemo_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_ship_hdemo_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_ship_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_ship_addr_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_ship_addr_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_web_page_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_web_page_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_web_page_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_web_site_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_web_site_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_web_site_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_ship_mode_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_ship_mode_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_ship_mode_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_warehouse_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_warehouse_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_warehouse_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_sales' AS table_name,
       'ws_promo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `ws_promo_sk`) FROM `src`.`web_sales`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `ws_promo_sk`) FROM `gen`.`web_sales`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_returned_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_returned_date_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_returned_date_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_returned_time_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_returned_time_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_returned_time_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_item_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_item_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_refunded_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_refunded_customer_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_refunded_customer_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_refunded_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_refunded_cdemo_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_refunded_cdemo_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_refunded_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_refunded_hdemo_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_refunded_hdemo_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_refunded_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_refunded_addr_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_refunded_addr_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_returning_customer_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_returning_customer_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_returning_customer_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_returning_cdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_returning_cdemo_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_returning_cdemo_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_returning_hdemo_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_returning_hdemo_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_returning_hdemo_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_returning_addr_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_returning_addr_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_returning_addr_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_web_page_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_web_page_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_web_page_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'web_returns' AS table_name,
       'wr_reason_sk' AS column_name,
       (SELECT COUNT(DISTINCT `wr_reason_sk`) FROM `src`.`web_returns`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `wr_reason_sk`) FROM `gen`.`web_returns`) AS generated_distinct_count;

SELECT 'inventory' AS table_name,
       'inv_date_sk' AS column_name,
       (SELECT COUNT(DISTINCT `inv_date_sk`) FROM `src`.`inventory`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `inv_date_sk`) FROM `gen`.`inventory`) AS generated_distinct_count;

SELECT 'inventory' AS table_name,
       'inv_item_sk' AS column_name,
       (SELECT COUNT(DISTINCT `inv_item_sk`) FROM `src`.`inventory`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `inv_item_sk`) FROM `gen`.`inventory`) AS generated_distinct_count;

SELECT 'inventory' AS table_name,
       'inv_warehouse_sk' AS column_name,
       (SELECT COUNT(DISTINCT `inv_warehouse_sk`) FROM `src`.`inventory`) AS source_distinct_count,
       (SELECT COUNT(DISTINCT `inv_warehouse_sk`) FROM `gen`.`inventory`) AS generated_distinct_count;

-- ============================================================
-- TPC-DS: 3) GENERATED FK DISTRIBUTION SUMMARY
-- ============================================================

WITH freq AS (
    SELECT `c_current_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_current_cdemo_sk` IS NOT NULL
    GROUP BY `c_current_cdemo_sk`
)
SELECT 'customer' AS child_table,
       'c_current_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `c_current_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_current_hdemo_sk` IS NOT NULL
    GROUP BY `c_current_hdemo_sk`
)
SELECT 'customer' AS child_table,
       'c_current_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `c_current_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_current_addr_sk` IS NOT NULL
    GROUP BY `c_current_addr_sk`
)
SELECT 'customer' AS child_table,
       'c_current_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `c_first_shipto_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_first_shipto_date_sk` IS NOT NULL
    GROUP BY `c_first_shipto_date_sk`
)
SELECT 'customer' AS child_table,
       'c_first_shipto_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `c_first_sales_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_first_sales_date_sk` IS NOT NULL
    GROUP BY `c_first_sales_date_sk`
)
SELECT 'customer' AS child_table,
       'c_first_sales_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `hd_income_band_sk`, COUNT(*) AS cnt
    FROM `gen`.`household_demographics`
    WHERE `hd_income_band_sk` IS NOT NULL
    GROUP BY `hd_income_band_sk`
)
SELECT 'household_demographics' AS child_table,
       'hd_income_band_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `p_start_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`promotion`
    WHERE `p_start_date_sk` IS NOT NULL
    GROUP BY `p_start_date_sk`
)
SELECT 'promotion' AS child_table,
       'p_start_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `p_end_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`promotion`
    WHERE `p_end_date_sk` IS NOT NULL
    GROUP BY `p_end_date_sk`
)
SELECT 'promotion' AS child_table,
       'p_end_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `p_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`promotion`
    WHERE `p_item_sk` IS NOT NULL
    GROUP BY `p_item_sk`
)
SELECT 'promotion' AS child_table,
       'p_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `web_open_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_site`
    WHERE `web_open_date_sk` IS NOT NULL
    GROUP BY `web_open_date_sk`
)
SELECT 'web_site' AS child_table,
       'web_open_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `web_close_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_site`
    WHERE `web_close_date_sk` IS NOT NULL
    GROUP BY `web_close_date_sk`
)
SELECT 'web_site' AS child_table,
       'web_close_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wp_creation_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_page`
    WHERE `wp_creation_date_sk` IS NOT NULL
    GROUP BY `wp_creation_date_sk`
)
SELECT 'web_page' AS child_table,
       'wp_creation_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wp_access_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_page`
    WHERE `wp_access_date_sk` IS NOT NULL
    GROUP BY `wp_access_date_sk`
)
SELECT 'web_page' AS child_table,
       'wp_access_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wp_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_page`
    WHERE `wp_customer_sk` IS NOT NULL
    GROUP BY `wp_customer_sk`
)
SELECT 'web_page' AS child_table,
       'wp_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cp_start_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_page`
    WHERE `cp_start_date_sk` IS NOT NULL
    GROUP BY `cp_start_date_sk`
)
SELECT 'catalog_page' AS child_table,
       'cp_start_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cp_end_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_page`
    WHERE `cp_end_date_sk` IS NOT NULL
    GROUP BY `cp_end_date_sk`
)
SELECT 'catalog_page' AS child_table,
       'cp_end_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cc_open_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`call_center`
    WHERE `cc_open_date_sk` IS NOT NULL
    GROUP BY `cc_open_date_sk`
)
SELECT 'call_center' AS child_table,
       'cc_open_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cc_closed_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`call_center`
    WHERE `cc_closed_date_sk` IS NOT NULL
    GROUP BY `cc_closed_date_sk`
)
SELECT 'call_center' AS child_table,
       'cc_closed_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_sold_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_sold_date_sk` IS NOT NULL
    GROUP BY `ss_sold_date_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_sold_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_sold_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_sold_time_sk` IS NOT NULL
    GROUP BY `ss_sold_time_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_sold_time_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_item_sk` IS NOT NULL
    GROUP BY `ss_item_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_customer_sk` IS NOT NULL
    GROUP BY `ss_customer_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_cdemo_sk` IS NOT NULL
    GROUP BY `ss_cdemo_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_hdemo_sk` IS NOT NULL
    GROUP BY `ss_hdemo_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_addr_sk` IS NOT NULL
    GROUP BY `ss_addr_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_store_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_store_sk` IS NOT NULL
    GROUP BY `ss_store_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_store_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ss_promo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_promo_sk` IS NOT NULL
    GROUP BY `ss_promo_sk`
)
SELECT 'store_sales' AS child_table,
       'ss_promo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_returned_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_returned_date_sk` IS NOT NULL
    GROUP BY `sr_returned_date_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_returned_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_return_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_return_time_sk` IS NOT NULL
    GROUP BY `sr_return_time_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_return_time_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_item_sk` IS NOT NULL
    GROUP BY `sr_item_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_customer_sk` IS NOT NULL
    GROUP BY `sr_customer_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_cdemo_sk` IS NOT NULL
    GROUP BY `sr_cdemo_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_hdemo_sk` IS NOT NULL
    GROUP BY `sr_hdemo_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_addr_sk` IS NOT NULL
    GROUP BY `sr_addr_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_store_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_store_sk` IS NOT NULL
    GROUP BY `sr_store_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_store_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `sr_reason_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_reason_sk` IS NOT NULL
    GROUP BY `sr_reason_sk`
)
SELECT 'store_returns' AS child_table,
       'sr_reason_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_sold_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_sold_date_sk` IS NOT NULL
    GROUP BY `cs_sold_date_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_sold_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_sold_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_sold_time_sk` IS NOT NULL
    GROUP BY `cs_sold_time_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_sold_time_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_ship_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_date_sk` IS NOT NULL
    GROUP BY `cs_ship_date_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_bill_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_customer_sk` IS NOT NULL
    GROUP BY `cs_bill_customer_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_bill_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_cdemo_sk` IS NOT NULL
    GROUP BY `cs_bill_cdemo_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_bill_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_hdemo_sk` IS NOT NULL
    GROUP BY `cs_bill_hdemo_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_bill_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_addr_sk` IS NOT NULL
    GROUP BY `cs_bill_addr_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_ship_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_customer_sk` IS NOT NULL
    GROUP BY `cs_ship_customer_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_ship_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_cdemo_sk` IS NOT NULL
    GROUP BY `cs_ship_cdemo_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_ship_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_hdemo_sk` IS NOT NULL
    GROUP BY `cs_ship_hdemo_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_ship_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_addr_sk` IS NOT NULL
    GROUP BY `cs_ship_addr_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_call_center_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_call_center_sk` IS NOT NULL
    GROUP BY `cs_call_center_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_call_center_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_catalog_page_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_catalog_page_sk` IS NOT NULL
    GROUP BY `cs_catalog_page_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_catalog_page_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_ship_mode_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_mode_sk` IS NOT NULL
    GROUP BY `cs_ship_mode_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_mode_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_warehouse_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_warehouse_sk` IS NOT NULL
    GROUP BY `cs_warehouse_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_warehouse_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_item_sk` IS NOT NULL
    GROUP BY `cs_item_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cs_promo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_promo_sk` IS NOT NULL
    GROUP BY `cs_promo_sk`
)
SELECT 'catalog_sales' AS child_table,
       'cs_promo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_returned_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returned_date_sk` IS NOT NULL
    GROUP BY `cr_returned_date_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_returned_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_returned_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returned_time_sk` IS NOT NULL
    GROUP BY `cr_returned_time_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_returned_time_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_item_sk` IS NOT NULL
    GROUP BY `cr_item_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_refunded_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_refunded_customer_sk` IS NOT NULL
    GROUP BY `cr_refunded_customer_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_refunded_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_refunded_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_refunded_cdemo_sk` IS NOT NULL
    GROUP BY `cr_refunded_cdemo_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_refunded_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_refunded_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_refunded_hdemo_sk` IS NOT NULL
    GROUP BY `cr_refunded_hdemo_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_refunded_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_refunded_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_refunded_addr_sk` IS NOT NULL
    GROUP BY `cr_refunded_addr_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_refunded_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_returning_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returning_customer_sk` IS NOT NULL
    GROUP BY `cr_returning_customer_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_returning_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_returning_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returning_cdemo_sk` IS NOT NULL
    GROUP BY `cr_returning_cdemo_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_returning_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_returning_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returning_hdemo_sk` IS NOT NULL
    GROUP BY `cr_returning_hdemo_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_returning_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_returning_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returning_addr_sk` IS NOT NULL
    GROUP BY `cr_returning_addr_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_returning_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_call_center_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_call_center_sk` IS NOT NULL
    GROUP BY `cr_call_center_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_call_center_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_catalog_page_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_catalog_page_sk` IS NOT NULL
    GROUP BY `cr_catalog_page_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_catalog_page_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_ship_mode_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_ship_mode_sk` IS NOT NULL
    GROUP BY `cr_ship_mode_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_ship_mode_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_warehouse_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_warehouse_sk` IS NOT NULL
    GROUP BY `cr_warehouse_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_warehouse_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `cr_reason_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_reason_sk` IS NOT NULL
    GROUP BY `cr_reason_sk`
)
SELECT 'catalog_returns' AS child_table,
       'cr_reason_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_sold_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_sold_date_sk` IS NOT NULL
    GROUP BY `ws_sold_date_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_sold_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_sold_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_sold_time_sk` IS NOT NULL
    GROUP BY `ws_sold_time_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_sold_time_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_ship_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_ship_date_sk` IS NOT NULL
    GROUP BY `ws_ship_date_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_ship_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_item_sk` IS NOT NULL
    GROUP BY `ws_item_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_bill_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_bill_customer_sk` IS NOT NULL
    GROUP BY `ws_bill_customer_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_bill_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_bill_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_bill_cdemo_sk` IS NOT NULL
    GROUP BY `ws_bill_cdemo_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_bill_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_bill_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_bill_hdemo_sk` IS NOT NULL
    GROUP BY `ws_bill_hdemo_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_bill_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_bill_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_bill_addr_sk` IS NOT NULL
    GROUP BY `ws_bill_addr_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_bill_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_ship_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_ship_customer_sk` IS NOT NULL
    GROUP BY `ws_ship_customer_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_ship_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_ship_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_ship_cdemo_sk` IS NOT NULL
    GROUP BY `ws_ship_cdemo_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_ship_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_ship_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_ship_hdemo_sk` IS NOT NULL
    GROUP BY `ws_ship_hdemo_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_ship_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_ship_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_ship_addr_sk` IS NOT NULL
    GROUP BY `ws_ship_addr_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_ship_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_web_page_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_web_page_sk` IS NOT NULL
    GROUP BY `ws_web_page_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_web_page_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_web_site_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_web_site_sk` IS NOT NULL
    GROUP BY `ws_web_site_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_web_site_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_ship_mode_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_ship_mode_sk` IS NOT NULL
    GROUP BY `ws_ship_mode_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_ship_mode_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_warehouse_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_warehouse_sk` IS NOT NULL
    GROUP BY `ws_warehouse_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_warehouse_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `ws_promo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_sales`
    WHERE `ws_promo_sk` IS NOT NULL
    GROUP BY `ws_promo_sk`
)
SELECT 'web_sales' AS child_table,
       'ws_promo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_returned_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_returned_date_sk` IS NOT NULL
    GROUP BY `wr_returned_date_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_returned_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_returned_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_returned_time_sk` IS NOT NULL
    GROUP BY `wr_returned_time_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_returned_time_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_item_sk` IS NOT NULL
    GROUP BY `wr_item_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_refunded_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_refunded_customer_sk` IS NOT NULL
    GROUP BY `wr_refunded_customer_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_refunded_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_refunded_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_refunded_cdemo_sk` IS NOT NULL
    GROUP BY `wr_refunded_cdemo_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_refunded_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_refunded_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_refunded_hdemo_sk` IS NOT NULL
    GROUP BY `wr_refunded_hdemo_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_refunded_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_refunded_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_refunded_addr_sk` IS NOT NULL
    GROUP BY `wr_refunded_addr_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_refunded_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_returning_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_returning_customer_sk` IS NOT NULL
    GROUP BY `wr_returning_customer_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_returning_customer_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_returning_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_returning_cdemo_sk` IS NOT NULL
    GROUP BY `wr_returning_cdemo_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_returning_cdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_returning_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_returning_hdemo_sk` IS NOT NULL
    GROUP BY `wr_returning_hdemo_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_returning_hdemo_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_returning_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_returning_addr_sk` IS NOT NULL
    GROUP BY `wr_returning_addr_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_returning_addr_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_web_page_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_web_page_sk` IS NOT NULL
    GROUP BY `wr_web_page_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_web_page_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `wr_reason_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_returns`
    WHERE `wr_reason_sk` IS NOT NULL
    GROUP BY `wr_reason_sk`
)
SELECT 'web_returns' AS child_table,
       'wr_reason_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `inv_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`inventory`
    WHERE `inv_date_sk` IS NOT NULL
    GROUP BY `inv_date_sk`
)
SELECT 'inventory' AS child_table,
       'inv_date_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `inv_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`inventory`
    WHERE `inv_item_sk` IS NOT NULL
    GROUP BY `inv_item_sk`
)
SELECT 'inventory' AS child_table,
       'inv_item_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

WITH freq AS (
    SELECT `inv_warehouse_sk`, COUNT(*) AS cnt
    FROM `gen`.`inventory`
    WHERE `inv_warehouse_sk` IS NOT NULL
    GROUP BY `inv_warehouse_sk`
)
SELECT 'inventory' AS child_table,
       'inv_warehouse_sk' AS fk_column,
       COUNT(*) AS distinct_fk_values_present,
       MIN(cnt) AS min_freq,
       MAX(cnt) AS max_freq,
       AVG(cnt) AS avg_freq
FROM freq;

-- ============================================================
-- TPC-DS: 4) FK DISTRIBUTION VARIANCE VS SOURCE
-- ============================================================

WITH src_freq AS (
    SELECT `c_current_cdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`customer`
    WHERE `c_current_cdemo_sk` IS NOT NULL
    GROUP BY `c_current_cdemo_sk`
),
gen_freq AS (
    SELECT `c_current_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_current_cdemo_sk` IS NOT NULL
    GROUP BY `c_current_cdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'customer' AS child_table,
       'c_current_cdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `c_current_hdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`customer`
    WHERE `c_current_hdemo_sk` IS NOT NULL
    GROUP BY `c_current_hdemo_sk`
),
gen_freq AS (
    SELECT `c_current_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_current_hdemo_sk` IS NOT NULL
    GROUP BY `c_current_hdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'customer' AS child_table,
       'c_current_hdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `c_current_addr_sk`, COUNT(*) AS cnt
    FROM `src`.`customer`
    WHERE `c_current_addr_sk` IS NOT NULL
    GROUP BY `c_current_addr_sk`
),
gen_freq AS (
    SELECT `c_current_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_current_addr_sk` IS NOT NULL
    GROUP BY `c_current_addr_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'customer' AS child_table,
       'c_current_addr_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `c_first_shipto_date_sk`, COUNT(*) AS cnt
    FROM `src`.`customer`
    WHERE `c_first_shipto_date_sk` IS NOT NULL
    GROUP BY `c_first_shipto_date_sk`
),
gen_freq AS (
    SELECT `c_first_shipto_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_first_shipto_date_sk` IS NOT NULL
    GROUP BY `c_first_shipto_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'customer' AS child_table,
       'c_first_shipto_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `c_first_sales_date_sk`, COUNT(*) AS cnt
    FROM `src`.`customer`
    WHERE `c_first_sales_date_sk` IS NOT NULL
    GROUP BY `c_first_sales_date_sk`
),
gen_freq AS (
    SELECT `c_first_sales_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`customer`
    WHERE `c_first_sales_date_sk` IS NOT NULL
    GROUP BY `c_first_sales_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'customer' AS child_table,
       'c_first_sales_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `hd_income_band_sk`, COUNT(*) AS cnt
    FROM `src`.`household_demographics`
    WHERE `hd_income_band_sk` IS NOT NULL
    GROUP BY `hd_income_band_sk`
),
gen_freq AS (
    SELECT `hd_income_band_sk`, COUNT(*) AS cnt
    FROM `gen`.`household_demographics`
    WHERE `hd_income_band_sk` IS NOT NULL
    GROUP BY `hd_income_band_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'household_demographics' AS child_table,
       'hd_income_band_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `p_start_date_sk`, COUNT(*) AS cnt
    FROM `src`.`promotion`
    WHERE `p_start_date_sk` IS NOT NULL
    GROUP BY `p_start_date_sk`
),
gen_freq AS (
    SELECT `p_start_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`promotion`
    WHERE `p_start_date_sk` IS NOT NULL
    GROUP BY `p_start_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'promotion' AS child_table,
       'p_start_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `p_end_date_sk`, COUNT(*) AS cnt
    FROM `src`.`promotion`
    WHERE `p_end_date_sk` IS NOT NULL
    GROUP BY `p_end_date_sk`
),
gen_freq AS (
    SELECT `p_end_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`promotion`
    WHERE `p_end_date_sk` IS NOT NULL
    GROUP BY `p_end_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'promotion' AS child_table,
       'p_end_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `p_item_sk`, COUNT(*) AS cnt
    FROM `src`.`promotion`
    WHERE `p_item_sk` IS NOT NULL
    GROUP BY `p_item_sk`
),
gen_freq AS (
    SELECT `p_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`promotion`
    WHERE `p_item_sk` IS NOT NULL
    GROUP BY `p_item_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'promotion' AS child_table,
       'p_item_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `web_open_date_sk`, COUNT(*) AS cnt
    FROM `src`.`web_site`
    WHERE `web_open_date_sk` IS NOT NULL
    GROUP BY `web_open_date_sk`
),
gen_freq AS (
    SELECT `web_open_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_site`
    WHERE `web_open_date_sk` IS NOT NULL
    GROUP BY `web_open_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'web_site' AS child_table,
       'web_open_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `web_close_date_sk`, COUNT(*) AS cnt
    FROM `src`.`web_site`
    WHERE `web_close_date_sk` IS NOT NULL
    GROUP BY `web_close_date_sk`
),
gen_freq AS (
    SELECT `web_close_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_site`
    WHERE `web_close_date_sk` IS NOT NULL
    GROUP BY `web_close_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'web_site' AS child_table,
       'web_close_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `wp_creation_date_sk`, COUNT(*) AS cnt
    FROM `src`.`web_page`
    WHERE `wp_creation_date_sk` IS NOT NULL
    GROUP BY `wp_creation_date_sk`
),
gen_freq AS (
    SELECT `wp_creation_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_page`
    WHERE `wp_creation_date_sk` IS NOT NULL
    GROUP BY `wp_creation_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'web_page' AS child_table,
       'wp_creation_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `wp_access_date_sk`, COUNT(*) AS cnt
    FROM `src`.`web_page`
    WHERE `wp_access_date_sk` IS NOT NULL
    GROUP BY `wp_access_date_sk`
),
gen_freq AS (
    SELECT `wp_access_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_page`
    WHERE `wp_access_date_sk` IS NOT NULL
    GROUP BY `wp_access_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'web_page' AS child_table,
       'wp_access_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `wp_customer_sk`, COUNT(*) AS cnt
    FROM `src`.`web_page`
    WHERE `wp_customer_sk` IS NOT NULL
    GROUP BY `wp_customer_sk`
),
gen_freq AS (
    SELECT `wp_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`web_page`
    WHERE `wp_customer_sk` IS NOT NULL
    GROUP BY `wp_customer_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'web_page' AS child_table,
       'wp_customer_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cp_start_date_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_page`
    WHERE `cp_start_date_sk` IS NOT NULL
    GROUP BY `cp_start_date_sk`
),
gen_freq AS (
    SELECT `cp_start_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_page`
    WHERE `cp_start_date_sk` IS NOT NULL
    GROUP BY `cp_start_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_page' AS child_table,
       'cp_start_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cp_end_date_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_page`
    WHERE `cp_end_date_sk` IS NOT NULL
    GROUP BY `cp_end_date_sk`
),
gen_freq AS (
    SELECT `cp_end_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_page`
    WHERE `cp_end_date_sk` IS NOT NULL
    GROUP BY `cp_end_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_page' AS child_table,
       'cp_end_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cc_open_date_sk`, COUNT(*) AS cnt
    FROM `src`.`call_center`
    WHERE `cc_open_date_sk` IS NOT NULL
    GROUP BY `cc_open_date_sk`
),
gen_freq AS (
    SELECT `cc_open_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`call_center`
    WHERE `cc_open_date_sk` IS NOT NULL
    GROUP BY `cc_open_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'call_center' AS child_table,
       'cc_open_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cc_closed_date_sk`, COUNT(*) AS cnt
    FROM `src`.`call_center`
    WHERE `cc_closed_date_sk` IS NOT NULL
    GROUP BY `cc_closed_date_sk`
),
gen_freq AS (
    SELECT `cc_closed_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`call_center`
    WHERE `cc_closed_date_sk` IS NOT NULL
    GROUP BY `cc_closed_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'call_center' AS child_table,
       'cc_closed_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_sold_date_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_sold_date_sk` IS NOT NULL
    GROUP BY `ss_sold_date_sk`
),
gen_freq AS (
    SELECT `ss_sold_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_sold_date_sk` IS NOT NULL
    GROUP BY `ss_sold_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_sold_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_sold_time_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_sold_time_sk` IS NOT NULL
    GROUP BY `ss_sold_time_sk`
),
gen_freq AS (
    SELECT `ss_sold_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_sold_time_sk` IS NOT NULL
    GROUP BY `ss_sold_time_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_sold_time_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_item_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_item_sk` IS NOT NULL
    GROUP BY `ss_item_sk`
),
gen_freq AS (
    SELECT `ss_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_item_sk` IS NOT NULL
    GROUP BY `ss_item_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_item_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_customer_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_customer_sk` IS NOT NULL
    GROUP BY `ss_customer_sk`
),
gen_freq AS (
    SELECT `ss_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_customer_sk` IS NOT NULL
    GROUP BY `ss_customer_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_customer_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_cdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_cdemo_sk` IS NOT NULL
    GROUP BY `ss_cdemo_sk`
),
gen_freq AS (
    SELECT `ss_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_cdemo_sk` IS NOT NULL
    GROUP BY `ss_cdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_cdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_hdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_hdemo_sk` IS NOT NULL
    GROUP BY `ss_hdemo_sk`
),
gen_freq AS (
    SELECT `ss_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_hdemo_sk` IS NOT NULL
    GROUP BY `ss_hdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_hdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_addr_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_addr_sk` IS NOT NULL
    GROUP BY `ss_addr_sk`
),
gen_freq AS (
    SELECT `ss_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_addr_sk` IS NOT NULL
    GROUP BY `ss_addr_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_addr_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_store_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_store_sk` IS NOT NULL
    GROUP BY `ss_store_sk`
),
gen_freq AS (
    SELECT `ss_store_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_store_sk` IS NOT NULL
    GROUP BY `ss_store_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_store_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `ss_promo_sk`, COUNT(*) AS cnt
    FROM `src`.`store_sales`
    WHERE `ss_promo_sk` IS NOT NULL
    GROUP BY `ss_promo_sk`
),
gen_freq AS (
    SELECT `ss_promo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_sales`
    WHERE `ss_promo_sk` IS NOT NULL
    GROUP BY `ss_promo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_sales' AS child_table,
       'ss_promo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_returned_date_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_returned_date_sk` IS NOT NULL
    GROUP BY `sr_returned_date_sk`
),
gen_freq AS (
    SELECT `sr_returned_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_returned_date_sk` IS NOT NULL
    GROUP BY `sr_returned_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_returned_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_return_time_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_return_time_sk` IS NOT NULL
    GROUP BY `sr_return_time_sk`
),
gen_freq AS (
    SELECT `sr_return_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_return_time_sk` IS NOT NULL
    GROUP BY `sr_return_time_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_return_time_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_item_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_item_sk` IS NOT NULL
    GROUP BY `sr_item_sk`
),
gen_freq AS (
    SELECT `sr_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_item_sk` IS NOT NULL
    GROUP BY `sr_item_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_item_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_customer_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_customer_sk` IS NOT NULL
    GROUP BY `sr_customer_sk`
),
gen_freq AS (
    SELECT `sr_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_customer_sk` IS NOT NULL
    GROUP BY `sr_customer_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_customer_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_cdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_cdemo_sk` IS NOT NULL
    GROUP BY `sr_cdemo_sk`
),
gen_freq AS (
    SELECT `sr_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_cdemo_sk` IS NOT NULL
    GROUP BY `sr_cdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_cdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_hdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_hdemo_sk` IS NOT NULL
    GROUP BY `sr_hdemo_sk`
),
gen_freq AS (
    SELECT `sr_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_hdemo_sk` IS NOT NULL
    GROUP BY `sr_hdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_hdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_addr_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_addr_sk` IS NOT NULL
    GROUP BY `sr_addr_sk`
),
gen_freq AS (
    SELECT `sr_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_addr_sk` IS NOT NULL
    GROUP BY `sr_addr_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_addr_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_store_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_store_sk` IS NOT NULL
    GROUP BY `sr_store_sk`
),
gen_freq AS (
    SELECT `sr_store_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_store_sk` IS NOT NULL
    GROUP BY `sr_store_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_store_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `sr_reason_sk`, COUNT(*) AS cnt
    FROM `src`.`store_returns`
    WHERE `sr_reason_sk` IS NOT NULL
    GROUP BY `sr_reason_sk`
),
gen_freq AS (
    SELECT `sr_reason_sk`, COUNT(*) AS cnt
    FROM `gen`.`store_returns`
    WHERE `sr_reason_sk` IS NOT NULL
    GROUP BY `sr_reason_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'store_returns' AS child_table,
       'sr_reason_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_sold_date_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_sold_date_sk` IS NOT NULL
    GROUP BY `cs_sold_date_sk`
),
gen_freq AS (
    SELECT `cs_sold_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_sold_date_sk` IS NOT NULL
    GROUP BY `cs_sold_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_sold_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_sold_time_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_sold_time_sk` IS NOT NULL
    GROUP BY `cs_sold_time_sk`
),
gen_freq AS (
    SELECT `cs_sold_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_sold_time_sk` IS NOT NULL
    GROUP BY `cs_sold_time_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_sold_time_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_ship_date_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_ship_date_sk` IS NOT NULL
    GROUP BY `cs_ship_date_sk`
),
gen_freq AS (
    SELECT `cs_ship_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_date_sk` IS NOT NULL
    GROUP BY `cs_ship_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_bill_customer_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_bill_customer_sk` IS NOT NULL
    GROUP BY `cs_bill_customer_sk`
),
gen_freq AS (
    SELECT `cs_bill_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_customer_sk` IS NOT NULL
    GROUP BY `cs_bill_customer_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_customer_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_bill_cdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_bill_cdemo_sk` IS NOT NULL
    GROUP BY `cs_bill_cdemo_sk`
),
gen_freq AS (
    SELECT `cs_bill_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_cdemo_sk` IS NOT NULL
    GROUP BY `cs_bill_cdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_cdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_bill_hdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_bill_hdemo_sk` IS NOT NULL
    GROUP BY `cs_bill_hdemo_sk`
),
gen_freq AS (
    SELECT `cs_bill_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_hdemo_sk` IS NOT NULL
    GROUP BY `cs_bill_hdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_hdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_bill_addr_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_bill_addr_sk` IS NOT NULL
    GROUP BY `cs_bill_addr_sk`
),
gen_freq AS (
    SELECT `cs_bill_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_bill_addr_sk` IS NOT NULL
    GROUP BY `cs_bill_addr_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_bill_addr_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_ship_customer_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_ship_customer_sk` IS NOT NULL
    GROUP BY `cs_ship_customer_sk`
),
gen_freq AS (
    SELECT `cs_ship_customer_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_customer_sk` IS NOT NULL
    GROUP BY `cs_ship_customer_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_customer_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_ship_cdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_ship_cdemo_sk` IS NOT NULL
    GROUP BY `cs_ship_cdemo_sk`
),
gen_freq AS (
    SELECT `cs_ship_cdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_cdemo_sk` IS NOT NULL
    GROUP BY `cs_ship_cdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_cdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_ship_hdemo_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_ship_hdemo_sk` IS NOT NULL
    GROUP BY `cs_ship_hdemo_sk`
),
gen_freq AS (
    SELECT `cs_ship_hdemo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_hdemo_sk` IS NOT NULL
    GROUP BY `cs_ship_hdemo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_hdemo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_ship_addr_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_ship_addr_sk` IS NOT NULL
    GROUP BY `cs_ship_addr_sk`
),
gen_freq AS (
    SELECT `cs_ship_addr_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_addr_sk` IS NOT NULL
    GROUP BY `cs_ship_addr_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_addr_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_call_center_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_call_center_sk` IS NOT NULL
    GROUP BY `cs_call_center_sk`
),
gen_freq AS (
    SELECT `cs_call_center_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_call_center_sk` IS NOT NULL
    GROUP BY `cs_call_center_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_call_center_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_catalog_page_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_catalog_page_sk` IS NOT NULL
    GROUP BY `cs_catalog_page_sk`
),
gen_freq AS (
    SELECT `cs_catalog_page_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_catalog_page_sk` IS NOT NULL
    GROUP BY `cs_catalog_page_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_catalog_page_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_ship_mode_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_ship_mode_sk` IS NOT NULL
    GROUP BY `cs_ship_mode_sk`
),
gen_freq AS (
    SELECT `cs_ship_mode_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_ship_mode_sk` IS NOT NULL
    GROUP BY `cs_ship_mode_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_ship_mode_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_warehouse_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_warehouse_sk` IS NOT NULL
    GROUP BY `cs_warehouse_sk`
),
gen_freq AS (
    SELECT `cs_warehouse_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_warehouse_sk` IS NOT NULL
    GROUP BY `cs_warehouse_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_warehouse_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_item_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_item_sk` IS NOT NULL
    GROUP BY `cs_item_sk`
),
gen_freq AS (
    SELECT `cs_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_item_sk` IS NOT NULL
    GROUP BY `cs_item_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_item_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cs_promo_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_sales`
    WHERE `cs_promo_sk` IS NOT NULL
    GROUP BY `cs_promo_sk`
),
gen_freq AS (
    SELECT `cs_promo_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_sales`
    WHERE `cs_promo_sk` IS NOT NULL
    GROUP BY `cs_promo_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_sales' AS child_table,
       'cs_promo_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cr_returned_date_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_returns`
    WHERE `cr_returned_date_sk` IS NOT NULL
    GROUP BY `cr_returned_date_sk`
),
gen_freq AS (
    SELECT `cr_returned_date_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returned_date_sk` IS NOT NULL
    GROUP BY `cr_returned_date_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_returns' AS child_table,
       'cr_returned_date_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cr_returned_time_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_returns`
    WHERE `cr_returned_time_sk` IS NOT NULL
    GROUP BY `cr_returned_time_sk`
),
gen_freq AS (
    SELECT `cr_returned_time_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_returned_time_sk` IS NOT NULL
    GROUP BY `cr_returned_time_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_returns' AS child_table,
       'cr_returned_time_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0), 2)
       END AS max_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_avg_freq - src_avg_freq) / NULLIF(src_avg_freq, 0), 2)
       END AS avg_freq_pct_diff,
       CASE
         WHEN src_avg_freq = 0 THEN NULL
         ELSE ROUND(src_max_freq / NULLIF(src_avg_freq, 0), 4)
       END AS src_skew_ratio,
       CASE
         WHEN gen_avg_freq = 0 THEN NULL
         ELSE ROUND(gen_max_freq / NULLIF(gen_avg_freq, 0), 4)
       END AS gen_skew_ratio,
       CASE
         WHEN src_avg_freq = 0 OR gen_avg_freq = 0 THEN NULL
         ELSE ROUND(
           100.0 * (
             (gen_max_freq / NULLIF(gen_avg_freq, 0)) -
             (src_max_freq / NULLIF(src_avg_freq, 0))
           ) / NULLIF((src_max_freq / NULLIF(src_avg_freq, 0)), 0),
           2
         )
       END AS skew_ratio_pct_diff
FROM src_stats
CROSS JOIN gen_stats;

WITH src_freq AS (
    SELECT `cr_item_sk`, COUNT(*) AS cnt
    FROM `src`.`catalog_returns`
    WHERE `cr_item_sk` IS NOT NULL
    GROUP BY `cr_item_sk`
),
gen_freq AS (
    SELECT `cr_item_sk`, COUNT(*) AS cnt
    FROM `gen`.`catalog_returns`
    WHERE `cr_item_sk` IS NOT NULL
    GROUP BY `cr_item_sk`
),
src_stats AS (
    SELECT COUNT(*) AS src_distinct_fk_values,
           MIN(cnt) AS src_min_freq,
           MAX(cnt) AS src_max_freq,
           AVG(cnt) AS src_avg_freq
    FROM src_freq
),
gen_stats AS (
    SELECT COUNT(*) AS gen_distinct_fk_values,
           MIN(cnt) AS gen_min_freq,
           MAX(cnt) AS gen_max_freq,
           AVG(cnt) AS gen_avg_freq
    FROM gen_freq
)
SELECT 'catalog_returns' AS child_table,
       'cr_item_sk' AS fk_column,
       src_distinct_fk_values,
       gen_distinct_fk_values,
       src_min_freq,
       gen_min_freq,
       src_max_freq,
       gen_max_freq,
       src_avg_freq,
       gen_avg_freq,
       CASE
         WHEN src_min_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_min_freq - src_min_freq) / NULLIF(src_min_freq, 0), 2)
       END AS min_freq_pct_diff,
       CASE
         WHEN src_max_freq = 0 THEN NULL
         ELSE ROUND(100.0 * (gen_max_freq - src_max_freq) / NULLIF(src_max_freq, 0),
