import Mathlib

open scoped Polynomial

theorem mergelyan (K : Set ℂ) (_hK : IsCompact K) (_hKc : IsConnected (Kᶜ))
    (f : ℂ → ℂ) (_hfc : ContinuousOn f K) (_hfh : AnalyticOnNhd ℂ f (interior K))
    (ε : ℝ) (_hε : 0 < ε) :
    ∃ p : ℂ[X], ∀ z ∈ K, ‖f z - p.eval z‖ < ε := by
  sorry
