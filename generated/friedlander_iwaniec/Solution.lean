import Mathlib
import Submission

theorem friedlander_iwaniec : {p : ℕ | p.Prime ∧ ∃ a b, p = a ^ 2 + b ^ 4}.Infinite := by
  exact Submission.friedlander_iwaniec
