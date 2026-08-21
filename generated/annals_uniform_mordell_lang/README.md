# `annals_uniform_mordell_lang`

Uniformity in Mordell–Lang for curves

- Problem ID: `annals_uniform_mordell_lang`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Thomas Browning, Christian Merten
- Holes (13): `UniformMordellLang.JacobianChallenge.genus` (def), `UniformMordellLang.JacobianChallenge.Jacobian` (def), `UniformMordellLang.JacobianChallenge.Jacobian.instGrpObj` (def), `UniformMordellLang.JacobianChallenge.Jacobian.smoothOfRelativeDimension_genus` (def), `UniformMordellLang.JacobianChallenge.Jacobian.instIsProper` (def), `UniformMordellLang.JacobianChallenge.Jacobian.instGeometricallyIrreducible` (def), `UniformMordellLang.JacobianChallenge.Jacobian.ofCurve` (def), `UniformMordellLang.JacobianChallenge.Jacobian.comp_ofCurve` (theorem), `UniformMordellLang.JacobianChallenge.Jacobian.exists_unique_ofCurve_comp` (theorem), `UniformMordellLang.JacobianChallenge.Jacobian.instGeometricallyIntegral` (def), `UniformMordellLang.JacobianChallenge.Jacobian.instFG` (def), `UniformMordellLang.c` (def), `UniformMordellLang.theorem_1_1` (theorem)
- Notes: AnnalsChallenge states this theorem on top of Christian Merten's Jacobian challenge (`AnnalsChallenge/Definitions/AlgebraicJacobian.lean`). LeanEval's existing port of that file, problem `jacobian_challenge_alggeo`, omits the four declarations at its end, including the instances that supply the `CommGroup` and `Group.FG` structures used by `freeRank`. This module therefore carries a namespaced copy of the full upstream Jacobian characterisation and its derived point-group structure. Proof-valued instance holes are expressed as instance-reducible definitions so comparator can traverse the derived instances without comparing placeholder proof bodies; their types and the statement of Theorem 1.1 are unchanged. The upstream `instCommGroup := inferInstance` is spelled as the same explicit, reducible `CategoryTheory.Hom.commGroup` instance so Challenge and Solution elaborate it with identical reducibility hints; it remains derived rather than becoming a solver hole.
- Source: V. Dimitrov, Z. Gao, and P. Habegger, `Uniformity in Mordell–Lang for curves`, Annals of Math, 194 (1) 2021. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2021-194-1-UniformMordellLang.lean

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
