# config.py - Central configuration for DataGenX Generator
#
# Values can be overridden from environment variables or from a repo-root .env
# file. Generic DB_* variables take precedence; engine-specific variables such
# as TIDB_* are accepted as convenient aliases.

import os
from pathlib import Path


try:
    from dotenv import load_dotenv
except ImportError:
    load_dotenv = None


# REPO_ROOT is defined below, but .env must load before any _env() call.
# src/datagenx/config.py -> src/datagenx -> src -> repository root.
if load_dotenv:
    load_dotenv(Path(__file__).resolve().parents[2] / ".env")


def _env(*names, default=None):
    for name in names:
        value = os.environ.get(name)
        if value is not None and value != "":
            return value
    return default


def _env_int(*names, default=None):
    value = _env(*names)
    if value is None:
        return default
    return int(value)


def _engine_env_names(suffix):
    prefixes_by_engine = {
        "mysql": ("MYSQL",),
        "singlestore": ("SINGLESTORE", "SINGLE_STORE"),
        "tidb": ("TIDB",),
    }
    return tuple(
        f"{prefix}_{suffix}"
        for prefix in prefixes_by_engine.get(DB_TYPE, ())
    )


_default_db_type = "mysql"
if _env("TIDB_HOST"):
    _default_db_type = "tidb"
elif _env("SINGLESTORE_HOST", "SINGLE_STORE_HOST"):
    _default_db_type = "singlestore"

# Database type (mysql, singlestore, or tidb)
DB_TYPE = _env("DB_TYPE", "DATAGENX_DB_TYPE", default=_default_db_type).lower()

# Database connection
HOST = _env(
    "DB_HOST",
    "DATAGENX_DB_HOST",
    *_engine_env_names("HOST"),
    default="localhost",
)
DB_PORT = _env_int(
    "DB_PORT",
    "DATAGENX_DB_PORT",
    *_engine_env_names("PORT"),
    default=None,
)
USER = _env(
    "DB_USER",
    "DB_USERNAME",
    "DATAGENX_DB_USER",
    *_engine_env_names("USER"),
    *_engine_env_names("USERNAME"),
    default="root",
)
# No default: a credential does not belong in source. Set DB_PASSWORD in the
# environment or in a .env file at the repository root (.env is gitignored).
PASSWORD = _env(
    "DB_PASSWORD",
    "DATAGENX_DB_PASSWORD",
    *_engine_env_names("PASSWORD"),
)


def require_password():
    """Return the configured password, or explain how to set one."""
    if PASSWORD is None:
        raise RuntimeError(
            "No database password configured. Set DB_PASSWORD in the "
            "environment, or create a .env file at the repository root "
            "containing DB_PASSWORD=<password>. See .env.example."
        )
    return PASSWORD

# Schema configuration. For TiDB, TIDB_DATABASE is treated as SOURCE_SCHEMA.
SOURCE_SCHEMA = _env(
    "SOURCE_SCHEMA",
    "DB_DATABASE",
    "DATAGENX_SOURCE_SCHEMA",
    *_engine_env_names("DATABASE"),
    default="tpch",
)
_default_target_schema = (
    "tpch_dbgenx"
    if SOURCE_SCHEMA in ("tpch", "tpch_vanilla")
    else f"{SOURCE_SCHEMA}_dbgenx"
)
TARGET_SCHEMA = _env(
    "TARGET_SCHEMA",
    "DB_TARGET_SCHEMA",
    "DATAGENX_TARGET_SCHEMA",
    default=_default_target_schema,
)

# Repository root: src/datagenx/config.py -> src/datagenx -> src -> root
REPO_ROOT = Path(__file__).resolve().parents[2]

# DBGEN_BINARY is the DataGenX engine built from engine/ in this repository.
# Named datagenx-engine specifically so it cannot be confused with the
# official TPC-H dbgen at TPCH_DBGEN_DIR, which is an unrelated program.
def _find_dbgen_binary():
    return str(REPO_ROOT / "target" / "release" / "datagenx-engine")

DBGEN_BINARY = os.path.expanduser(_env(
    "DBGEN_BINARY",
    "DATAGENX_DBGEN_BINARY",
    default=_find_dbgen_binary(),
))
# Location of the official TPC-H kit (dbgen, dists.dss, queries). This is a
# different program from the DataGenX engine above; the two only share a name.
TPCH_DBGEN_DIR = Path(_env(
    "TPCH_DBGEN_DIR",
    "DATAGENX_TPCH_DBGEN_DIR",
    default=str(REPO_ROOT.parent / "tpch" / "tpch-dbgen"),
)).expanduser()

# MySQL-dialect queries, and the original query templates shipped with the kit.
TPCH_QUERIES_DIR = Path(_env(
    "TPCH_QUERIES_DIR", "DATAGENX_TPCH_QUERIES_DIR",
    default=str(TPCH_DBGEN_DIR / "queries_mysql"),
)).expanduser()
TPCH_TEMPLATE_DIR = Path(_env(
    "TPCH_TEMPLATE_DIR", "DATAGENX_TPCH_TEMPLATE_DIR",
    default=str(TPCH_DBGEN_DIR / "queries"),
)).expanduser()

DBGEN_FILES_DIR = _env("DBGEN_FILES_DIR", "DATAGENX_DBGEN_FILES_DIR",
                       default="generated/dbgen_files")
DBGEN_TMP_OUT_DIR = _env("DBGEN_TMP_OUT_DIR", "DATAGENX_DBGEN_TMP_OUT_DIR",
                         default="generated/dbgen_tmp_out")

# FK DDL file path (for databases that don't expose FK metadata, e.g., SingleStore)
FK_DDL_FILE = _env("FK_DDL_FILE", "DATAGENX_FK_DDL_FILE", default=None)

# Generation settings
FILES_COUNT = _env("FILES_COUNT", "DATAGENX_FILES_COUNT", default="1")
ROWS_COUNT = _env("ROWS_COUNT", "DATAGENX_ROWS_COUNT", default="1000")
