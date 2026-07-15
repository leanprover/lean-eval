import Mathlib

namespace LeanEval
namespace NumberTheory
namespace ChebyshevSignChangeProblem

/-!
# Hardy–Littlewood sign-change for the prime race mod 4

The difference `π₃(n) − π₁(n)` between the number of primes `≤ n` in
residue class `3 mod 4` and in residue class `1 mod 4` changes sign
infinitely often: both `{n : π₃(n) > π₁(n)}` and
`{n : π₁(n) > π₃(n)}` are infinite. Hardy–Littlewood 1914
(unconditional). §106 in Knill's *Some Fundamental Theorems in
Mathematics* (boxed under "strong law of small numbers"; the named
unconditional content is this Hardy–Littlewood sign-change theorem).

Chebyshev observed (1853) that `π₃` is "usually" ahead of `π₁` — the
**Chebyshev bias** — but Hardy–Littlewood showed unconditionally that
`π₁` overtakes infinitely often.
-/

open Filter

/-- The number of primes `p ≤ n` in the residue class `a mod 4`. -/
noncomputable def primeCountingMod (a : ZMod 4) (n : ℕ) : ℕ :=
  ((Finset.range (n + 1)).filter (fun p => Nat.Prime p ∧ (p : ZMod 4) = a)).card

/-- The set of `n` for which there are strictly more primes `≡ 3 mod 4`
than primes `≡ 1 mod 4` in `{2, 3, …, n}`. -/
def chebyshevLead : Set ℕ :=
  {n : ℕ | primeCountingMod 1 n < primeCountingMod 3 n}



end ChebyshevSignChangeProblem
end NumberTheory
end LeanEval
