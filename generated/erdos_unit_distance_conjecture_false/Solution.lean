import ChallengeDeps
import Submission

open LeanEval.Combinatorics

theorem erdos_unit_distance_conjecture_false :
    ∃ δ : ℝ, 0 < δ ∧
      ∀ N : ℕ, ∃ (n : ℕ) (P : Finset E2),
        N ≤ n ∧ P.card = n ∧ (n : ℝ) ^ (1 + δ) ≤ (unitDist P : ℝ) := by
  exact Submission.erdos_unit_distance_conjecture_false
