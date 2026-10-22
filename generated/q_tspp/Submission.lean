import ChallengeDeps
import Submission.Helpers

open QTSPP
open scoped BigOperators

local notation "q" => (Polynomial.X : Polynomial ℤ)

namespace Submission

theorem q_tspp (n : ℕ) :
    generatingPolynomial n *
      (∏ c ∈ sortedTriples n,
        (1 - q ^ (coordinateSum c + 1))) =
    ∏ c ∈ sortedTriples n,
      (1 - q ^ (coordinateSum c + 2)) := by
  sorry

end Submission
