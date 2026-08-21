# `sphere_theorem_topological`

Topological sphere theorem (Berger–Klingenberg–Rauch)

- Problem ID: `sphere_theorem_topological`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: A closed, simply-connected, strictly quarter-pinched (sectional curvature in (1,4]) smooth Riemannian d-manifold (d ≥ 2) is homeomorphic to the standard d-sphere. Trusted helpers IsMetricCompatible, curv (Riemann curvature tensor), QuarterPinched (non-holes); following §38 the Levi-Civita connection is hypothesized as a smooth torsion-free metric-compatible covariant derivative (Mathlib has the interface but does not construct Levi-Civita). Mathlib has no Riemann/sectional curvature or pinching. Candidate from §121 of the Knill survey.
- Source: M. Berger; W. Klingenberg; H. E. Rauch (topological sphere theorem, 1951–1961). Knill, *Some fundamental theorems in mathematics*, §121.
- Informal solution: Classical sphere theorem via Toponogov/Klingenberg. From strict quarter-pinching, Klingenberg's injectivity-radius estimate gives inj(M) ≥ π/√(max K). Cover M by two metric balls around a point and its farthest point; Toponogov's triangle comparison shows each is a disk and they glue along a sphere, exhibiting M as a twisted sphere, hence homeomorphic to Sᵈ (Brown's theorem / Reeb). Needs the curvature comparison geometry (Toponogov, Rauch, Klingenberg injectivity radius) absent from Mathlib.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
