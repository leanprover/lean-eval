# `hadwiger`

Hadwiger's theorem

- Problem ID: `hadwiger`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §31 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. The real vector space of continuous, rigid-motion-invariant valuations on convex bodies in ℝⁿ has dimension n + 1. The problem defines the IsValuation predicate (continuity in the Hausdorff metric, inclusion-exclusion additivity, invariance under linear isometries and translations) and the valuations submodule. mathlib has ConvexBody with its Hausdorff MetricSpace but no valuations, intrinsic volumes, or Hadwiger's theorem; no formalization was found in any other proof assistant. The Submodule membership-closure fields of `valuations` are shipped as sorry (routine: valuations are closed under sum and scalar multiple).
- Source: H. Hadwiger (1937). Listed as §31 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Hadwiger's classification: every continuous rigid-motion-invariant valuation on convex bodies in ℝⁿ is a linear combination of the n + 1 intrinsic volumes V₀, …, Vₙ (equivalently the coefficients of the Steiner polynomial Vol(K + tB) = ∑ⱼ aⱼ tʲ). The intrinsic volumes are linearly independent valuations, so they form a basis and the space has dimension exactly n + 1. The hard direction (every such valuation is a combination of intrinsic volumes) is Hadwiger's characterization theorem, proved by reduction to the one-dimensional case via the behaviour of valuations on simple convex bodies.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
