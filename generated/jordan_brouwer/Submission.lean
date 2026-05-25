import Mathlib
import Submission.Helpers

namespace Submission

theorem jordan_brouwer (d : ℕ) (_hd : 2 ≤ d)
    (r : Metric.sphere (0 : EuclideanSpace ℝ (Fin d)) 1 → EuclideanSpace ℝ (Fin d))
    (_hcont : Continuous r) (_hinj : Function.Injective r) :
    Nat.card
        (ConnectedComponents ((Set.range r)ᶜ : Set (EuclideanSpace ℝ (Fin d)))) =
      2 := by
  sorry

end Submission
