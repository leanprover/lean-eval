# `hilbert_smith_padic_dimension_three`

No continuous faithful ℤ_p action on a connected 3-manifold (Pardon 2013)

- Problem ID: `hilbert_smith_padic_dimension_three`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Jack McCarthy
- Notes: Pardon's Theorem 1.5: for every prime p, the additive group of p-adic integers admits no continuous faithful action on a connected topological 3-manifold. The statement uses a Hausdorff, second-countable ChartedSpace modelled on ℝ³ and assumes no smooth structure. This is the p-adic step only: the full Hilbert–Smith conjecture in dimension three (every locally compact group acting faithfully on a connected three-manifold is a Lie group) additionally needs the classical reduction to ℤ_p actions, which is not part of the hole.
- Source: John Pardon, 'The Hilbert-Smith conjecture for three-manifolds', Journal of the American Mathematical Society 26 (2013), no. 3, 879-899, Theorem 1.5. https://doi.org/10.1090/S0894-0347-2013-00766-3
- Informal solution: Assume that ℤ_p acts faithfully. After passing to a sufficiently small open subgroup, localize the action in a Euclidean chart and construct a suitable invariant region with second homology ℤ. Isotopy classes of incompressible surfaces representing its generator form a lattice, yielding a surface whose isotopy class is fixed by ℤ_p. The induced finite-image homomorphism from ℤ_p to the surface mapping class group produces a nontrivial cyclic p-subgroup with homological properties ruled out by the Nielsen classification, giving a contradiction.

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
