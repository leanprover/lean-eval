# PLAN

This file tracks problem-set work that should be designed carefully
rather than improvised.

The submission pipeline now lives in
[`leanprover/lean-eval-submissions`](https://github.com/leanprover/lean-eval-submissions);
roadmap items for it belong there. External version pins are done and
their bump procedure is documented in [`SECURITY.md`](SECURITY.md) §5.

## Problem curation

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
