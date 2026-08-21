# `finite_group_isSolvable_of_card_eq_prime_pow_mul_prime_pow`

Burnside p^a q^b theorem

- Problem ID: `finite_group_isSolvable_of_card_eq_prime_pow_mul_prime_pow`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Burnside's theorem that a finite group of order p^a q^b is solvable.
- Source: Classical theorem in finite group theory.
- Informal solution: Use character theory and induction on the group order to prove solvability.

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
