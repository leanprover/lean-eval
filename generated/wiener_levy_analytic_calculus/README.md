# `wiener_levy_analytic_calculus`

Wiener–Lévy theorem

- Problem ID: `wiener_levy_analytic_calculus`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The Wiener–Lévy theorem, the analytic functional calculus for the Wiener algebra: if f lies in the Wiener algebra (`InWienerAlgebra f := Summable (fourierCoeff f)`) and φ is complex-analytic on an open neighbourhood U of the range of f, then the composition φ ∘ f again lies in the Wiener algebra. Generalizes Wiener's 1/f theorem (take φ(z) = 1/z). mathlib has the additive circle, `fourier`, `fourierCoeff`, and `hasSum_fourier_series_of_summable`, but not the Wiener algebra or its functional calculus.
- Source: P. Lévy, Sur la convergence absolue des séries de Fourier, Compositio Math. 1 (1935), 1-14; N. Wiener, Tauberian theorems, Ann. of Math. 33 (1932), 1-100. Listed as §226 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §226.
- Informal solution: This is the holomorphic functional calculus in the commutative Banach algebra A(T). Since the Gelfand spectrum of A(T) is the circle (Wiener's lemma), the range of f as an algebra element equals its pointwise range, which lies in U. For φ analytic on U, define φ(f) by the Cauchy integral φ(f) = (1/2πi) ∮_Γ φ(z) (z - f)⁻¹ dz over a contour Γ in U enclosing the range of f; each resolvent (z - f)⁻¹ exists in A(T) by Wiener's lemma, the integral converges in the Banach algebra norm, and the result agrees pointwise with φ ∘ f, hence has summable Fourier coefficients.

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
