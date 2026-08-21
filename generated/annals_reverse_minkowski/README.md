# `annals_reverse_minkowski`

A reverse Minkowski theorem

- Problem ID: `annals_reverse_minkowski`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Katerina Hristova
- Notes: The proof binder `hℒℒ'` is named `_hℒℒ'` here. This is alpha-equivalent and suppresses an unused-variable warning in the generated `Solution.lean` delegation.
- Source: O. Regev, N. Stephens-Davidowitz, `A reverse Minkowski theorem`, Annals of Math, 199 (1) 2024. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2024-199-1-ReverseMinkowski.lean

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
