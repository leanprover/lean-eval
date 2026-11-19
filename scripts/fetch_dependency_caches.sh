#!/usr/bin/env bash
# Usage: bash scripts/fetch_dependency_caches.sh [--restore] <project-dir>
# Dependencies must already be checked out (e.g. by `lake exe cache get`).
# --restore downloads imported library modules and their dependencies with
# `lake --no-build`, refusing to compile on a cache miss. Without --restore,
# fetch only revision mappings. See README.md for supported public libraries.
#
# In GitHub Actions, settings are appended to GITHUB_ENV. Otherwise stdout is
# one shell export line, suitable for:
# cache_env="$(bash scripts/fetch_dependency_caches.sh --restore .)" && eval "$cache_env"
set -euo pipefail
exec python3 "$(dirname "${BASH_SOURCE[0]}")/fetch_dependency_caches.py" "$@"
