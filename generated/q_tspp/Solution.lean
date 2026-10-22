import ChallengeDeps
import Submission

open QTSPP
open scoped BigOperators

local notation "q" => (Polynomial.X : Polynomial ℤ)

theorem q_tspp (n : ℕ) :
    generatingPolynomial n *
      (∏ c ∈ sortedTriples n,
        (1 - q ^ (coordinateSum c + 1))) =
    ∏ c ∈ sortedTriples n,
      (1 - q ^ (coordinateSum c + 2)) := by
  exact Submission.q_tspp n
