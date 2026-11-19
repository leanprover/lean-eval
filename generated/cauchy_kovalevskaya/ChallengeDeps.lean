import Mathlib

namespace LeanEval
namespace Analysis

/-!
# Cauchy–Kovalevskaya theorem

§32 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. For
analytic data `F`, `f`, `u₀`, the quasi-linear scalar Cauchy problem

  `uₜ(x, t) = F(x, t, u(x,t)) · ∇ₓu(x, t) + f(x, t, u(x, t))`,
  `u(x, 0) = u₀(x)`

has a unique local analytic solution near every point of the initial
hypersurface `t = 0`.

The statement uses only off-the-shelf mathlib (`AnalyticOnNhd`, `fderiv`,
`EuclideanSpace`); mathlib has no Cauchy–Kovalevskaya theorem. The PDE is
encoded through the Fréchet derivative: `fderiv ℝ u p (0, 1)` is `∂u/∂t`
and `fderiv ℝ u p (v, 0)` is the spatial directional derivative along `v`,
so `fderiv ℝ u p (F-data, 0)` is `F · ∇ₓu`. Locality and uniqueness are
folded into a single `∀ x₀, ∃ U …` statement.
-/

open Set

/-- The model space `ℝᵈ`. -/
abbrev E (d : ℕ) := EuclideanSpace ℝ (Fin d)



end Analysis
end LeanEval
