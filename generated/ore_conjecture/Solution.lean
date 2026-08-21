import Mathlib.Data.Finite.Defs
import Mathlib.GroupTheory.Commutator.Basic
import Mathlib.GroupTheory.Subgroup.Simple
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem ore_conjecture (G : Type*) [Group G] [Finite G] [IsSimpleGroup G]
    (hG : ¬ IsMulCommutative G) :
    commutatorSet G = Set.univ := by
  exact Submission.ore_conjecture G hG
