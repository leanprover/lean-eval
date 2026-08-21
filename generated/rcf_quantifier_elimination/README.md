# `rcf_quantifier_elimination`

Quantifier elimination for the theory of real closed fields

- Problem ID: `rcf_quantifier_elimination`
- Group: `software-verification`
- Status: `active`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Holes (4): `LeanEval.ProgramVerification.RealClosedFieldQE.qe` (def), `LeanEval.ProgramVerification.RealClosedFieldQE.isQF_qe` (theorem), `LeanEval.ProgramVerification.RealClosedFieldQE.holds_qe` (theorem), `LeanEval.ProgramVerification.RealClosedFieldQE.holds_ex_sq` (theorem)
- Notes: `isQF_qe` and `holds_qe` are jointly load-bearing; either alone admits a trivial implementation (`fun _ => .fals` and `id` respectively). Enumerating quantifier-free syntax is not a shortcut because recognizing an equivalent candidate already requires the substantive quantifier-elimination argument. The `holds_ex_sq` guard pins the intended de Bruijn and semantic interpretation. The pinned Mathlib dependency supplies real-closed-field algebra but not this `qe`; `Classical.choice` still requires first proving existence of a quantifier-free equivalent. A separate `valid?` hole was rejected as vulnerable to a one-line noncomputable implementation; see the module documentation.
- Source: Tarski, 'A Decision Method for Elementary Algebra and Geometry' (1951); Collins, 'Quantifier elimination for real closed fields by cylindrical algebraic decomposition' (1975); Mahboubi, 'Programming and certifying a CAD algorithm in the Coq system' (2006); Cohen and Mahboubi, 'Formal proofs in real algebraic geometry: from ordered fields to quantifier elimination' (2012).
- Informal solution: The Cohen-Hormander route has a comparatively small formalization footprint; Cohen and Mahboubi's Coq development uses an algebraic pseudo-remainder route. Cylindrical algebraic decomposition is another practical route and has been formalized in Coq, including Mahboubi's work and the current MathComp CAD development.

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
