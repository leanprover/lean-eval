import Mathlib.GroupTheory.QuotientGroup.Defs
import Mathlib.Data.ENat.Lattice
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from The spread of a finite group

We formalise the statement of the main result from T. C. Burness, R. M. Guralnick, and S. Harper,
`The spread of a finite group`, Annals of Math, 193 (2) 2021.
-/

set_option autoImplicit false

namespace SpreadOfAFiniteGroup

/-- Let `G` be a group. The spread `s G` of `G` is the largest integer `k` such that for any
non-trivial elements `x_1, ..., x_k` in `G`, there exists `y ∈ G` with `G = ⟨x_i, y⟩` for
all `i`. -/
noncomputable def s (G : Type*) [Group G] : ℕ∞ :=
  sSup ((↑) '' {k : ℕ | ∀ x : Fin k → G, 1 ∉ Set.range x → ∃ y, ∀ i, Subgroup.closure {x i, y} = ⊤})



end SpreadOfAFiniteGroup
