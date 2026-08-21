# `annals_supremum_of_selector_processes`

On a conjecture of Talagrand on selector processes and a consequence on positive empirical processes

- Problem ID: `annals_supremum_of_selector_processes`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: David Ledvinka
- Holes (6): `SupremumOfSelectorProcesses.L₂` (def), `SupremumOfSelectorProcesses.L₂_pos` (theorem), `SupremumOfSelectorProcesses.theorem_1_2` (theorem), `SupremumOfSelectorProcesses.L₃` (def), `SupremumOfSelectorProcesses.L₃_pos` (theorem), `SupremumOfSelectorProcesses.theorem_1_3` (theorem)
- Notes: The five anonymous explicit instance binders in `theorem_1_3` are named because the generated delegation cannot forward inaccessible hygienic binder names. This is alpha-equivalent and does not change the statement.
- Source: J. Park and H. T. Pham, `On a conjecture of Talagrand on selector processes and a consequence on positive empirical processes`, Annals of Math, 199 (3) 2024. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2024-199-3-SupremumOfSelectorProcesses.lean

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
