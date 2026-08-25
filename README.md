# DataGenX

Generate synthetic database data that matches the **statistical properties** of a
source schema — histograms, distinct counts, cardinality — so query optimization
work can be done without access to the real data.

The generated data is blind to actual source values. Distribution *shapes* and
*counts* cross the boundary; values, MIN/MAX, and rows never do.

## Status

**Research prototype**, released alongside a TPCTC 2026 paper. It is a proof of
concept rather than a product: expect rough edges, sparse error handling, and
setup that assumes some familiarity with MySQL and benchmark toolkits.

Development and testing target **MySQL 8**. TiDB and SingleStore backends exist
and are less exercised. Interfaces may change without notice, and there is no
support commitment.

## Layout

| Path | Language | Purpose |
|------|----------|---------|
| `engine/` | Rust | Generation engine; consumes `.dbgen` templates |
| `src/datagenx/` | Python | Schema extraction, template generation, orchestration, validation |
| `scripts/` | Python, shell | Environment check, TPC-H kit fetch, source-schema setup |
| `tests/` | | Unit tests, fixtures, and cloud/TiDB harnesses |

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Rust | ≥ 1.85 | The engine uses edition 2024 |
| Python | ≥ 3.10 | |
| MySQL | 8.0+ | Needs histogram support (`ANALYZE TABLE ... UPDATE HISTOGRAM`) |
| TPC-H kit | — | Only to build a benchmark *source* schema; see below |

Check what your machine has:

```bash
scripts/check_env.sh
```

The official TPC-H kit generates the source data whose statistics DataGenX
reads. It is not redistributed here — it carries its own TPC licence — so fetch
and build it locally:

```bash
scripts/fetch_tpch_kit.sh
```

That clones and builds it at `../tpch/tpch-dbgen`, where the code looks by
default. To put it elsewhere, pass a path and export `TPCH_DBGEN_DIR`.

Note that the kit's binary is called `dbgen` and is an entirely different
program from this repository's `datagenx-engine`.

## Quickstart

Requires Rust ≥ 1.85 (edition 2024), Python ≥ 3.10, and a reachable MySQL.

```bash
cargo build --release                       # -> target/release/datagenx-engine
python3 -m venv .venv && ./.venv/bin/pip install -e ".[dev]"
cp .env.example .env                        # then set DB_PASSWORD
./.venv/bin/python -m pytest
```

The engine binary is resolved relative to this repository; nothing needs to be
installed on PATH.

## End-to-end example: TPC-H at scale factor 0.5

Build a source schema with real data and full histograms, then generate and
validate a statistical replay of it:

```bash
./.venv/bin/python scripts/setup_tpch_schema.py -s 0.5 --schema-name tpch_sf0_5

./.venv/bin/python -m datagenx.orchestration.MasterRun \
    --source-schema tpch_sf0_5 \
    --target-schema tpch_sf0_5_dbgenx \
    --run-validation --compare-histograms
```

Setup takes about a minute at this scale and the generation run about four,
ending in a per-table summary of DDL, row count, histogram, and distinct-count
agreement. Fractional scale factors are supported; schema labels render `0.5` as
`0_5`.

## Configuration

Settings come from the environment or a `.env` file at the repository root
(gitignored). See `.env.example`. There is no default password: set
`DB_PASSWORD`, or connections fail with an explanation.

## Terminology

- **orig** — source data with real distributions
- **replay** — generated data that should match orig's statistics
- **diverged** — replay statistics differ beyond threshold (typically 5%)

## Citing this work

See [CITATION.cff](CITATION.cff), or use GitHub's "Cite this repository" button.

## License

MIT. The engine is a hard fork of [kennytm/dbgen](https://github.com/kennytm/dbgen);
see [NOTICE](NOTICE) for provenance and the fork point, and [LICENSE](LICENSE)
for the retained original copyright.
