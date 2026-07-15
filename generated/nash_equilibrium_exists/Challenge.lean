import ChallengeDeps

open LeanEval.GameTheory
open Set Function

theorem nash_equilibrium_exists {n : ℕ} {S : Fin n → Type*}
    [∀ i, Fintype (S i)] [∀ i, Nonempty (S i)]
    (u : Fin n → StrategyProfile n S → ℝ) :
    ∃ σ : ∀ i, S i → ℝ, IsNashEquilibrium u σ := by
  sorry
