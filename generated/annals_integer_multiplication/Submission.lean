import ChallengeDeps
import Submission.Helpers

open IntegerMultiplication
open Computability Turing Real

namespace Submission

theorem theorem_1_1 :
    ∃ T : TM2ComputableInTime (encodeProd encodeNat encodeNat) encodeNat (fun (x, y) ↦ x * y),
      (fun n ↦ (T.time n : ℝ)) =O[Filter.atTop] (fun n ↦ n * log n) := by
  sorry

end Submission
