import ChallengeDeps
import Submission.Helpers

open LeanEval.Topology.KirkNormalStructure
open Function

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

namespace Submission

theorem kirk_normal_structure [CompleteSpace E]
    (hE_reflexive : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E))
    (K : Set E) (hK_nonempty : K.Nonempty) (hK_closed : IsClosed K)
    (hK_bounded : Bornology.IsBounded K) (hK_convex : Convex ℝ K)
    (hK_normal : HasNormalStructure K) (T : K → K)
    (hT : IsNonexpansiveSelfMap K T) :
    ∃ x : K, IsFixedPt T x := by
  sorry

end Submission
