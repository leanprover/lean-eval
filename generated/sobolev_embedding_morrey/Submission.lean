import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis.SobolevMorreyProblem
open MeasureTheory
open scoped ENNReal NNReal

namespace Submission

theorem sobolev_embedding {n k r : ℕ} {α p : ℝ}
    (_hp : (n : ℝ) < p) (_hα : 0 < α) (_hα1 : α ≤ 1)
    (_hgap : (r : ℝ) + α < (k : ℝ) - n / p)
    (f : E n → ℝ) (_hf : MemSobolevWk k (ENNReal.ofReal p) f) :
    ∃ g : E n → ℝ, f =ᵐ[volume] g ∧ MemHolder r α g := by
  sorry

end Submission
