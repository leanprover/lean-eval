import ChallengeDeps
import Submission.Helpers

open LeanEval.Combinatorics

namespace Submission

theorem erdos_unit_distance_conjecture_false :
    ∃ δ : ℝ, 0 < δ ∧
      ∀ N : ℕ, ∃ (n : ℕ) (P : Finset E2),
        N ≤ n ∧ P.card = n ∧ (n : ℝ) ^ (1 + δ) ≤ (unitDist P : ℝ) := by
  sorry

end Submission
