import Mathlib
import Submission

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem variable_binder_example (A : Matrix n n ℚ) (hA : A.IsHermitian) :
    A.trace = ∑ i, A i i := by
  exact Submission.variable_binder_example A hA
