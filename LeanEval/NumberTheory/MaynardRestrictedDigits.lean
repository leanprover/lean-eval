import Mathlib.Data.Nat.Digits.Defs
import Mathlib.Data.Nat.Prime.Defs
import Mathlib.Data.Set.Finite.Basic
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Maynard's Theorem on Primes with Restricted Digits

James Maynard (2019, *Primes with restricted digits*, *Invent. Math.* 217,
127–218, Theorem 1.1; Fields Medal 2022) proved that for every decimal digit
$d \in \{0, 1, \dots, 9\}$, there are infinitely many prime numbers whose
base-$10$ expansion omits the digit $d$ (with the sharpest asymptotic count
$\asymp x^{\log 9 / \log 10} / \log x$).
-/

/-- **Maynard's missing-digit primes theorem.** For every decimal digit
$d \in \{0, \dots, 9\}$, infinitely many prime numbers omit $d$ in their
base-$10$ expansion. -/
@[eval_problem]
theorem maynard_primes_restricted_digits {d : ℕ} (hd : d < 10) :
    {p : ℕ | p.Prime ∧ d ∉ Nat.digits 10 p}.Infinite := by
  sorry

end NumberTheory
end LeanEval
