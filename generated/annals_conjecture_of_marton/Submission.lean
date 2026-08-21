import ChallengeDeps
import Submission.Helpers

open ConjectureOfMarton
open Pointwise

variable (n : ℕ)

namespace Submission

theorem theorem_1_2 (A : Set (F n)) (K : ℝ) (h₀ : A.Nonempty) (h : (A + A).ncard ≤ K * A.ncard) :
    ∃ H : AddSubgroup (F n), Nat.card H ≤ A.ncard ∧ CovByVAdd (F n) (2 * K ^ 12) A H := by
  sorry

end Submission
