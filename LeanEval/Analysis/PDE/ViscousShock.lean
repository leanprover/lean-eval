import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Analysis.Normed.Operator.NormedSpace
import Mathlib.LinearAlgebra.Charpoly.Basic
import Mathlib.FieldTheory.Separable
import Mathlib.LinearAlgebra.Eigenspace.Basic
import Mathlib.Topology.EMetricSpace.BoundedVariation
import EvalTools.Markers

namespace LeanEval
namespace Analysis
namespace PDE

/-!
# Stability of viscous shock waves.

This file proves the BV stability estimate for viscous shock waves.
-/

open Metric Filter Topology Set
open scoped NNReal Nat EReal ContDiff

local notation:arg "ℝ^" n:arg => EuclideanSpace ℝ (Fin n)

variable (n : ℕ) (A : ℝ^n → (ℝ^n →L[ℝ] ℝ^n)) (K : Set ℝ^n)

/-- `A` is uniformly smoothly hyperbolic on a `K` if `A` is smooth,
and for every `x ∈ K` it holds that `A x` has `n` real distinct eigenvalues. -/
structure IsHyperbolicOn: Prop where
  smooth : ContDiff ℝ ∞ A
  real_ev x (hx : x ∈ K) : (A x).charpoly.Splits
  distinct_ev x (hx : x ∈ K) : (A x).charpoly.Separable

/-- `u` is a global smooth solution if `u` is continuous for all `t` and `x`, smooth for
`t > 0` and solves the PDE in the classical sense for `t > 0`. -/
structure IsSmoothGlobalSolution (u : ℝ → ℝ → (ℝ^n)) : Prop where
  diff : ContDiffOn ℝ ∞ (Function.uncurry u) (Set.Ioi 0 ×ˢ Set.univ)
  cont : ContinuousOn (Function.uncurry u) (Set.Ici 0 ×ˢ Set.univ)
  pde : ∀ t > 0, ∀ x, (deriv (u · x) t) + A (u t x) (deriv (u t ·) x) =
    iteratedDeriv 2 (u · x) t

structure HasBVEstimateWith (δ C : EReal) : Prop where
  estimate u (h_sol : IsSmoothGlobalSolution n A u)
      (h_initial_bv : eVariationOn (u 0 ·) Set.univ ≤ δ)
      (h_initial_lim : ∃ x ∈ K, Tendsto (u 0 ·) atBot (𝓝 x))
      t (ht : t > 0) : eVariationOn (u t ·) univ ≤ C * eVariationOn (u 0 ·) univ

theorem a_priori_bv_estimate (hn : 1 ≤ n) (hK : IsCompact K) (h : IsSmoothHyperbolicOn n A K) :
    ∃ δ > 0, ∃ C < ⊤, HasBVEstimateWith n A K δ C :=
  sorry

end PDE
end Analysis
end LeanEval
