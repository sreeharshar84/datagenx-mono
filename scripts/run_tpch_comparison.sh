#!/bin/bash

# run_tpch_comparison.sh
# Runs all TPC-H queries on both tpch and tpch_harsha schemas
# Records and compares row counts and execution times

QUERIES_DIR="/Users/sreeharshar/work/db/datagenx/tpch/tpch-dbgen/queries_mysql"
OUTPUT_FILE="/Users/sreeharshar/work/db/datagenx/tpch/tpch-dbgen/comparison_results.txt"

MYSQL_USER="root"
MYSQL_PASSWORD="newpassword"
MYSQL_HOST="localhost"

SOURCE_SCHEMA="tpch"
TARGET_SCHEMA="tpch_harsha"

TEMP_QUERY="/tmp/tpch_query_$$.sql"

# Clear output file
> "$OUTPUT_FILE"

echo "TPC-H Query Comparison: $SOURCE_SCHEMA vs $TARGET_SCHEMA" | tee -a "$OUTPUT_FILE"
echo "============================================================" | tee -a "$OUTPUT_FILE"
echo "Started at: $(date)" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

printf "%-8s | %-12s | %-15s | %-12s | %-15s | %-10s | %-10s\n" "Query" "Rows($SOURCE_SCHEMA)" "Rows($TARGET_SCHEMA)" "Time($SOURCE_SCHEMA)" "Time($TARGET_SCHEMA)" "RowMatch" "TimeMatch" | tee -a "$OUTPUT_FILE"
printf "%s\n" "---------|--------------|-----------------|--------------|-----------------|------------|------------" | tee -a "$OUTPUT_FILE"

total_source_time=0
total_target_time=0
row_matches=0
row_mismatches=0
time_matches=0
time_mismatches=0

for query_file in "$QUERIES_DIR"/*.sql; do
    filename=$(basename "$query_file")
    query_num="${filename%_mysql.sql}"

    # Run on source schema using temp file
    echo "USE $SOURCE_SCHEMA;" > "$TEMP_QUERY"
    cat "$query_file" >> "$TEMP_QUERY"

    start_time=$(date +%s.%N)
    source_result=$(mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -N < "$TEMP_QUERY" 2>/dev/null)
    end_time=$(date +%s.%N)
    source_rows=$(echo "$source_result" | grep -c .)
    source_time=$(echo "$end_time - $start_time" | bc)

    # Run on target schema using temp file
    echo "USE $TARGET_SCHEMA;" > "$TEMP_QUERY"
    cat "$query_file" >> "$TEMP_QUERY"

    start_time=$(date +%s.%N)
    target_result=$(mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -N < "$TEMP_QUERY" 2>/dev/null)
    end_time=$(date +%s.%N)
    target_rows=$(echo "$target_result" | grep -c .)
    target_time=$(echo "$end_time - $start_time" | bc)

    # Check if row counts are within 20% threshold
    if [[ "$source_rows" -eq 0 && "$target_rows" -eq 0 ]]; then
        row_diff_pct=0
    elif [[ "$source_rows" -eq 0 || "$target_rows" -eq 0 ]]; then
        row_diff_pct=100
    else
        max_rows=$(( source_rows > target_rows ? source_rows : target_rows ))
        row_diff=$(( source_rows > target_rows ? source_rows - target_rows : target_rows - source_rows ))
        row_diff_pct=$(echo "scale=2; $row_diff * 100 / $max_rows" | bc)
    fi

    if (( $(echo "$row_diff_pct <= 20" | bc -l) )); then
        row_match="YES"
        ((row_matches++))
    else
        row_match="NO"
        ((row_mismatches++))
    fi

    # Check if timing is within 20% threshold
    max_time=$(echo "if ($source_time > $target_time) $source_time else $target_time" | bc)
    if (( $(echo "$max_time == 0" | bc -l) )); then
        time_diff_pct=0
    else
        time_diff=$(echo "if ($source_time > $target_time) $source_time - $target_time else $target_time - $source_time" | bc)
        time_diff_pct=$(echo "scale=2; $time_diff * 100 / $max_time" | bc)
    fi

    if (( $(echo "$time_diff_pct <= 20" | bc -l) )); then
        time_match="YES"
        ((time_matches++))
    else
        time_match="NO"
        ((time_mismatches++))
    fi

    # Accumulate total times
    total_source_time=$(echo "$total_source_time + $source_time" | bc)
    total_target_time=$(echo "$total_target_time + $target_time" | bc)

    printf "%-8s | %12s | %15s | %12.3fs | %15.3fs | %-10s | %-10s\n" "Q$query_num" "$source_rows" "$target_rows" "$source_time" "$target_time" "$row_match" "$time_match" | tee -a "$OUTPUT_FILE"
done

# Cleanup
rm -f "$TEMP_QUERY"

echo "" | tee -a "$OUTPUT_FILE"
echo "============================================================" | tee -a "$OUTPUT_FILE"
echo "SUMMARY" | tee -a "$OUTPUT_FILE"
echo "============================================================" | tee -a "$OUTPUT_FILE"
echo "Total queries:      22" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Row count matches:  $row_matches" | tee -a "$OUTPUT_FILE"
echo "Row count differs:  $row_mismatches" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Time matches:       $time_matches" | tee -a "$OUTPUT_FILE"
echo "Time differs:       $time_mismatches" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
printf "Total time (%s):       %.3fs\n" "$SOURCE_SCHEMA" "$total_source_time" | tee -a "$OUTPUT_FILE"
printf "Total time (%s): %.3fs\n" "$TARGET_SCHEMA" "$total_target_time" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Finished at: $(date)" | tee -a "$OUTPUT_FILE"
echo "Results saved to: $OUTPUT_FILE"
