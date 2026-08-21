# `sphere_theorem_differentiable`

Differentiable sphere theorem (Brendle–Schoen)

- Problem ID: `sphere_theorem_differentiable`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Under the same hypotheses as the topological sphere theorem (closed, simply-connected, strictly quarter-pinched, d ≥ 2), the manifold is diffeomorphic to the standard d-sphere (Brendle–Schoen 2007, via Ricci flow). Shares the §121 trusted helpers (IsMetricCompatible, curv, QuarterPinched). Mathlib has no Ricci flow or curvature. Candidate from §121 of the Knill survey (additional 1).
- Source: S. Brendle & R. Schoen, *Manifolds with 1/4-pinched curvature are space forms*, J. AMS 22 (2009). Knill, *Some fundamental theorems in mathematics*, §121.
- Informal solution: Brendle–Schoen via Hamilton's Ricci flow. Run the normalized Ricci flow ġ = −2Ric(g) + (2/d)r̄ g from the quarter-pinched metric. The key analytic input is that the strict quarter-pinching condition (more precisely, nonnegative isotropic curvature on M × ℝ²) is preserved by the flow (Brendle–Schoen's curvature-pinching estimates via the maximum principle for the curvature-tensor reaction–diffusion equation), and the flow converges, after rescaling, to a constant-curvature round metric. Hence M is diffeomorphic to the round sphere. Requires Ricci flow and the pinching-preservation estimates, none in Mathlib.

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
