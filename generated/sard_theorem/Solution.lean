import ChallengeDeps
import Submission

open LeanEval.Geometry.SardTheoremProblem
open MeasureTheory Module
open scoped ContDiff

theorem sard {m n : ℕ} (f : E m → E n) (_hf : ContDiff ℝ ∞ f) :
    volume (criticalValues f) = 0 := by
  exact Submission.sard f _hf
