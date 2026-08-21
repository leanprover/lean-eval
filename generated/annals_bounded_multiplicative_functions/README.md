# `annals_bounded_multiplicative_functions`

Higher uniformity of bounded multiplicative functions in short intervals on average

- Problem ID: `annals_bounded_multiplicative_functions`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: David Ledvinka
- Holes (2): `BoundedMultiplicativeFunctions.theorem_1_3` (theorem), `BoundedMultiplicativeFunctions.corollary_1_1` (theorem)
- Notes: The proof binders `hQ`, `hC`, `hf`, `hf'`, `hX`, `hXH`, and `hHX` in `theorem_1_3` are prefixed with `_` here. This is alpha-equivalent and suppresses unused-variable warnings in the generated `Solution.lean`, whose delegation supplies the enclosing proof at once.
- Source: K. Matomäki, M. Radziwiłł, T. Tao, J. Teräväinen, and T. Ziegler, `Higher uniformity of bounded multiplicative functions in short intervals on average`, Annals of Math, 197 (2) 2023. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2023-197-2-BoundedMultiplicativeFunctions.lean

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
