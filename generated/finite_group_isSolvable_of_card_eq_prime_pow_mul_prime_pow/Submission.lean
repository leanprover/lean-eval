import Mathlib.GroupTheory.Solvable
import Mathlib.Data.Nat.Prime.Basic
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

namespace Submission

theorem finite_group_isSolvable_of_card_eq_prime_pow_mul_prime_pow {G : Type*} [Group G] [Fintype G]
    {p q a b : ℕ}
    (hp : Nat.Prime p)
    (hq : Nat.Prime q)
    (hpq : p ≠ q)
    (hcard : Fintype.card G = p ^ a * q ^ b) :
    Group.IsSolvable G := by
  sorry

end Submission
