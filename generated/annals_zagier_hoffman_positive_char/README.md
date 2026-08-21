# `annals_zagier_hoffman_positive_char`

On Zagier-Hoffman's conjectures in positive characteristic

- Problem ID: `annals_zagier_hoffman_positive_char`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Katerina Hristova
- Holes (3): `ZagierHoffmanPositiveChar.theorem_A` (theorem), `ZagierHoffmanPositiveChar.theorem_B` (theorem), `ZagierHoffmanPositiveChar.theorem_D` (theorem)
- Notes: Throughout the definitions and statements, we reindex the `i`'s so that they run from `0` to `r - 1` rather than from `1` to `r`.
- Source: T. N. Dac, `On Zagier-Hoffman's conjectures in positive characteristic`, Annals of Math, 194 (1) 2021. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2021-194-1-ZagierHoffmanPositiveChar.lean

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
