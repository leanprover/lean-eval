# `chebyshev_sign_change`

Hardy–Littlewood sign-change for the prime race mod 4

- Problem ID: `chebyshev_sign_change`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The difference π₃(n) − π₁(n), where πᵢ(n) counts primes ≤ n congruent to i mod 4, takes both positive and negative values infinitely often. Chebyshev (1853) observed the empirical bias toward π₃(n) > π₁(n); Hardy and Littlewood (1914) proved unconditionally that π₁ nevertheless overtakes π₃ infinitely often, and the reverse direction is the typical Chebyshev-bias inequality. §106 of Knill's *Some Fundamental Theorems in Mathematics* lists this under the metamathematical 'strong law of small numbers'; the formalised theorem here is the Hardy–Littlewood sign-change theorem.
- Source: G.H. Hardy and J.E. Littlewood, 'Contributions to the theory of the Riemann zeta-function and the theory of the distribution of primes', Acta Math. 41 (1916) 119–196 (announced 1914). Chebyshev's original observation: P. Chebyshev, letter to M. Fuss, 1853, in *Œuvres de P.L. Tchebychef*, vol. I (Saint Petersburg, 1899). Listed as §106 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: This is an analytic-number-theory theorem of Hardy and Littlewood. The modern argument studies the difference π₃(x) − π₁(x) via the non-trivial real Dirichlet character χ modulo 4 and explicit-formula methods for the Dirichlet L-function L(s, χ): the functional equation, the non-vanishing of L(s, χ) for Re(s) ≥ 1, and an oscillation contribution from the non-trivial zeros together force the difference to take both signs infinitely often. The result is unconditional, but the analytic machinery — Riemann's explicit formula and quantitative prime-counting in arithmetic progressions — is well beyond mathlib v4.30.0. Mathlib has the elementary infrastructure used in the *statement* (`Nat.Prime`, `ZMod`, `Nat.primeCounting`, `Filter.limsup`/`liminf`, and Dirichlet's existence theorem for primes in arithmetic progressions via `Mathlib/NumberTheory/LSeries/PrimesInAP.lean`), but no Hardy–Littlewood sign-change framework; the `PrimeNumberTheoremAnd` external project still has PNT itself sorried.

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
