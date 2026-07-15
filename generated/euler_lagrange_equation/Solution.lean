import ChallengeDeps
import Submission

open LeanEval.Analysis
open MeasureTheory Set
open scoped ContDiff

theorem euler_lagrange_equation {a b : ℝ} (L : ℝ → ℝ → ℝ → ℝ) (x : ℝ → ℝ) (_hab : a < b)
    (_hL : ContDiff ℝ 2 (fun p : ℝ × ℝ × ℝ => L p.1 p.2.1 p.2.2))
    (_hx : ContDiff ℝ 2 x)
    (_hxe : IsVariationalExtremum a b L x) :
    ∀ t ∈ Set.Ioo a b,
      lagrangianPartialX L x t = deriv (lagrangianPartialV L x) t := by
  exact Submission.euler_lagrange_equation L x _hab _hL _hx _hxe
