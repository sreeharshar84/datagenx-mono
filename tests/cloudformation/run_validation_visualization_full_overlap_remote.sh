#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 s3://code-archive.tgz s3://result-prefix/" >&2
    exit 2
fi

CODE_ARCHIVE_URI="$1"
RESULTS_URI="${2%/}/"
WORK_DIR="${WORK_DIR:-/opt/datagenx-run}"
ENV_FILE="${TIDB_ENV_FILE:-$WORK_DIR/tidb-cloud.env}"
CODE_DIR="$WORK_DIR/work/datagenx_visualization_full_overlap"
RESULTS_DIR="$WORK_DIR/results/visualization-full-overlap"
LOG_DIR="$WORK_DIR/logs"
DRIVER_LOG="$LOG_DIR/visualization_full_overlap_driver.log"

log() {
    printf '[%s] %s\n' "$(date -Is)" "$*" | tee -a "$DRIVER_LOG"
}

run_report() {
    local label="$1"
    local source_schema="$2"
    local target_schema="$3"
    local output_file="$4"
    local report_log="$5"

    log "Starting $label full-overlap report"
    python3 validation_report.py \
        --db-type tidb \
        --source-schema "$source_schema" \
        --target-schema "$target_schema" \
        --output "$output_file" \
        --tidb-mem-quota-query "${TIDB_MEM_QUOTA_QUERY:-68719476736}" \
        --overlap-chunk-rows "${OVERLAP_CHUNK_ROWS:-250000}" \
        --tidb-overlap-strategy "${TIDB_OVERLAP_STRATEGY:-mpp}" \
        > "$report_log" 2>&1
    log "Finished $label full-overlap report: $(ls -lh "$output_file" | awk '{print $5, $9}')"
    aws s3 sync "$RESULTS_DIR" "$RESULTS_URI"
}

mkdir -p "$WORK_DIR" "$LOG_DIR" "$RESULTS_DIR" "$WORK_DIR/work"
: > "$DRIVER_LOG"

if [[ ! -f "$ENV_FILE" ]]; then
    log "Missing TiDB env file: $ENV_FILE"
    exit 1
fi

log "Downloading code archive from $CODE_ARCHIVE_URI"
aws s3 cp "$CODE_ARCHIVE_URI" "$WORK_DIR/datagenx_visualization_full_overlap_code.tgz"

log "Preparing code directory $CODE_DIR"
rm -rf "$CODE_DIR"
mkdir -p "$CODE_DIR"
tar -xzf "$WORK_DIR/datagenx_visualization_full_overlap_code.tgz" -C "$CODE_DIR"

cd "$CODE_DIR"
log "Installing Python requirements"
python3 -m pip install --user -r requirements.txt >> "$DRIVER_LOG" 2>&1

set -a
source "$ENV_FILE"
set +a

export PYTHONUNBUFFERED=1

run_report \
    "TPC-H SF10 TiDB" \
    "test_tpch_sf10_source" \
    "test_tpch_sf10_datagenx" \
    "$RESULTS_DIR/tpch_sf10_tidb_validation_report.html" \
    "$LOG_DIR/tpch_sf10_visualization_full_overlap.log"

run_report \
    "TPC-DS SF10 TiDB" \
    "test_tpcds_sf10_source" \
    "test_tpcds_sf10_datagenx" \
    "$RESULTS_DIR/tpcds_sf10_tidb_validation_report.html" \
    "$LOG_DIR/tpcds_sf10_visualization_full_overlap.log"

log "Full-overlap visualization reports completed"
