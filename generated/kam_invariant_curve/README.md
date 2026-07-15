# `kam_invariant_curve`

KAM persistence of an invariant curve

- Problem ID: `kam_invariant_curve`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Kolmogorov–Arnold–Moser for a twist map: for Diophantine α and real-analytic, 1-periodic, non-constant, mean-zero f, for small |c| the functional equation q(t+α)−2q(t)+q(t−α) = c·f(q(t)) has a smooth strictly increasing solution with q−id periodic — the c=0 invariant curve persists. The linearisation is non-invertible (small divisors), so the IFT fails and the Diophantine condition drives a Newton/Nash–Moser scheme. The trusted helper IsDiophantine is a non-hole. Mathlib has no KAM theory (no twist maps, invariant curves, small divisors, Nash–Moser). Candidate from §83 of the Knill survey.
- Source: A. N. Kolmogorov (1954); V. I. Arnold (1963); J. Moser, *On invariant curves of area-preserving mappings of an annulus*, Nachr. Akad. Wiss. Göttingen (1962). Knill, *Some fundamental theorems in mathematics*, §83.
- Informal solution: KAM via a Newton/Nash–Moser iteration with small-divisor control. Linearise the functional operator F(q) = q(·+α) − 2q + q(·−α) − c·f∘q at the approximate solution; the constant-coefficient part L u = u(·+α) − 2u + u(·−α) is diagonal in Fourier with symbol 2cos(2πnα) − 2, invertible off n = 0 with inverse bounded by the Diophantine estimate |2cos(2πnα)−2|⁻¹ ≲ |n|²/C. Run a quadratically-convergent Newton scheme on a scale of analyticity-shrinking norms (Cauchy estimates absorb the polynomial small-divisor loss), solving the cohomological equation at each step after projecting out the mean (using f mean-zero), and control the analyticity-width loss so the iteration converges for |c| < c₀ to a real-analytic q with q−id periodic and StrictMono.

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
