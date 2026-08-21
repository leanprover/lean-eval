import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem variable_binder_example (A : Matrix n n ℚ) (hA : A.IsHermitian) :
    A.trace = ∑ i, A i i := by
  sorry
