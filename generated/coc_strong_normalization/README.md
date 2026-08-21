# `coc_strong_normalization`

Strong normalization and consistency for the calculus of constructions with a universe hierarchy

- Problem ID: `coc_strong_normalization`
- Group: `software-verification`
- Status: `active`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Holes (6): `LeanEval.ProgramVerification.CoCStrongNormalization.typing_polyId` (theorem), `LeanEval.ProgramVerification.CoCStrongNormalization.typing_polyId_app` (theorem), `LeanEval.ProgramVerification.CoCStrongNormalization.step_polyId_app` (theorem), `LeanEval.ProgramVerification.CoCStrongNormalization.subject_reduction` (theorem), `LeanEval.ProgramVerification.CoCStrongNormalization.strong_normalization` (theorem), `LeanEval.ProgramVerification.CoCStrongNormalization.consistency` (theorem)
- Notes: Strong normalization requires Girard's reducibility candidates, and the impredicative `Prop` rule `(s, prop, prop)` is what makes a naive induction on types fail. The three anti-vacuity guards require a nonempty typing relation and exercise polymorphic typing, `Typing.app`, beta reduction, and substitution. Mathlib does not provide the requested Lean theorem; earlier Coq mechanizations and semantic models of CC and CCω are acknowledged in the module documentation.
- Source: Coquand and Huet, 'The calculus of constructions' (1988); Zhaohui Luo, 'An Extended Calculus of Constructions' (1990); Bruno Barras, 'Sets in Coq, Coq in Sets' (2010).
- Informal solution: Use reducibility candidates in the style of Girard, extended to dependent types and the predicative universe hierarchy. A smaller λC rehearsal replaces the hierarchy by `Prop` and a top sort `Type 0`; it is a different typing relation, not literally the restriction of this CCω syntax to two sorts.

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
