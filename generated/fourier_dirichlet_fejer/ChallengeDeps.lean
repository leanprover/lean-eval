import Mathlib

namespace LeanEval
namespace Analysis

/-!
# Pointwise and Cesàro convergence of Fourier series

§46 of Oliver Knill's *Some Fundamental Theorems in Mathematics*.

* **Dirichlet's pointwise convergence theorem** (main): for a `C¹` 2π-periodic
  complex function `f`, the symmetric Fourier partial sums
  `S_N(f)(x) = ∑_{n = -N}^{N} f̂_n e^{inx}` converge to `f(x)` at every `x ∈ ℝ`.
* **Fejér's theorem** (additional): for a merely *continuous* 2π-periodic `f`,
  the Cesàro means `σ_N(f) = (S_0 + ⋯ + S_N)/(N+1)` of the partial sums converge
  to `f` uniformly on `ℝ`.

mathlib has the circle, the Fourier characters, `fourierCoeffOn`, the `L²`
Fourier series, and uniform convergence under `ℓ¹`-summability
(`hasSum_fourier_series_of_summable`). It has neither the Dirichlet kernel nor
the statement that `C¹` forces pointwise convergence of the symmetric partial
sums — the `C¹` bound `|f̂_n| ≤ C/n` is not `ℓ¹`-summable, so the summable case
does not apply — and it has no Fejér kernel, Cesàro means, or Fejér theorem. The
symmetric partial-sum order `Finset.Icc (-N) N` is essential, since the Fourier
series of a `C¹` function need not converge absolutely.
-/

open Filter Topology

/-- The symmetric Fourier partial sum of `f : ℝ → ℂ` on the period `[0, 2π]`:
`S_N(f)(x) = ∑_{n = -N}^{N} f̂_n · e^{inx}`, with `f̂_n = fourierCoeffOn _ f n`. -/
noncomputable def fourierPartialSum (f : ℝ → ℂ) (N : ℕ) (x : ℝ) : ℂ :=
  ∑ n ∈ Finset.Icc (-(N : ℤ)) N,
    fourierCoeffOn Real.two_pi_pos f n * Complex.exp (Complex.I * (n : ℂ) * (x : ℂ))

/-- The Cesàro mean of the first `N + 1` Fourier partial sums:
`σ_N(f)(x) = (S_0(f)(x) + S_1(f)(x) + ⋯ + S_N(f)(x)) / (N + 1)`. -/
noncomputable def fourierCesaroMean (f : ℝ → ℂ) (N : ℕ) (x : ℝ) : ℂ :=
  (∑ k ∈ Finset.range (N + 1), fourierPartialSum f k x) / (N + 1 : ℂ)





end Analysis
end LeanEval
