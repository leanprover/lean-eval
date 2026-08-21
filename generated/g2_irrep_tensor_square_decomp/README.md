# `g2_irrep_tensor_square_decomp`

Existence of a 64-dim irreducible g₂-representation with 14 tensor-square isotypic components

- Problem ID: `g2_irrep_tensor_square_decomp`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: g₂ is the smallest exceptional Lie algebra, defined here by the Serre construction (Mathlib's `LieAlgebra.g₂`). The formal statement is existential: it asks for some 64-dimensional irreducible representation whose tensor square has 14 isotypic components. In the intended solution, one constructs such a witness using the highest-weight representation with highest weight ω₁ + ω₂ (the sum of the two fundamental weights). The U(g)-module structure on V ⊗ V used in the statement comes from lifting the Lie action via the universal enveloping algebra.
- Source: Classical: representation theory of the exceptional Lie algebra g₂.
- Informal solution: Construct V as the irreducible 64-dim representation V(ω₁+ω₂). Decomposition (LiE-verified): V⊗V = V(0,0) + V(1,0) + 2V(0,1) + 2V(2,0) + 2V(1,1) + 2V(0,2) + 3V(3,0) + 3V(2,1) + V(1,2) + V(0,3) + 2V(4,0) + 2V(3,1) + V(2,2) + V(5,0). This is used to produce the existential witness required by the formal statement.

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
