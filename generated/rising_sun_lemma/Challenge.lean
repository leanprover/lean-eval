import ChallengeDeps

open LeanEval.Analysis.RisingSun
open Set MeasureTheory
open scoped Topology

theorem rising_sun_lemma {a b : ℝ} (hab : a < b) {f : ℝ → ℝ}
    (hf : ContinuousOn f (Icc a b)) :
    HasRisingSunProperty a b f := by
  sorry
