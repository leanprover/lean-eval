import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

theorem weak_goldbach (n : ℕ) (hn : 5 < n) (hodd : Odd n) :
    ∃ p q r : ℕ, p.Prime ∧ q.Prime ∧ r.Prime ∧ n = p + q + r := by
  sorry
