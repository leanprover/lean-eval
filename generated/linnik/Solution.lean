import ChallengeDeps
import Submission

open LeanEval.NumberTheory.Linnik

theorem linnik : ∃ c : ℝ, ∀ ⦃a d : ℕ⦄,
    0 < a → a < d → a.Coprime d → p a d ≤ c * d ^ (5.5 : ℝ) := by
  exact Submission.linnik
