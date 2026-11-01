import Mathlib.Basic.Finite.Defs
import Mathlib.GroupTheory.Commutator.Basic
import Mathlib.GroupTheory.Subgroup.Simple

theorem ore_conjecture (G : Type*) [Group G] [Finite G] [IsSimpleGroup G]
    (hG : ¬ IsMulCommutative G) :
    commutatorSet G = Set.univ := by
  sorry
