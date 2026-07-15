# `jordan_normal_form`

Jordan normal form

- Problem ID: `jordan_normal_form`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Over an algebraically closed field, every endomorphism of Kⁿ has a Jordan-chain basis (every n×n matrix is similar to a block-diagonal Jordan matrix). Trusted helpers (StdSpace, JordanChainBasis) are non-holes. Mathlib has the Jordan–Chevalley–Dunford decomposition but not the Jordan-chain-basis/Jordan normal form. Candidate from §165 of the Knill survey.
- Source: C. Jordan (1870). Knill, §165.

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
