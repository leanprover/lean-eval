import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# Ivanov's Solution of the Unbounded Burnside Problem for Even Exponents

Resolving the long-standing even-exponent case of Burnside's 1902 bounded
exponent problem (where involutions force fundamentally non-cyclic finite
subgroups such as dihedral subgroups), Sergei V. Ivanov (1994, *Internat. J.
Algebra Comput.* 4, 1–308; see also Igor G. Lysenok 1996, *Izv. Math.* 60,
453–654) proved that for every $m \ge 2$ and every integer $n \ge 2^{48}$
divisible by $2^9$, the free Burnside group $B(m, n)$ is infinite.
-/

/-- **Ivanov's solution of the unbounded Burnside problem for even exponents.**
For every $m \ge 2$ and every $n \ge 2^{48}$ divisible by $2^9$, there exists an
infinite $m$-generated group of exponent dividing $n$. -/
@[eval_problem]
theorem ivanov_burnside_even {m n : ℕ} (hm : 2 ≤ m) (hn : 2 ^ 48 ≤ n) (hdvd : 2 ^ 9 ∣ n) :
    ∃ (G : Type) (_ : Group G),
      Infinite G ∧
      (∃ g : Fin m → G, Subgroup.closure (Set.range g) = ⊤) ∧
      ∀ x : G, x ^ n = 1 := by
  sorry

end GroupTheory
end LeanEval
