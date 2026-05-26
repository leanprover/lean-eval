import ChallengeDeps
import Submission.Helpers

open LeanEval.Combinatorics
open scoped Classical

namespace Submission

theorem unit_distance_upper_bound :
    ∃ C : ℝ, 0 < C ∧
      ∀ P : Finset E2, (unitDist P : ℝ) ≤ C * (P.card : ℝ) ^ ((4 : ℝ) / 3) := by
  sorry

end Submission
