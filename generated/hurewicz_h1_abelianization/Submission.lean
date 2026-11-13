import ChallengeDeps
import Submission.Helpers

open LeanEval.Topology.Hurewicz
open CategoryTheory AlgebraicTopology

namespace Submission

theorem hurewicz_h1_abelianization (X : Type) [TopologicalSpace X] [PathConnectedSpace X] (x : X) :
    Nonempty (Additive ((FundamentalGroup X x) ⧸ commutator (FundamentalGroup X x)) ≃+
      (IntegralHomology 1 X : Type)) := by
  sorry

end Submission
