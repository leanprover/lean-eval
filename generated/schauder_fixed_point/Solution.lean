import Mathlib
import Submission

theorem schauder_fixed_point {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    {K : Set E}
    (_hK_compact : IsCompact K) (_hK_convex : Convex ℝ K)
    (_hK_nonempty : K.Nonempty)
    (f : E → E)
    (_hf_cont : ContinuousOn f K) (_hf_maps : Set.MapsTo f K K) :
    ∃ x ∈ K, f x = x := by
  exact Submission.schauder_fixed_point _hK_compact _hK_convex _hK_nonempty f _hf_cont _hf_maps
