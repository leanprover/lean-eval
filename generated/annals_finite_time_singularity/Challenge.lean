import ChallengeDeps

open FiniteTimeSingularity
open Set Gradient Matrix Filter Topology

local notation "ℝ³" => EuclideanSpace ℝ (Fin 3)
local notation u "·∇ₓ" v => directionalDeriv v u
local notation "∂ₜ" u => timeDeriv u
local notation "∇ₓ" p => spaceGrad p
local notation "∇×" u => vorticity u

theorem theorem_1 :
    ∃ α > 0, ∃ u₀, div u₀ = 0 ∧ IsOdd u₀ ∧ IsContDiffHolder ℝ α u₀ ∧
      (∃ C > 0, ∀ x, ‖(∇×u₀) x‖ ≤ C / (‖x‖ ^ (α : ℝ) + 1)) ∧
        ∃ p, ∃ u, (∀ t ∈ Ico 0 1, IsOdd (u · t)) ∧
            IsLocalEulerEquationSolution p u₀ 1 u ∧
              (∀ T ∈ Ioo 0 1, IsContDiffHolderOn ℝ α u.uncurry (univ ×ˢ Icc 0 T)) ∧
                Tendsto (fun t ↦ ∫ s in 0..t, ⨆ x, ‖(∇×(u · s)) x‖) (𝓝[<] 1) atTop := by
  sorry
