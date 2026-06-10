# `pascal`

Pascal's theorem

- Problem ID: `pascal`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Six distinct points on a non-singular conic determine three collinear intersection points Aᵢ Bⱼ ∩ Aⱼ Bᵢ. Trusted helpers (SamePoint, OnConic, meet, Collinear3) are non-holes, built on the cross product ⨯₃. Mathlib has the projective vocabulary but not Pascal's theorem. Candidate from §146 of the Knill survey.
- Source: B. Pascal, *Essay pour les coniques* (1640). Knill, *Some fundamental theorems in mathematics*, §146.
- Informal solution: Project-and-compute, or the classical synthetic proof. Algebraically: choose homogeneous coordinates; the conic is xᵀMx=0. The three meet points' collinearity is a polynomial identity in the six points' coordinates that holds on the conic — provable by a Gröbner/resultant computation, or synthetically via the converse of Menelaus applied to the hexagon, or as the d=2 Cayley–Bacharach instance (a cubic through 8 of the 9 base points of two degenerate cubics passes through the 9th). None of this packaging is in Mathlib.

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
