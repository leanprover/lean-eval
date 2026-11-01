import Mathlib
import Submission

open Computability Turing

theorem turing_recursive_equiv (f : ℕ → ℕ) :
    Computable f ↔ Nonempty (TM2Computable encodeNat encodeNat f) := by
  exact Submission.turing_recursive_equiv f
