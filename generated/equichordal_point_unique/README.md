# `equichordal_point_unique`

Equichordal point theorem (convex curves have a unique equichordal point)

- Problem ID: `equichordal_point_unique`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A compact convex planar domain with nonempty interior cannot have two distinct equichordal points: there is no pair of interior points P ≠ Q such that, for each, every direction yields a boundary chord of one fixed total length. The curve is packaged as the frontier of K; for convex K a line through an interior point meets the boundary on the two opposite rays. Mathlib has StarConvex and the Euclidean plane EuclideanSpace ℝ (Fin 2) but no equichordal-point theory. The original uniqueness was proved by Rychlik; Knill lists it as §205.
- Source: M. R. Rychlik, A complete solution to the equichordal point problem of Fujiwara, Blaschke, Rothe and Weizenböck, Invent. Math. 129 (1997). Listed as §205 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §205.
- Informal solution: Suppose P and Q were two distinct equichordal points with common chord constant L. Following Rychlik, complexify and analyze the equichordal map (the involution sending one chord endpoint through P to the opposite endpoint through Q); its dynamics define a real-analytic area-preserving map of the annulus whose invariant curves and heteroclinic connections are obstructed. Rychlik shows the resulting functional/dynamical system has no closed convex curve solution for L > 0 unless P = Q, contradicting P ≠ Q. No such argument is available in Mathlib, which lacks the equichordal map, its complex-analytic continuation, and the KAM/heteroclinic machinery used.

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
