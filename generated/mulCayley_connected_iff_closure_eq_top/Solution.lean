import Mathlib.Combinatorics.SimpleGraph.Cayley
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.Algebra.Group.Subgroup.Lattice
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem mulCayley_connected_iff_closure_eq_top {G : Type*} [Group G]
    (S : Set G) :
    (SimpleGraph.mulCayley S).Connected ↔ Subgroup.closure S = ⊤ := by
  exact Submission.mulCayley_connected_iff_closure_eq_top S
