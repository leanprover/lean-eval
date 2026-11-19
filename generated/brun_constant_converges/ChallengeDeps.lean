import Mathlib

namespace LeanEval.NumberTheory.BrunConstant

/-!
# Brun's theorem (convergence of the twin-prime reciprocal sum)

§224 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. Brun's
theorem states that the sum of the reciprocals of the twin primes converges,
to a value now known as Brun's constant.

mathlib has `Nat.Prime`, `Summable`, and prime-counting estimates, but no
Brun sieve and hence no proof of this convergence.
-/

open Filter Finset MeasureTheory
open scoped BigOperators Topology

/-- A twin-prime start is a prime `p` such that `p + 2` is also prime. -/
def IsTwinPrimeStart (p : ℕ) : Prop :=
  p.Prime ∧ (p + 2).Prime

/-- The reciprocal contribution of the twin pair beginning at `p`.

This counts each pair once, by its smaller prime. -/
noncomputable def twinPrimeReciprocalTerm (p : ℕ) : ℝ :=
  by
    classical
    exact if IsTwinPrimeStart p then (1 / (p : ℝ)) + (1 / ((p + 2 : ℕ) : ℝ)) else 0



end LeanEval.NumberTheory.BrunConstant
