import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.Topology.MetricSpace.Lipschitz
import EvalTools.Markers

namespace LeanEval
namespace Analysis
namespace PDE

/-!
# Radial symmetry for a semilinear Poisson equation

This benchmark formalizes the Gidas-Ni-Nirenberg radial symmetry theorem for
positive solutions of the semilinear Dirichlet problem on a ball:

  `-Δ u = f(u)` in the open unit ball,
  `u = 0` on the boundary,
  `u > 0` in the open unit ball.

For Lipschitz `f`, every `C^2` solution on the closed ball is radial and
strictly decreasing as a function of the radius.
-/

noncomputable section

open scoped NNReal

/-- The model space `R^n`. -/
abbrev E (n : ℕ) :=
  EuclideanSpace ℝ (Fin n)

/-- The open unit ball in `R^n`. -/
def unitBall (n : ℕ) : Set (E n) :=
  Metric.ball 0 1

/-- The closed unit ball in `R^n`. -/
def closedUnitBall (n : ℕ) : Set (E n) :=
  Metric.closedBall 0 1

/-- The unit sphere, i.e. the boundary of the unit ball in `R^n`. -/
def unitSphere (n : ℕ) : Set (E n) :=
  Metric.sphere 0 1

/-- The semilinear Poisson-Dirichlet problem
`-Δ u = f(u)` in the open unit ball and `u = 0` on the unit sphere. -/
def SolvesSemilinearPoissonDirichlet {n : ℕ} (f : ℝ → ℝ) (u : E n → ℝ) : Prop :=
  (∀ x ∈ unitBall n, -Laplacian.laplacian u x = f (u x)) ∧
    ∀ x ∈ unitSphere n, u x = 0

/-- `u` is represented on the closed unit ball by a nonnegative strictly
decreasing radial profile. -/
def RadialStrictDecreasingOnUnitBall {n : ℕ} (u : E n → ℝ) : Prop :=
  ∃ v : ℝ → ℝ,
    StrictAntiOn v (Set.Icc (0 : ℝ) 1) ∧
      (∀ r ∈ Set.Icc (0 : ℝ) 1, 0 ≤ v r) ∧
        ∀ x ∈ closedUnitBall n, u x = v ‖x‖

/-- **Radial symmetry theorem.** Let `u ∈ C^2(closed unit ball)` be a positive
solution of the semilinear Poisson problem `-Δ u = f(u)` in the open unit ball,
with zero Dirichlet boundary values on the unit sphere. If `f : R → R` is
Lipschitz, then `u` is radial: `u x = v ‖x‖` for a nonnegative strictly
decreasing radial profile `v` on `[0, 1]`. -/
@[eval_problem]
theorem semilinear_poisson_radial_symmetry {n : ℕ} (hn : 0 < n)
    (f : ℝ → ℝ) (u : E n → ℝ)
    (hf_lipschitz : ∃ K : ℝ≥0, LipschitzWith K f)
    (hu_c2 : ContDiffOn ℝ 2 u (closedUnitBall n))
    (hu_problem : SolvesSemilinearPoissonDirichlet f u)
    (hu_positive : ∀ x ∈ unitBall n, 0 < u x) :
    RadialStrictDecreasingOnUnitBall u := by
  sorry

end

end PDE
end Analysis
end LeanEval
