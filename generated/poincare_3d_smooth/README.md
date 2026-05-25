# `poincare_3d_smooth`

3D smooth Poincaré conjecture (Perelman)

- Problem ID: `poincare_3d_smooth`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every simply connected compact Hausdorff smooth 3-manifold is diffeomorphic to 𝕊³. Recorded as `proof_wanted SimplyConnectedSpace.nonempty_diffeomorph_sphere_three` in `Mathlib/Geometry/Manifold/PoincareConjecture.lean`. The smooth-category strengthening of the topological 3D Poincaré conjecture; also Perelman 2002-2003. In dim 3 the smooth and topological versions are equivalent (Moise's theorem says every topological 3-manifold admits a unique smooth structure), but the Lean statement carries the smooth structure explicitly. Mathlib has all the differential-topology / manifold scaffolding but neither Ricci flow nor Moise's theorem.
- Source: G. Perelman, three arXiv preprints 2002-2003 (math/0211159, math/0303109, math/0307245). Recorded as a `proof_wanted` in Mathlib/Geometry/Manifold/PoincareConjecture.lean. In dim 3, Smooth ⇔ PL ⇔ Topological via Moise (1952) / Bing (1959).
- Informal solution: Apply the topological 3D Poincaré conjecture to obtain a homeomorphism M ≃ₜ S³, then promote it to a diffeomorphism via Moise's theorem (every topological 3-manifold admits a unique smooth structure up to diffeomorphism), or equivalently observe that Hamilton-Perelman Ricci flow with surgery runs in the smooth category and produces a smooth diffeomorphism directly. Either route involves the same Perelman input on the geometric side; the dim-3 special feature is Moise/Bing which collapses the smooth/topological distinction (false in dim 4 and above).

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
