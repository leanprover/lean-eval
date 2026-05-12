# PLAN

This file tracks the pieces that should be designed carefully rather than improvised.

## 1. Pin external versions

CI currently pulls several moving targets:

- `go install github.com/zouuup/landrun/cmd/landrun@main`
  (in both `ci.yml` and `submission.yml`)
- `jlumbroso/free-disk-space@main` (in `submission.yml`; `ci.yml` is on `@v1.3.1`)
- comparator and `lean4export` are not pinned to specific revisions

Pick concrete versions, pin them, and write down the upgrade procedure.

## 2. Native-Lean migration of lean-eval tooling

The leaderboard *site* is native Lean, and `lake exe lean-eval` is the
native entrypoint for the CLI surface (generate, run-eval,
check-eval-workflow, etc.). The remaining Python scripts only run inside
the submission pipeline and have no `lake exe lean-eval` wrapper:

- `scripts/evaluate_submission.py` — evaluation driver
- `scripts/update_leaderboard.py` — result writer
- `scripts/fetch_submission.py` — submission fetcher

Optional: migrate these too so the entire toolchain lives inside `lake`.

## 3. Problem curation

The repo currently ships ~33 workspaces across number theory, combinatorics,
topology, complex analysis, group theory, convex geometry, linear algebra,
algebraic geometry, differential geometry, and a couple of starter / hole
examples.

Open work:

- audit topic coverage and difficulty distribution (we are already past the
  original 15–25 problem target, so the question is which problems are
  carrying their weight)
- decide whether any problems are too easy or saturated by current frontier
  models and should be retired or replaced
- continue adding problems where we identify gaps
