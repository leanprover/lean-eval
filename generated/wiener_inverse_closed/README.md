# `wiener_inverse_closed`

Wiener's 1/f theorem

- Problem ID: `wiener_inverse_closed`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Wiener's lemma for the circle algebra: if a continuous function f on the additive circle has absolutely summable Fourier coefficients (i.e. lies in the Wiener algebra, `InWienerAlgebra f := Summable (fourierCoeff f)`) and is nowhere zero, then its pointwise reciprocal 1/f again belongs to the Wiener algebra. mathlib has the additive circle, `fourier`, `fourierCoeff`, and `hasSum_fourier_series_of_summable`, but not the Wiener algebra or spectral invariance.
- Source: N. Wiener, Tauberian theorems, Ann. of Math. 33 (1932), 1-100. Listed as §226 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §226.
- Informal solution: The Wiener algebra A(T) is the Banach algebra of absolutely convergent Fourier series with the l¹ norm of the coefficients. Wiener's lemma is the statement that its Gelfand spectrum is exactly the circle (point evaluations), so an element is invertible in A(T) iff it never vanishes. The classical elementary proof (Gelfand's gives it via Banach-algebra theory; Newman's gives a direct localization) covers the circle by short arcs, on each of which f is close to a nonzero constant, inverts a local truncation whose remainder has small Wiener norm, and patches with a smooth partition of unity, using that 1/(1-h) = ∑ hⁿ converges in A(T) when ‖h‖ < 1.

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
