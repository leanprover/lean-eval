import Mathlib
import EvalTools.Markers

namespace LeanEval.NumberTheory.BoundedPrimeGaps

/-!
# Bounded gaps between primes (Zhang/Maynard/Polymath)

§224 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. Zhang's
breakthrough, sharpened by Maynard and the Polymath project, shows that there
are infinitely many pairs of primes differing by at most a fixed bound; the
post-Polymath bound recorded by Knill is `246`.

mathlib has `Nat.Prime` and prime-counting estimates, but no Selberg/GPY
sieve and hence none of the bounded-gap theorems.
-/

open Filter Finset MeasureTheory
open scoped BigOperators Topology

/-- **Bounded gaps between primes.** For every `n` there is a pair of primes
`p < q` with `n ≤ p` and `q - p ≤ 246`. -/
@[eval_problem]
theorem zhang_bounded_prime_gaps :
    ∀ n : ℕ, ∃ p q : ℕ, n ≤ p ∧ p.Prime ∧ q.Prime ∧ p < q ∧ q - p ≤ 246 := by
  sorry

end LeanEval.NumberTheory.BoundedPrimeGaps
