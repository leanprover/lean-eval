# `annals_chowla_and_twin_prime_over_fq_t`

On the Chowla and twin primes conjectures over 𝔽_q[T]

- Problem ID: `annals_chowla_and_twin_prime_over_fq_t`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Thomas Browning
- Holes (2): `ChowlaAndTwinPrimeOverFqT.theorem_1_1` (theorem), `ChowlaAndTwinPrimeOverFqT.theorem_1_3` (theorem)
- Source: W. Sawin and M. Shusterman, `On the Chowla and twin primes conjectures over 𝔽_q[T]`, Annals of Math, 196 (2) 2022. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2022-196-2-ChowlaAndTwinPrimeOverFqT.lean

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
