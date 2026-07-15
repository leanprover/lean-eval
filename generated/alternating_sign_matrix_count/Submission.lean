import ChallengeDeps
import Submission.Helpers

open LeanEval.Combinatorics.AlternatingSignMatrix
open Matrix
open scoped BigOperators

namespace Submission

theorem alternating_sign_matrix_count (n : ℕ) :
    (Nat.card (ASMatrix n) : ℚ) = robbinsProduct n := by
  sorry

end Submission
