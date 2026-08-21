import Mathlib.Data.Finite.Defs
import Mathlib.GroupTheory.Commutator.Basic
import Mathlib.GroupTheory.Subgroup.Simple
import Lake.Toml
import Lake.Util.Message
import Lean

theorem ore_conjecture (G : Type*) [Group G] [Finite G] [IsSimpleGroup G]
    (hG : ¬ IsMulCommutative G) :
    commutatorSet G = Set.univ := by
  sorry
