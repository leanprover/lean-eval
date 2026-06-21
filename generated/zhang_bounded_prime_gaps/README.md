# `zhang_bounded_prime_gaps`

Bounded gaps between primes

- Problem ID: `zhang_bounded_prime_gaps`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Zhang's bounded-gaps theorem, sharpened by Maynard and the Polymath8 project: for every `n` there exist primes `p < q` with `n ≤ p` and `q - p ≤ 246`, the post-Polymath bound recorded by Knill. Equivalently, infinitely many prime pairs differ by at most 246. mathlib has `Nat.Prime` and prime-counting estimates, but no Selberg/GPY sieve.
- Source: Y. Zhang, Bounded gaps between primes, Ann. of Math. 179 (2014), 1121-1174; J. Maynard, Small gaps between primes, Ann. of Math. 181 (2015), 383-413; D. H. J. Polymath, Variants of the Selberg sieve, and bounded intervals containing many primes, Res. Math. Sci. 1 (2014), Art. 12. Listed as §224 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §224.
- Informal solution: Use the GPY/Maynard multidimensional sieve. Choose an admissible k-tuple of linear forms and a sieve weight optimizing a ratio of two quadratic forms in a smooth cutoff; Maynard's variational argument shows that for k large enough the weighted count guarantees at least two primes among the shifted forms in infinitely many translates. The Polymath8 optimization of the cutoff and the choice of an admissible 50-tuple yields the explicit gap bound 246.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
