import Mathlib
import Submission.Helpers

open Filter Finset MeasureTheory
open scoped BigOperators Topology

namespace Submission

theorem zhang_bounded_prime_gaps :
    ∀ n : ℕ, ∃ p q : ℕ, n ≤ p ∧ p.Prime ∧ q.Prime ∧ p < q ∧ q - p ≤ 246 := by
  sorry

end Submission
