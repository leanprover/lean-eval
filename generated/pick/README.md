# `pick`

Pick's theorem

- Problem ID: `pick`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A simple lattice polygon with n ≥ 3 vertices has area I + B/2 − 1, with I/B the interior/boundary lattice-point counts. Trusted helpers (toPlane, latPoly, inside, area, Adjacent, IsSimple, boundaryPts, interiorPts) are non-holes; the simplicity hypothesis is mandatory (the formula is false for self-intersecting polygons). Mathlib has Polygon and its boundary but no polygon interior, lattice counts, or Pick's theorem (formalized in Isabelle/HOL but not Lean). Candidate from §154 of the Knill survey.
- Source: G. Pick, *Geometrisches zur Zahlenlehre* (1899). Knill, *Some fundamental theorems in mathematics*, §154.
- Informal solution: Additivity + triangulation. Pick's measure P(poly) = I + B/2 − 1 is additive when gluing polygons along an edge (shared boundary points are double-counted as boundary then become interior, and the −1 terms combine correctly). Triangulate the simple polygon into lattice triangles; reduce to elementary (no interior/edge lattice points) triangles, each of area 1/2 with P = 0 + 3/2 − 1 = 1/2. Since both area and P are additive over the triangulation and agree on elementary triangles, they agree on the polygon. Requires the lattice triangulation + additivity machinery, absent from Mathlib.

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
