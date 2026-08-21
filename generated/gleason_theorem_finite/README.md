# `gleason_theorem_finite`

Gleason's theorem (finite-dimensional)

- Problem ID: `gleason_theorem_finite`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Gleason's theorem in finite dimensions: every frame function on the orthogonal projections of a complex Hilbert space of dimension at least 3 is given by P ↦ Tr(ρ P) for the unique density operator ρ. Stated using a bespoke `FrameFunction` structure (non-negative, additive on orthogonal projection pairs, normalized at the identity) and the standard Mathlib trace `LinearMap.trace`. Finite additivity on orthogonal pairs already implies countable additivity in finite dimensions, so the hypothesis matches Gleason's original σ-additive frame functions.
- Source: A. M. Gleason, Measures on the closed subspaces of a Hilbert space, J. Math. Mech. 6 (1957), 885-893.
- Informal solution: Gleason's original proof analyses regular frame functions on the unit sphere of R^3 by showing they are continuous and then quadratic, then promotes the resulting positive quadratic form on every 3-dimensional real subspace of H to a positive operator ρ on H whose diagonal in any orthonormal basis recovers the frame function, with Tr(ρ) = μ(I) = 1 ensuring ρ is a density operator.

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
