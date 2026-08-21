import ChallengeDeps
import Submission.Helpers

open vanDerWaerdenConjecture
open Function Polynomial Filter

namespace Submission

theorem theorem_1 (n : ℕ) (hn : 3 ≤ n) :
    (fun H ↦ (E n H : ℝ)) =O[atTop] (fun H ↦ (H ^ (n - 1) : ℝ)) := by
  sorry

end Submission
