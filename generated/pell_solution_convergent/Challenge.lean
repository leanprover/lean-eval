import Mathlib

open scoped Real

theorem pell_solution_is_convergent (d : ℤ) (_hd : Squarefree d) (_hd0 : 0 < d)
    (x y : ℤ) (_hx : 0 < x) (_hy : 0 < y)
    (_hsol : x ^ 2 - d * y ^ 2 = 1) :
    ∃ n : ℕ, (GenContFract.of (Real.sqrt (d : ℝ))).convs n = (x : ℝ) / (y : ℝ) := by
  sorry
