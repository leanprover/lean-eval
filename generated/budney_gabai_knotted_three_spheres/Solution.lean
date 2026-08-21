import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

open scoped ContDiff Manifold
open Metric (sphere)

theorem budney_gabai_knotted_three_spheres (x₀ : sphere (0 : EuclideanSpace ℝ (Fin 2)) 1) :
    ∃ e : ℕ → sphere (0 : EuclideanSpace ℝ (Fin 4)) 1 →
        sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 ×
          sphere (0 : EuclideanSpace ℝ (Fin 4)) 1,
      (∀ n,
        Manifold.IsSmoothEmbedding
            (𝓡 3) ((𝓡 1).prod (𝓡 3)) ∞ (e n) ∧
          IsConnected (Set.range (e n))ᶜ ∧
          ∃ K : unitInterval × sphere (0 : EuclideanSpace ℝ (Fin 4)) 1 →
              sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 ×
                sphere (0 : EuclideanSpace ℝ (Fin 4)) 1,
            Continuous K ∧
              (∀ p, K (0, p) = e n p) ∧
              ∀ p, K (1, p) = (x₀, p)) ∧
        ∀ i j, i ≠ j →
          ¬ ∃ H : unitInterval × sphere (0 : EuclideanSpace ℝ (Fin 4)) 1 →
              sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 ×
                sphere (0 : EuclideanSpace ℝ (Fin 4)) 1,
            ContMDiff
                ((𝓡∂ 1).prod (𝓡 3)) ((𝓡 1).prod (𝓡 3)) ∞ H ∧
              (∀ t,
                Manifold.IsSmoothEmbedding
                  (𝓡 3) ((𝓡 1).prod (𝓡 3)) ∞ (fun p ↦ H (t, p))) ∧
              Set.range (fun p ↦ H (0, p)) = Set.range (e i) ∧
              Set.range (fun p ↦ H (1, p)) = Set.range (e j) := by
  exact Submission.budney_gabai_knotted_three_spheres x₀
