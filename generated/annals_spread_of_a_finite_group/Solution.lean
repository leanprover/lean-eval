import ChallengeDeps
import Submission

open SpreadOfAFiniteGroup

set_option autoImplicit false

theorem theorem_1 (G : Type*) [Group G] [Finite G] :
    s G ≥ 2 ↔ ∀ (N : Subgroup G) [N.Normal] [Nontrivial N], IsCyclic (G ⧸ N) := by
  exact Submission.theorem_1 G
