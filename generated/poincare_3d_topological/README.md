# `poincare_3d_topological`

3D topological Poincaré conjecture (Perelman)

- Problem ID: `poincare_3d_topological`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every simply connected compact Hausdorff 3-manifold is homeomorphic to 𝕊³. Recorded as `proof_wanted SimplyConnectedSpace.nonempty_homeomorph_sphere_three` in `Mathlib/Geometry/Manifold/PoincareConjecture.lean`. Proved by Perelman in 2002-2003 via Hamilton's Ricci flow with surgery; one of the seven Millennium Problems. Mathlib has ChartedSpace, SimplyConnectedSpace, CompactSpace, T2Space, Homeomorph and the unit sphere as a smooth manifold but no Ricci flow, no Hamilton-Perelman surgery, and no Poincaré conjecture itself.
- Source: G. Perelman, The entropy formula for the Ricci flow and its geometric applications (arXiv:math/0211159, 2002); Ricci flow with surgery on three-manifolds (arXiv:math/0303109, 2003); Finite extinction time for the solutions to the Ricci flow on certain three-manifolds (arXiv:math/0307245, 2003). Recorded as a `proof_wanted` in Mathlib/Geometry/Manifold/PoincareConjecture.lean. Originally conjectured by Henri Poincaré in 1904.
- Informal solution: Run Ricci flow ∂g/∂t = -2 Ric(g) on M with surgery to remove finite-time singularities (Hamilton's program, completed by Perelman). The flow simplifies the metric, and Perelman's monotonicity formulas (reduced volume, ℒ-functional, no local collapsing) together with the canonical-neighbourhood theorem control the geometry. In finite time the flow either becomes extinct (M is a connected sum of spherical space forms and S²×S¹s, in particular when π_1(M) = 1, M = S³) or decomposes M along incompressible 2-tori into pieces of one of Thurston's eight geometric types; the simply-connected hypothesis rules out the toroidal decomposition and the spherical-space-form ambiguity, leaving M ≃ S³.

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
