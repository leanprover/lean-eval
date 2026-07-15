# `chen_theorem`

Chen's theorem

- Problem ID: `chen_theorem`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Chen's theorem: there are infinitely many primes `p` such that `p + 2` is a prime or a product of two primes (a 'prime or semiprime'). The predicate `HasAtMostTwoPrimeFactors n` is the disjunction 'n is prime' or 'n = a·b with a, b prime'. mathlib has `Nat.Prime` and prime factorization, but no Brun-style weighted sieve.
- Source: J. R. Chen, On the representation of a larger even integer as the sum of a prime and the product of at most two primes, Sci. Sinica 16 (1973), 157-176. Listed as §224 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §224.
- Informal solution: Chen's argument is a weighted sieve. Apply Selberg's sieve with a switching device (Chen's 'reversal of roles') to bound from below the number of primes p ≤ x with p+2 having at most two prime factors. The key is a careful estimate of the bilinear error terms via the Bombieri-Vinogradov theorem, which controls primes in arithmetic progressions on average and lets the sieve weight stay positive, forcing infinitely many such p.

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
