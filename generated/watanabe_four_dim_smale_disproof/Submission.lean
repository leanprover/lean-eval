import Mathlib
import Submission.Helpers

open scoped Manifold ContDiff
open Metric (sphere)

namespace Submission

theorem watanabe_four_dim_smale_disproof :
    ¬ (∀ {n : ℕ} [NeZero n]
        (X : Type) [TopologicalSpace X] [T2Space X] [SecondCountableTopology X]
        [ChartedSpace (EuclideanHalfSpace n) X] [IsManifold (𝓡∂ n) ∞ X]
        [CompactSpace X]
        (F F' : X × sphere (0 : EuclideanSpace ℝ (Fin 5)) 1 →
                sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
        ContMDiff ((𝓡∂ n).prod (𝓡 4)) (𝓡 4) ∞ F →
        ContMDiff ((𝓡∂ n).prod (𝓡 4)) (𝓡 4) ∞ F' →
        (∀ x p, F  (x, F' (x, p)) = p) →
        (∀ x p, F' (x, F  (x, p)) = p) →
        ∀ (ψ_bdry : (𝓡∂ n).boundary X → Matrix.orthogonalGroup (Fin 5) ℝ),
        Continuous ψ_bdry →
        (∀ (b : (𝓡∂ n).boundary X)
           (p : sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
              (F ((b : X), p) : EuclideanSpace ℝ (Fin 5)) =
                Matrix.UnitaryGroup.toLinearEquiv (ψ_bdry b)
                  (p : EuclideanSpace ℝ (Fin 5))) →
        ∃ (ψ : X → Matrix.orthogonalGroup (Fin 5) ℝ)
          (H H' : X × unitInterval × sphere (0 : EuclideanSpace ℝ (Fin 5)) 1 →
                  sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
          Continuous ψ ∧
          (∀ b : (𝓡∂ n).boundary X, ψ (b : X) = ψ_bdry b) ∧
          ContMDiff ((𝓡∂ n).prod ((𝓡∂ 1).prod (𝓡 4))) (𝓡 4) ∞ H ∧
          ContMDiff ((𝓡∂ n).prod ((𝓡∂ 1).prod (𝓡 4))) (𝓡 4) ∞ H' ∧
          (∀ x t p, H  (x, t, H' (x, t, p)) = p) ∧
          (∀ x t p, H' (x, t, H  (x, t, p)) = p) ∧
          (∀ x p, H (x, 0, p) = F (x, p)) ∧
          (∀ x (p : sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
              (H (x, 1, p) : EuclideanSpace ℝ (Fin 5)) =
              Matrix.UnitaryGroup.toLinearEquiv (ψ x)
                (p : EuclideanSpace ℝ (Fin 5))) ∧
          (∀ (b : (𝓡∂ n).boundary X)
             (t : unitInterval)
             (p : sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
              H ((b : X), t, p) = F ((b : X), p))) := by
  sorry

end Submission
