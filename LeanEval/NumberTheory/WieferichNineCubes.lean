import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Wieferich's theorem `g(3) = 9`

`wieferich_g_three` is Wieferich's theorem (Wieferich 1909, completed by
Kempner 1912): every natural number is a sum of nine cubes, and nine is the
smallest such bound — `23` requires nine cubes (`23 = 2·2³ + 7·1³`, with no
representation using eight or fewer cubes). This is the `k = 3` case of the
Hilbert–Waring problem (`g(3) = 9`).

Mathlib has Lagrange's four-square theorem (`Nat.sum_four_squares`) but no
Hilbert–Waring material: no `g(k)`, no "sum of `k` cubes" predicate, and no
`g(3) = 9`. The trusted helper `IsSumOfCubes` (a non-hole) fixes the meaning of
"sum of `k` cubes".

This is a category-(b) candidate from §76 of the Knill survey
(`sections/076-four-square-theorem.md`).
-/

/-- An integer `n` is a **sum of `k` cubes** if `n = x₁³ + ⋯ + x_k³` for some
natural numbers `x₁, …, x_k`. -/
def IsSumOfCubes (k n : ℕ) : Prop :=
  ∃ x : Fin k → ℕ, ∑ i, (x i) ^ 3 = n

/-- **Wieferich's theorem `g(3) = 9`.** Every natural number is a sum of nine
cubes, and nine is necessary: some `n` (namely `23`) is not a sum of eight
cubes. -/
@[eval_problem]
theorem wieferich_g_three :
    (∀ n : ℕ, IsSumOfCubes 9 n) ∧ ∃ n : ℕ, ¬ IsSumOfCubes 8 n := by
  sorry

end NumberTheory
end LeanEval
