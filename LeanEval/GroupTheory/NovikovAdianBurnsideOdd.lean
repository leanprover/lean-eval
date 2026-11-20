import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# The Novikov–Adian Theorem on the Unbounded Burnside Problem (Odd Exponents)

William Burnside asked in 1902 whether every finitely generated periodic group of
bounded exponent is finite. P. S. Novikov and S. I. Adian (1968, *Izv. Akad. Nauk
SSSR Ser. Mat.* 32, 212–244, 251–524, 709–731) proved that the free Burnside
group $B(m, n)$ is infinite for all $m \ge 2$ and all sufficiently large odd
exponents $n$, and Adian (1975/1979, *The Burnside Problem and Identities in
Groups*, Springer) sharpened the threshold to every odd $n \ge 665$.
-/

/-- **Novikov–Adian solution of the unbounded Burnside problem for odd
exponents.** For every $m \ge 2$ and every odd $n \ge 665$, there exists an
infinite $m$-generated group of exponent dividing $n$. -/
@[eval_problem]
theorem novikov_adian_burnside_odd {m n : ℕ} (hm : 2 ≤ m) (hodd : Odd n) (hn : 665 ≤ n) :
    ∃ (G : Type) (_ : Group G),
      Infinite G ∧
      (∃ g : Fin m → G, Subgroup.closure (Set.range g) = ⊤) ∧
      ∀ x : G, x ^ n = 1 := by
  sorry

end GroupTheory
end LeanEval
