/-
Copyright (c) 2025 Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Katerina Hristova
-/

import Mathlib.GroupTheory.QuotientGroup.Defs
import Mathlib.Data.ENat.Lattice
import EvalTools.Markers

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

/--
Statement of Theorem 1:

Let `G` be a finite group. Then the spread `s(G) ≥ 2` if and only if every proper quotient of `G`
is cyclic.
-/
@[eval_problem]
theorem theorem_1 (G : Type*) [Group G] [Finite G] :
    s G ≥ 2 ↔ ∀ (N : Subgroup G) [N.Normal] [Nontrivial N], IsCyclic (G ⧸ N) := by
  sorry

end SpreadOfAFiniteGroup
