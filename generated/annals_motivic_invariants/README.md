# `annals_motivic_invariants`

Motivic invariants of birational maps

- Problem ID: `annals_motivic_invariants`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Justus Springer
- Holes (6): `MotivicInvariants.theorem_1_2_1_a` (theorem), `MotivicInvariants.theorem_1_2_1_b` (theorem), `MotivicInvariants.theorem_1_2_1_c` (theorem), `MotivicInvariants.theorem_1_2_1_d` (theorem), `MotivicInvariants.theorem_1_2_2` (theorem), `MotivicInvariants.theorem_1_2_3` (theorem)
- Source: H.-Y. Lin and E. Shinder, `Motivic invariants of birational maps`, Annals of Math, 199 (1) 2024. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2024-199-1-MotivicInvariants.lean

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
