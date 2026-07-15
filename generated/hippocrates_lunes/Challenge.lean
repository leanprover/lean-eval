import ChallengeDeps

open LeanEval.Geometry.HippocratesLunes
open MeasureTheory

theorem hippocrates_lunes (a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    volume (horizontalLune a b) + volume (verticalLune a b) =
      volume (rightTriangle a b) := by
  sorry
