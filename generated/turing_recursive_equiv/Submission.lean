import Mathlib
import Submission.Helpers

open Computability Turing

namespace Submission

theorem turing_recursive_equiv (f : ℕ → ℕ) :
    Computable f ↔ Nonempty (TM2Computable encodeNat encodeNat f) := by
  sorry

end Submission
