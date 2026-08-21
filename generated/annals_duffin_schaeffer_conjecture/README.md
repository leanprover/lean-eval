# `annals_duffin_schaeffer_conjecture`

On the Duffin-Schaeffer conjecture

- Problem ID: `annals_duffin_schaeffer_conjecture`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Katerina Hristova, Kevin Buzzard
- Holes (4): `DuffinSchaefferConjecture.theorem_1` (theorem), `DuffinSchaefferConjecture.theorem_2_a` (theorem), `DuffinSchaefferConjecture.theorem_2_b` (theorem), `DuffinSchaefferConjecture.corollary_3` (theorem)
- Notes: In the paper, `ℕ` denotes the positive integers, which are denoted `ℕ+` in Lean. Hence, no changes to the domains of the functions `ψ` and `ψ⋆` have been made in the formalisation. LeanEval changes `lemma corollary_3` to `theorem corollary_3` because the workspace generator addresses theorem holes by that keyword; this does not change the declaration's type.
- Source: D. Koukoulopoulos and J. Maynard, `On the Duffin-Schaeffer conjecture`, Annals of Math, 192 (1) 2020. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2020-192-1-DuffinSchaefferConjecture.lean

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
