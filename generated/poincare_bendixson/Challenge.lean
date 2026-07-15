import ChallengeDeps

open LeanEval.Dynamics
open Filter Topology Set

theorem poincare_bendixson (F : Plane → Plane) (_hF : ContDiff ℝ 1 F)
    (γ : ℝ → Plane)
    (_hγ : IsIntegralCurveOn γ (fun _ x => F x) (Set.Ici 0)) :
    ¬ Bornology.IsBounded (γ '' Set.Ici 0)
    ∨ (∃ x₀, F x₀ = 0 ∧ x₀ ∈ ⋂ s : ℝ, closure (γ '' Set.Ici s))
    ∨ (∃ T : ℝ, 0 < T ∧ ∃ β : ℝ → Plane,
        IsIntegralCurve β (fun _ x => F x) ∧
        (∀ t, β (t + T) = β t) ∧
        F (β 0) ≠ 0 ∧
        (⋂ s : ℝ, closure (γ '' Set.Ici s)) = Set.range β) := by
  sorry
