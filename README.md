# DataGenX

Synthetic data generation and validation framework. Generates database data
that matches the *statistical properties* (histograms, distinct counts,
cardinality) of a source schema without ever copying source data values.

This repository contains both halves of the system:

| Path | Language | Purpose |
|------|----------|---------|
| `engine/` | Rust | Data generation engine; consumes `.dbgen` templates |
| `src/datagenx/` | Python | Schema extraction, template generation, orchestration, validation |

## Status

Migration in progress. See `docs/` for design notes.

## License

MIT. The engine is derived from [kennytm/dbgen](https://github.com/kennytm/dbgen);
see [NOTICE](NOTICE) for attribution and the fork point.
