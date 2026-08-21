# `annals_pointwise_ergodic_theorems`

Pointwise ergodic theorems for non-conventional bilinear polynomial averages

- Problem ID: `annals_pointwise_ergodic_theorems`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: David Ledvinka
- Holes (6): `PointwiseErgodicTheorems.theorem_1_17_i` (theorem), `PointwiseErgodicTheorems.theorem_1_17_ii` (theorem), `PointwiseErgodicTheorems.Cᵢᵢᵢ` (def), `PointwiseErgodicTheorems.theorem_1_17_iii` (theorem), `PointwiseErgodicTheorems.Cᵢᵥ` (def), `PointwiseErgodicTheorems.theorem_1_17_iv` (theorem)
- Source: B. Krause, M. Mirek, and T. Tao, `Pointwise ergodic theorems for non-conventional bilinear polynomial averages`, Annals of Math, 195 (3) 2022. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2022-195-3-PointwiseErgodicTheorems.lean

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
