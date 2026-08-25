#!/usr/bin/env bash
#
# Fetch and build the official TPC-H kit (dbgen), which generates the *source*
# data DataGenX reads statistics from. The kit is not redistributed here: it
# carries its own TPC licence, so it is cloned from upstream on your machine.
#
# The kit's `dbgen` is an unrelated program to this repository's
# `datagenx-engine`, despite the shared history of the name.
#
# Usage:
#   scripts/fetch_tpch_kit.sh [target-directory]
#
# Defaults to ../tpch/tpch-dbgen relative to the repository root, which is
# where config.TPCH_DBGEN_DIR looks unless TPCH_DBGEN_DIR is set.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-${TPCH_DBGEN_DIR:-$(dirname "$REPO_ROOT")/tpch/tpch-dbgen}}"
UPSTREAM="https://github.com/electrum/tpch-dbgen.git"

case "$(uname -s)" in
    Darwin) MACHINE=MAC ;;
    Linux)  MACHINE=LINUX ;;
    *)      echo "Unsupported platform: $(uname -s). Build the kit manually." >&2
            exit 1 ;;
esac

if [[ -x "$TARGET/dbgen" && -f "$TARGET/dists.dss" ]]; then
    echo "TPC-H kit already built at $TARGET"
    exit 0
fi

if [[ ! -d "$TARGET/.git" ]]; then
    echo "Cloning TPC-H kit into $TARGET"
    mkdir -p "$(dirname "$TARGET")"
    git clone --depth 1 "$UPSTREAM" "$TARGET"
fi

echo "Building dbgen (MACHINE=$MACHINE)"
make -C "$TARGET" MACHINE="$MACHINE" DATABASE=ORACLE WORKLOAD=TPCH

if [[ ! -x "$TARGET/dbgen" || ! -f "$TARGET/dists.dss" ]]; then
    echo "Build finished but dbgen or dists.dss is missing in $TARGET" >&2
    exit 1
fi

echo
echo "TPC-H kit ready: $TARGET"
if [[ "$TARGET" != "$(dirname "$REPO_ROOT")/tpch/tpch-dbgen" ]]; then
    echo "This is not the default location. Export it before running DataGenX:"
    echo "    export TPCH_DBGEN_DIR=$TARGET"
fi
