import Mathlib.Analysis.Calculus.IteratedDeriv.Defs
import Mathlib.Analysis.Complex.Basic
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

open Metric

namespace Submission

theorem deBranges (f : ℂ → ℂ) (diff : DifferentiableOn ℂ f (ball 0 1)) (inj : (ball 0 1).InjOn f)
    (h0 : f 0 = 0) (h1 : deriv f 0 = 1) (n : ℕ) : ‖iteratedDeriv n f 0 / n.factorial‖ ≤ n := by
  sorry

end Submission
