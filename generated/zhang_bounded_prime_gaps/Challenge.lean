import Mathlib

open Filter Finset MeasureTheory
open scoped BigOperators Topology

theorem zhang_bounded_prime_gaps :
    ∀ n : ℕ, ∃ p q : ℕ, n ≤ p ∧ p.Prime ∧ q.Prime ∧ p < q ∧ q - p ≤ 246 := by
  sorry
