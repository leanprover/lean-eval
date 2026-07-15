import Mathlib
import Submission

theorem feit_thompson {G : Type*} [Group G] [Finite G]
    (_h : Odd (Nat.card G)) : IsSolvable G := by
  exact Submission.feit_thompson _h
