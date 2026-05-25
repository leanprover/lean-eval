import ChallengeDeps
import Submission

open LeanEval.GroupTheory
open LeanEval.GroupTheory.Defs

theorem baer_suzuki {G : Type*} [Group G] [Finite G]
    {p : ℕ} [Fact p.Prime] (x : G) :
    x ∈ pCore p G ↔
      ∀ g : G, IsPGroup p
        (Subgroup.closure ({x, g * x * g⁻¹} : Set G)) := by
  exact Submission.baer_suzuki x
