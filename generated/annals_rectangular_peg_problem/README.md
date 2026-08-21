# `annals_rectangular_peg_problem`

The rectangular peg problem

- Problem ID: `annals_rectangular_peg_problem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Katerina Hristova
- Notes: LeanEval renames upstream's declaration `theorem «theorem»` to `theorem_1` because the workspace generator cannot address a declaration whose basename is a reserved word; the statement is unchanged.
- Source: J. E. Greene and A. Lobb, `The rectangular peg problem`, Annals of Math, 194 (2) 2021. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2021-194-2-RectangularPegProblem.lean

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
