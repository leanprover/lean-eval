# `annals_integer_multiplication`

Integer multiplication in time O(n log n)

- Problem ID: `annals_integer_multiplication`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Justus Springer
- Notes: The paper works in the "multitape Turing model, in which the time complexity of an algorithm refers to the number of steps performed by a deterministic Turing machine with a fixed, finite number of linear tapes". In this formalisation, we use mathlib's multi-stack machines (TM2), which are equivalent to multitape machines by an O(1) reduction (use two stacks to simulate one tape).
- Source: D. Harvey and J. van der Hoeven, `Integer multiplication in time O(n log n)`, Annals of Math, 193 (2) 2021. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2021-193-2-IntegerMultiplication.lean

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
