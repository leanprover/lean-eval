import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.Linnik

namespace Submission

theorem linnik : ∃ c : ℝ, ∀ ⦃a d : ℕ⦄,
    0 < a → a < d → a.Coprime d → p a d ≤ c * d ^ (5.5 : ℝ) := by
  sorry

end Submission
