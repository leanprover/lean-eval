import ChallengeDeps
import Submission

open LeanEval.Combinatorics
open scoped Classical

theorem unit_distance_upper_bound :
    ∃ C : ℝ, 0 < C ∧
      ∀ P : Finset E2, (unitDist P : ℝ) ≤ C * (P.card : ℝ) ^ ((4 : ℝ) / 3) := by
  exact Submission.unit_distance_upper_bound
