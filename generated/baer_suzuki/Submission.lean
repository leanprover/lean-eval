import ChallengeDeps
import Submission.Helpers

open LeanEval.GroupTheory
open LeanEval.GroupTheory.Defs

namespace Submission

theorem baer_suzuki {G : Type*} [Group G] [Finite G]
    {p : ℕ} [Fact p.Prime] (x : G) :
    x ∈ pCore p G ↔
      ∀ g : G, IsPGroup p
        (Subgroup.closure ({x, g * x * g⁻¹} : Set G)) := by
  sorry

end Submission
