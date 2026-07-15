# `isoperimetric_inequality`

Isoperimetric inequality (n-dim, topological-frontier form)

- Problem ID: `isoperimetric_inequality`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: n-dimensional isoperimetric inequality for measurable bounded B ⊆ ℝⁿ, n ≥ 2: n^n · volume(B)^{n−1} · volume(closedBall 0 1) ≤ μHE[n−1](frontier B)^n, with μHE[n−1] the (n−1)-dim Euclidean Hausdorff measure on the topological frontier. The topological-frontier formulation is strictly weaker than the canonical De Giorgi finite-perimeter form: the topological frontier can strictly contain the reduced boundary, so this RHS is pointwise larger than the perimeter. For a smooth bounded domain with regular bounding hypersurface S = frontier B, μHE[n−1](frontier B) agrees with the classical surface area. The 2 ≤ n hypothesis excludes the n = 1 case where the ENNReal formulation has B = ∅ as a counterexample (0^0 · 2 = 2 ≠ 0). §71 of Knill's 'Some Fundamental Theorems in Mathematics'.
- Source: Classical isoperimetric inequality; modern finite-perimeter / GMT formulations are due to E. De Giorgi and H. Federer. Listed as §71 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). The Wiedijk-100 entry 'The Isoperimetric Theorem' is unformalised in Lean.
- Informal solution: Standard proofs work at the De Giorgi perimeter level via Brunn–Minkowski plus Steiner symmetrization: Steiner-symmetrize B with respect to n hyperplanes, each step preserves volume and decreases perimeter, converging to a ball B* of the same volume, where equality holds. Lower-semicontinuity of perimeter under Steiner symmetrization closes the inequality. The frontier version of this PR follows from the perimeter version because the De Giorgi perimeter is bounded above by μHE[n−1](frontier B). Alternative routes: optimal transport (Brenier / Knothe), Sobolev W^{1,1} → L^{n/(n−1)} via Federer–Fleming with co-area, or Gromov's proof.

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
