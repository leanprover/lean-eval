import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.Topology.MetricSpace.Lipschitz
import EvalTools.Markers

namespace LeanEval
namespace Analysis
namespace PDE

/-!
# Radial symmetry for a semilinear Poisson equation

Suppose `u` is a positive solution to a semilinear Poisson PDE:

  `-Δ u = f(u)` in the open unit ball,
  `u = 0` on the boundary.

For Lipschitz `f`, every `C^2` solution on the closed ball is radial and
strictly decreasing as a function of the radius.
-/

open Metric
open scoped NNReal

/-- `u` solved a semilinear Poisson problem if `-Δ u = f(u)` in the open unit
ball and `u = 0` on the unit sphere. -/
def SolvesSemilinearPoisson {n : ℕ} (f : ℝ → ℝ) (u : EuclideanSpace ℝ (Fin n) → ℝ) : Prop :=
  (∀ x ∈ ball 0 1, -Laplacian.laplacian u x = f (u x)) ∧ ∀ x ∈ sphere 0 1, u x = 0

/-- **Radial symmetry theorem.** Let `u ∈ C^2(closedBall 0 1)` be a positive
solution of the semilinear Poisson problem `-Δ u = f(u)` in the open unit ball,
with zero Dirichlet boundary values on the unit sphere. If `f : ℝ → ℝ` is
Lipschitz, then `u` is radial: `u x = v ‖x‖` for a nonnegative strictly
decreasing radial profile `v` on `[0, 1]`. -/
@[eval_problem]
theorem semilinear_poisson_radial_symmetry {n : ℕ} (hn : 0 < n)
    {f : ℝ → ℝ} (u : EuclideanSpace ℝ (Fin n) → ℝ)
    (hf_lipschitz : ∃ K : ℝ≥0, LipschitzWith K f)
    (hu_c2 : ContDiffOn ℝ 2 u (closedBall 0 1))
    (hu_solve : SolvesSemilinearPoisson f u)
    (hu_positive : ∀ x ∈ ball 0 1, 0 < u x) :
    ∃ v : ℝ → ℝ≥0,
      StrictAntiOn v (Set.Icc (0 : ℝ) 1) ∧
        ∀ x ∈ closedBall 0 1, u x = v ‖x‖ := by
  sorry

end PDE
end Analysis
end LeanEval
