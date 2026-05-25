import ChallengeDeps
import Submission.Helpers

open LeanEval.Topology

namespace Submission

theorem kakutani_fixed_point {d : ℕ}
    {K : Set (EuclideanSpace ℝ (Fin d))}
    (_hK_compact : IsCompact K) (_hK_convex : Convex ℝ K)
    (_hK_nonempty : K.Nonempty)
    (F : EuclideanSpace ℝ (Fin d) → Set (EuclideanSpace ℝ (Fin d)))
    (_hF_uhc : IsUpperHemicontinuous F)
    (_hF_nonempty : ∀ x ∈ K, (F x).Nonempty)
    (_hF_convex : ∀ x ∈ K, Convex ℝ (F x))
    (_hF_closed : ∀ x ∈ K, IsClosed (F x))
    (_hF_maps : ∀ x ∈ K, F x ⊆ K) :
    ∃ x ∈ K, x ∈ F x := by
  sorry

end Submission
