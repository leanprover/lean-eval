import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis
open Set Topology

namespace Submission

theorem banach_alaoglu_bourbaki (E : Type*) [AddCommGroup E] [Module ℝ E]
    [TopologicalSpace E] [ContinuousAdd E] [ContinuousSMul ℝ E]
    [LocallyConvexSpace ℝ E] (U : Set E) (_hU : U ∈ 𝓝 (0 : E)) :
    IsCompact (weakStarPolar E U) := by
  sorry

end Submission
