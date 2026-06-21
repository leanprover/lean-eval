# `brun_constant_converges`

Brun's theorem (convergence of the twin-prime reciprocal sum)

- Problem ID: `brun_constant_converges`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Brun's theorem: the sum of the reciprocals of the twin primes converges, to a value now known as Brun's constant. The statement is phrased via a per-pair reciprocal term `twinPrimeReciprocalTerm p`, which contributes `1/p + 1/(p+2)` when `p` starts a twin pair and `0` otherwise, and asserts that this function is `Summable`. mathlib has `Nat.Prime`, `Summable`, and prime-counting estimates, but no Brun sieve.
- Source: V. Brun, La série 1/5+1/7+1/11+1/13+... où les dénominateurs sont nombres premiers jumeaux est convergente ou finie, Bull. Sci. Math. 43 (1919), 100-104, 124-128. Listed as §224 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §224.
- Informal solution: Brun's sieve bounds the twin-prime counting function π₂(x) by O(x (log log x)² / (log x)²). Summing the reciprocals by dyadic blocks and applying this bound, the tail sums are dominated by a convergent series (essentially ∑ (log log n)² / (n (log n)²)), so the reciprocal sum over twin pairs converges.

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
