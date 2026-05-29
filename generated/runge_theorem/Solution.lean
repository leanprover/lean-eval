import Mathlib
import Submission

open scoped Polynomial

theorem runge (K : Set ℂ) (_hK : IsCompact K) (U : Set ℂ) (_hU : IsOpen U)
    (_hKU : K ⊆ U) (f : ℂ → ℂ) (_hf : AnalyticOnNhd ℂ f U)
    (ε : ℝ) (_hε : 0 < ε) :
    ∃ p q : ℂ[X], (∀ z ∈ K, q.eval z ≠ 0) ∧
      (∀ z ∈ K, ‖f z - p.eval z / q.eval z‖ < ε) := by
  exact Submission.runge K _hK U _hU _hKU f _hf ε _hε
