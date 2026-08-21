import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

theorem feit_thompson {G : Type*} [Group G] [Finite G]
    (_h : Odd (Nat.card G)) : Group.IsSolvable G := by
  sorry
