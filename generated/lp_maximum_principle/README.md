# `lp_maximum_principle`

Linear programming: maximum principle and vertex optimality

- Problem ID: `lp_maximum_principle`
- Test Problem: no
- Submitter: Kim Morrison
- Holes (2): `LeanEval.ConvexGeometry.lp_maximum_principle` (theorem), `LeanEval.ConvexGeometry.simplex_algorithm` (theorem)
- Notes: §101 of Oliver Knill's 'Some Fundamental Theorems in Mathematics' gives two structural facts for linear programs in standard inequality form: maximise c·x subject to A x ≤ b and 0 ≤ x. The maximum principle says any local maximiser of the linear objective on the feasible region is global, and if c ≠ 0 then it lies on the feasible region's frontier. The vertex optimality statement says that a nonempty bounded feasible region has an optimal solution at an extreme point (the existence content of Dantzig's simplex algorithm). Mathlib has the relevant convex-geometry notions, including IsLocalMaxOn, IsMaxOn, frontier, Set.extremePoints, and Krein–Milman-style infrastructure, but not these LP results as named theorems.
- Source: G. B. Dantzig (1947), simplex algorithm. Listed as §101 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Maximum principle: the objective x ↦ c·x is affine, hence both concave and convex, and the feasible region {x | A x ≤ b, 0 ≤ x} is convex. A local maximum of a concave function on a convex set is global: for any feasible y, the segment x + t(y − x) stays feasible and the objective along it is affine, so if it does not exceed the value at x for small t it cannot at t = 1 either. For the frontier claim, if c ≠ 0 then c·x is a non-constant affine functional, which on a convex set cannot attain its maximum at an interior point (moving in the direction +c stays inside a small ball and strictly increases the objective), so the maximiser is on the frontier. Vertex optimality: a nonempty bounded feasible region of an LP is a compact convex polytope, so by Krein–Milman it is the closed convex hull of its extreme points and the continuous objective attains its maximum; among maximisers, an extreme point of the face on which the maximum is attained is an extreme point of the whole region, giving an optimal vertex.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
