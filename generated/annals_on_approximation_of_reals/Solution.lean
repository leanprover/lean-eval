import ChallengeDeps
import Submission

open OnApproximationOfReals
open NNReal ENNReal

theorem theorem_1_1 (n : ℕ) (hn : n ≥ 2) (ξ : ℝ) (hξ : Transcendental ℚ ξ) :
    letI a : ℝ := 1 / (2 - Real.log 2)
    (ω⋆ n ξ : EReal) ≥ (a : EReal) * n := by
  exact Submission.theorem_1_1 n hn ξ hξ
