import ChallengeDeps
import Submission.Helpers

open OnApproximationOfReals
open NNReal ENNReal

namespace Submission

theorem theorem_1_1 (n : ℕ) (hn : n ≥ 2) (ξ : ℝ) (hξ : Transcendental ℚ ξ) :
    letI a : ℝ := 1 / (2 - Real.log 2)
    (ω⋆ n ξ : EReal) ≥ (a : EReal) * n := by
  sorry

end Submission
