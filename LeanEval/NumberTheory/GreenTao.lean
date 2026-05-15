import EvalTools.Markers
import Mathlib.Data.Nat.Prime.Defs

/-! # Green-Tao theorem on primes in arithmetic progressions

There exist arbitrarily-long arithmetic progression of primes.

Ben Green and Terence Tao. *The primes contain arbitrarily long arithmetic progressions* (2004).
-/

/-- The *Green-Tao Theorem*: there are arbitrarily long arithmetic progressions of primes. -/
@[eval_problem]
theorem green_tao (k : ℕ) :
  ∃ p, ∃ d > 0, ∀ i < k, (p + i * d).Prime := sorry
