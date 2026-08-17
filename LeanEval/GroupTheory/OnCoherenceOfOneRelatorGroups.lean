/-
Copyright (c) 2025 Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Katerina Hristova
-/

import Mathlib.Algebra.Module.FinitePresentation
import Mathlib.GroupTheory.FinitelyPresentedGroup
import EvalTools.Markers

/-!
# Main Statement from On the coherence of one-relator groups and their group algebras

We formalise the statement of the main result from A. Jaikin-Zapirain and M. Linton,
`On the coherence of one-relator groups and their group algebras`, Annals of Math, 201 (3) 2025.
-/

set_option autoImplicit false

/-- A group is coherent if all of its finitely generated subgroups are finitely presented. -/
def Group.Coherent (G : Type*) [Group G] : Prop :=
  ∀ H : Subgroup G, H.FG → Group.IsFinitelyPresented H

/-- A semiring is (left) coherent if all of its finitely generated (left) ideals are
finitely presented. -/
def Ring.Coherent (R : Type*) [Semiring R] : Prop :=
  ∀ I : Ideal R, I.FG → Module.FinitePresentation R I

/-- A group `G` is called one-relator if it has a presentation with a single relation. -/
def Group.OneRelator.{u} (G : Type u) [Group G] : Prop :=
  ∃ α : Type u, ∃ rel : FreeGroup α, Nonempty (PresentedGroup {rel} ≃* G)

namespace OnCoherenceOfOneRelatorGroups

/--
Statement of Theorem 1.1:

Let `G` be a one-relator group and `K` be a field of characteristic zero.
Then `G` is a coherent group and the group algebra `K[G]` is a coherent ring.
-/
@[eval_problem]
theorem theorem_1_1 (G K : Type*) [Group G] [Field K] [CharZero K] (hG : Group.OneRelator G) :
    Group.Coherent G ∧ Ring.Coherent (MonoidAlgebra K G) := by
  sorry

end OnCoherenceOfOneRelatorGroups
