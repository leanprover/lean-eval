import ChallengeDeps
import Submission

open LeanEval.Combinatorics.AlternatingSignMatrix
open Matrix
open scoped BigOperators

theorem alternating_sign_matrix_count (n : ℕ) :
    (Nat.card (ASMatrix n) : ℚ) = robbinsProduct n := by
  exact Submission.alternating_sign_matrix_count n
