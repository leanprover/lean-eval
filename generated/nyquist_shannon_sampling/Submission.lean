import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis.NyquistShannon
open scoped FourierTransform SchwartzMap
open Set

namespace Submission

theorem nyquist_shannon_sampling (f : 𝓢(ℝ, ℂ)) (hf : FourierSupportedInNyquist f) :
    ∀ t : ℝ,
      Summable (fun n : ℤ ↦ f (n : ℝ) * sinc (Real.pi * ((n : ℝ) - t))) ∧
        f t =
          ∑' n : ℤ, f (n : ℝ) * sinc (Real.pi * ((n : ℝ) - t)) := by
  sorry

end Submission
