import ChallengeDeps

open LeanEval.Combinatorics

theorem minimal_balanceable_of_bounded (k : ℕ) (hk : 0 < k) :
    Minimal (fun n => 0 < n ∧ ∀ p : n.Partition, Bounded k p → Balanceable p) (2 * (Finset.Icc 1 k).lcm id) := by
  sorry
