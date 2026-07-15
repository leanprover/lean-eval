# `poincare_siegel_linearisation`

Poincaré–Siegel linearisation theorem

- Problem ID: `poincare_siegel_linearisation`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Siegel 1942: a holomorphic germ f near 0 with f 0 = 0 and multiplier λ = e^{2πiα} (α Diophantine) is locally analytically conjugate to z ↦ λz. The conjugating germ u satisfies u 0 = 0, u'(0) = 1, and f(u z) = u(λ z) near 0 (Schröder equation). The file ships an IsDiophantine predicate parameterised by an arbitrary exponent τ (∃ C, ∃ τ, ∀ p q ≠ 0, C / |q|^τ ≤ |α − p/q|); the constant-type / exponent-2 condition is the special case fixing τ = 2.
- Source: C. L. Siegel, *Iteration of analytic functions*, Annals of Math. 43 (1942), 607-612. Earlier formal-power-series version: H. Poincaré thèse (1879). Listed as §83 (additional statement 1) in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Construct the formal Schröder series u(z) = ∑ uₙ zⁿ from the conjugacy equation f(u z) = u(λ z), giving the recursion (λⁿ − λ) uₙ = (lower-order polynomial in u_{<n} and f_{≥2}). An arithmetic condition on the rotation number is essential to control the small divisors (λⁿ − 1); the Diophantine hypothesis gives a polynomial lower bound |λⁿ − 1| ≥ c n^{-(τ−1)} that is summable against Cauchy estimates. Siegel's geometric majorant-series argument bounds u by an explicit analytic envelope of positive radius of convergence.

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
