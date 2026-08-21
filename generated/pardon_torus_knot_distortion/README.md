# `pardon_torus_knot_distortion`

Pardon's lower bound for torus-knot distortion

- Problem ID: `pardon_torus_knot_distortion`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: For positive coprime p and q, every smooth representative in the orientation-preserving smooth ambient-isotopy class of the explicitly parametrized standard (p, q)-torus curve has distortion at least min(p, q) / 160. Intrinsic distance is the shorter of the two complementary arclengths, and distortion is the supremum in the extended nonnegative reals of intrinsic distance divided by Euclidean chord length over distinct points. The extended codomain faithfully represents the possibility of infinite distortion without imposing an unrelated boundedness proof. Pardon's published theorem takes the infimum over all rectifiable representatives of the unoriented isotopy class; because LeanEval.KnotTheory.Prelude models smooth knots, this benchmark is its faithful smooth, orientation-sensitive specialization. It is separate from the 3-dimensional Hilbert-Smith problem already proposed in PR #482.
- Source: John Pardon, 'On the distortion of knots on embedded surfaces', Annals of Mathematics (2) 174 (2011), no. 1, 637-646, Theorem 1.1. https://doi.org/10.4007/annals.2011.174.1.21
- Informal solution: Apply Pardon's more general surface theorem (Theorem 1.3) to a PL torus F isotopic to the standard unknotted torus and the simple loop beta of slope (p, q). Its invariant I(F, beta), the minimum geometric intersection number with a compressing-disk boundary, is min(p, q). Theorem 1.3 gives delta(K_beta) >= I(F, beta) / 160, where delta(K_beta) is the infimum over all rectifiable representatives. Consequently every such representative, in particular the smooth knot K quantified here, satisfies the same lower bound.

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
