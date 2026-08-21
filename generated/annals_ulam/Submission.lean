import ChallengeDeps
import Submission.Helpers

open Ulam
open MeasureTheory
open scoped ContDiff Pointwise RealInnerProductSpace

variable {d : ℕ}
local notation "ℝᵈ" => EuclideanSpace ℝ (Fin d)

namespace Submission

theorem theorem_1 (hd : 3 ≤ d) : letI : NeZero d := ⟨by omega⟩
    ∃ K : BodyOfRevolution d, IsStrictlyConvexBody K.body ∧ ¬ IsCentrallySymmetric K.body ∧
      FloatsInEquilibriumInEveryOrientationAtLevel K.body (volume.real K.body / 2) := by
  sorry

end Submission
