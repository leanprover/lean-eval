import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.Equichordal
open Metric Set

namespace Submission

theorem equichordal_point_unique {K : Set Plane}
    (hK : IsCompact K) (hconv : Convex ℝ K) (hne : (interior K).Nonempty) :
    ¬ ∃ P Q : Plane,
      P ≠ Q ∧ IsEquichordalPoint K P ∧ IsEquichordalPoint K Q := by
  sorry

end Submission
