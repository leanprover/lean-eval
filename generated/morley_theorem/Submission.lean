import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.Morley
open scoped EuclideanGeometry

namespace Submission

theorem morley_theorem (A B C P Q R : Plane)
    (h : IsMorleyConfiguration A B C P Q R) :
    IsEquilateralTriple P Q R := by
  sorry

end Submission
