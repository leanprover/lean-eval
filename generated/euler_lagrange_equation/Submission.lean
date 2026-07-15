import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis
open MeasureTheory Set
open scoped ContDiff

namespace Submission

theorem euler_lagrange_equation {a b : ℝ} (L : ℝ → ℝ → ℝ → ℝ) (x : ℝ → ℝ) (_hab : a < b)
    (_hL : ContDiff ℝ 2 (fun p : ℝ × ℝ × ℝ => L p.1 p.2.1 p.2.2))
    (_hx : ContDiff ℝ 2 x)
    (_hxe : IsVariationalExtremum a b L x) :
    ∀ t ∈ Set.Ioo a b,
      lagrangianPartialX L x t = deriv (lagrangianPartialV L x) t := by
  sorry

end Submission
