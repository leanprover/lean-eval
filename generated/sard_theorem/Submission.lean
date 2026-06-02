import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.SardTheoremProblem
open MeasureTheory Module
open scoped ContDiff

namespace Submission

theorem sard {m n : ℕ} (f : E m → E n) (_hf : ContDiff ℝ ∞ f) :
    volume (criticalValues f) = 0 := by
  sorry

end Submission
