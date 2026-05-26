import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Green–Tao theorem

§37 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. The set
of primes contains arbitrarily long arithmetic progressions: for every `k`
there exist `a ≥ 0` and `b ≥ 1` such that `a + b · j` is prime for every
`j < k`.

mathlib has Dirichlet's theorem (`Nat.infinite_setOf_prime_and_modEq`) and
Roth's theorem on 3-APs (`roth_3ap_theorem_nat`) but **not** the
Green–Tao theorem. As of 2026 it has not been formalized in any major
proof assistant (a long-standing open formalization target).
-/

/-- A set `A ⊆ ℕ` contains **arbitrarily long arithmetic progressions** if
for every length `k` there is an AP `{a + b·j | j < k}` of common
difference `b ≥ 1` entirely contained in `A`. -/
def ContainsArbitraryAPs (A : Set ℕ) : Prop :=
  ∀ k : ℕ, ∃ a b : ℕ, 1 ≤ b ∧ ∀ j : ℕ, j < k → a + b * j ∈ A

/-- **Green–Tao theorem.** The set of primes contains arbitrarily long
arithmetic progressions. -/
@[eval_problem]
theorem green_tao : ContainsArbitraryAPs {p : ℕ | Nat.Prime p} := by
  sorry

end NumberTheory
end LeanEval
