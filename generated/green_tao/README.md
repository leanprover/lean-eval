# `green_tao`

Green–Tao theorem

- Problem ID: `green_tao`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §37 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. The set of primes contains arbitrarily long arithmetic progressions: for every k there exist a ≥ 0 and b ≥ 1 such that a + b·j is prime for every j < k. Mathlib has Dirichlet's theorem (Nat.infinite_setOf_prime_and_modEq) and Roth's theorem on 3-APs (roth_3ap_theorem_nat) but not Green-Tao. As of 2026 the theorem has not been formalized in any major proof assistant (a long-standing open formalization target).
- Source: B. Green and T. Tao, The primes contain arbitrarily long arithmetic progressions, Ann. of Math. 167 (2008), 481-547 (announced 2004). Listed as §37 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The proof has three main steps. (i) A transference principle: it suffices to find arbitrarily long APs in any set of positive density in a suitable pseudorandom super-set. (ii) Pseudorandomness of the primes after a `W-trick': removing small prime factors via a Selberg-style sieve makes the indicator function of the primes dominated by a pseudorandom measure ν. (iii) Apply Szemerédi's theorem in the relative form (a Furstenberg-style multiple recurrence / Gowers-uniformity argument) to that pseudorandom set, transferring the AP-rich conclusion back to the primes.

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
