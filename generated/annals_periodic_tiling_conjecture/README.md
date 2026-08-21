# `annals_periodic_tiling_conjecture`

A counterexample to the periodic tiling conjecture

- Problem ID: `annals_periodic_tiling_conjecture`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: David Ledvinka
- Holes (3): `PeriodicTilingConjecture.theorem_1_4` (theorem), `PeriodicTilingConjecture.corollary_1_6` (theorem), `PeriodicTilingConjecture.corollary_1_7` (theorem)
- Source: R. Greenfeld and T. Tao, `A counterexample to the periodic tiling conjecture`, Annals of Math, 200 (1) 2024. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2024-200-1-PeriodicTilingConjecture.lean

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
