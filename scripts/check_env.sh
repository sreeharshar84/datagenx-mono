#!/usr/bin/env bash
#
# Report whether this machine has what DataGenX needs. Checks only; changes
# nothing. Exits non-zero if a required component is missing.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
missing=0

ok()   { printf '  \033[32m ok \033[0m %s\n' "$1"; }
bad()  { printf '  \033[31mmiss\033[0m %s\n' "$1"; missing=1; }
note() { printf '  \033[33mnote\033[0m %s\n' "$1"; }

echo "DataGenX environment check"
echo

# Rust >= 1.85 (the engine uses edition 2024)
if command -v cargo >/dev/null 2>&1; then
    v=$(cargo --version | awk '{print $2}')
    if [ "$(printf '%s\n1.85.0\n' "$v" | sort -V | head -1)" = "1.85.0" ]; then
        ok "cargo $v (needs >= 1.85)"
    else
        bad "cargo $v is too old; the engine needs >= 1.85 for edition 2024"
    fi
else
    bad "cargo not found; install Rust from https://rustup.rs"
fi

# Python >= 3.10
if command -v python3 >/dev/null 2>&1; then
    v=$(python3 -c 'import sys; print("%d.%d" % sys.version_info[:2])')
    if [ "$(printf '%s\n3.10\n' "$v" | sort -V | head -1)" = "3.10" ]; then
        ok "python3 $v (needs >= 3.10)"
    else
        bad "python3 $v is too old; needs >= 3.10"
    fi
else
    bad "python3 not found"
fi

# The engine itself
if [ -x "$REPO_ROOT/target/release/datagenx-engine" ]; then
    ok "engine built: target/release/datagenx-engine"
else
    note "engine not built yet; run: cargo build --release"
fi

# MySQL client and server reachability
if command -v mysql >/dev/null 2>&1; then
    ok "mysql client present"
else
    bad "mysql client not found"
fi

if [ -f "$REPO_ROOT/.env" ]; then
    ok ".env present"
else
    note "no .env; copy .env.example and set DB_PASSWORD"
fi

# TPC-H kit, needed only to build a benchmark source schema
KIT="${TPCH_DBGEN_DIR:-$(dirname "$REPO_ROOT")/tpch/tpch-dbgen}"
if [ -x "$KIT/dbgen" ] && [ -f "$KIT/dists.dss" ]; then
    ok "TPC-H kit: $KIT"
else
    note "TPC-H kit not found at $KIT; run: scripts/fetch_tpch_kit.sh"
fi

echo
if [ "$missing" -ne 0 ]; then
    echo "Some required components are missing (see 'miss' above)."
    exit 1
fi
echo "Required components present."
