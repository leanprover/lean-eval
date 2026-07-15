import Mathlib
import EvalTools.Markers

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

/-- **Cauchy–Kovalevskaya theorem.** For analytic data `F`, `f`, `u₀`, the
quasi-linear Cauchy problem

  `uₜ(x, t) = F(x, t, u(x,t)) · ∇ₓu(x, t) + f(x, t, u(x, t))`,
  `u(x, 0) = u₀(x)`

has a unique local analytic solution: for every `x₀ ∈ ℝᵈ` there is an open
neighborhood `U` of `(x₀, 0)` and an analytic function `u : E d × ℝ → ℝ`
satisfying the PDE and the initial condition on `U`, and `u` is unique among
analytic functions on `U` with the same initial data. -/
@[eval_problem]
theorem cauchy_kovalevskaya {d : ℕ}
    (F : E d × ℝ × ℝ → E d) (f : E d × ℝ × ℝ → ℝ) (u₀ : E d → ℝ)
    (_hF : AnalyticOnNhd ℝ F univ) (_hf : AnalyticOnNhd ℝ f univ)
    (_hu₀ : AnalyticOnNhd ℝ u₀ univ) (x₀ : E d) :
    ∃ (U : Set (E d × ℝ)) (u : E d × ℝ → ℝ),
      (x₀, (0 : ℝ)) ∈ U ∧ IsOpen U ∧ AnalyticOnNhd ℝ u U ∧
      (∀ x : E d, (x, (0 : ℝ)) ∈ U → u (x, 0) = u₀ x) ∧
      (∀ p ∈ U,
        fderiv ℝ u p ((0 : E d), (1 : ℝ)) =
          fderiv ℝ u p (F (p.1, p.2, u p), (0 : ℝ)) + f (p.1, p.2, u p)) ∧
      (∀ v : E d × ℝ → ℝ, AnalyticOnNhd ℝ v U →
        (∀ x : E d, (x, (0 : ℝ)) ∈ U → v (x, 0) = u₀ x) →
        (∀ p ∈ U,
          fderiv ℝ v p ((0 : E d), (1 : ℝ)) =
            fderiv ℝ v p (F (p.1, p.2, v p), (0 : ℝ)) + f (p.1, p.2, v p)) →
        ∀ p ∈ U, u p = v p) := by
  sorry

end Analysis
end LeanEval
