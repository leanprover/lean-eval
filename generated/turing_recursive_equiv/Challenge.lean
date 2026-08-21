import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

open Computability Turing

theorem turing_recursive_equiv (f : ℕ → ℕ) :
    Computable f ↔ Nonempty (TM2Computable encodeNat encodeNat f) := by
  sorry
