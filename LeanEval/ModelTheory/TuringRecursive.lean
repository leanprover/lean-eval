import Mathlib
import EvalTools.Markers

namespace LeanEval.ModelTheory.TuringRecursive

/-!
# General recursive = Turing computable

`turing_recursive_equiv`: a total function `f : ℕ → ℕ` is recursive
(`Computable`) iff it is computed by some Turing machine (mathlib's `FinTM2`
model) under the standard binary encoding of `ℕ`. This is the Turing–Kleene
equivalence. Mathlib has both predicates and the forward direction via
`tr_eval`, but no theorem linking them; the converse (TM-computable ⇒ recursive)
is absent. Category-(b) candidate from §23 of the Knill survey.
-/

open Computability Turing

/-- **General recursive = Turing computable** (total form). A total function
`f : ℕ → ℕ` is recursive (`Computable`, i.e. partial recursive as a partial
function) **iff** it is computed by some Turing machine (mathlib's `FinTM2`
model) under the standard binary encoding of `ℕ`. This is Knill's class
equality; the backward direction (TM-computable ⇒ recursive) is absent from
mathlib. -/
@[eval_problem]
theorem turing_recursive_equiv (f : ℕ → ℕ) :
    Computable f ↔ Nonempty (TM2Computable encodeNat encodeNat f) := by
  sorry

end LeanEval.ModelTheory.TuringRecursive
