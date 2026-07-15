import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis.RisingSun
open Set MeasureTheory
open scoped Topology

namespace Submission

theorem rising_sun_lemma {a b : ℝ} (hab : a < b) {f : ℝ → ℝ}
    (hf : ContinuousOn f (Icc a b)) :
    HasRisingSunProperty a b f := by
  sorry

end Submission
