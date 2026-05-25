import ChallengeDeps
import Submission

open LeanEval.Topology

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
  exact Submission.kakutani_fixed_point _hK_compact _hK_convex _hK_nonempty F _hF_uhc _hF_nonempty _hF_convex _hF_closed _hF_maps
