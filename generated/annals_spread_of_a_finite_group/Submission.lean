import ChallengeDeps
import Submission.Helpers

open SpreadOfAFiniteGroup

set_option autoImplicit false

namespace Submission

theorem theorem_1 (G : Type*) [Group G] [Finite G] :
    s G ≥ 2 ↔ ∀ (N : Subgroup G) [N.Normal] [Nontrivial N], IsCyclic (G ⧸ N) := by
  sorry

end Submission
