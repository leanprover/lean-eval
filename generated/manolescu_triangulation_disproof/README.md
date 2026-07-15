# `manolescu_triangulation_disproof`

Manolescu's disproof of the triangulation conjecture

- Problem ID: `manolescu_triangulation_disproof`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The triangulation conjecture (every topological manifold is homeomorphic to a simplicial complex) is false: Manolescu showed that in every dimension n ≥ 5 there are closed topological manifolds that are not triangulable. We state, for every n ≥ 5, the existence of a closed connected n-manifold not homeomorphic to the geometric realization of any simplicial complex. Triangulability is encoded via Mathlib's Geometry.SimplicialComplex over a finite-dimensional Euclidean space ℝᴺ, with finitely many faces (faithful for compact manifolds, whose triangulations are finite complexes realizing in some ℝᴺ with its standard topology; the finiteness requirement is essential, else a degenerate complex of one singleton face per point of an embedded M would make every manifold vacuously triangulable).
- Source: C. Manolescu, *Pin(2)-equivariant Seiberg–Witten Floer homology and the triangulation conjecture*, J. Amer. Math. Soc. 29 (2016), via the Galewski–Stern and Matumoto reduction. Earlier, the triangulation conjecture was known false in dimension 4 (Casson).
- Informal solution: No formalization is feasible today: Mathlib has SimplicialComplex but no PL/manifold triangulation theory, no Seiberg–Witten or Floer homology, and nothing of the Galewski–Stern homology-cobordism obstruction. The intended witnesses are the Galewski–Stern manifolds whose non-triangulability Manolescu established.

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
