import Mathlib.NumberTheory.WellApproximable
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

open MeasureTheory

namespace Submission

theorem duffin_schaeffer (δ : ℕ → ℝ) (hδ : ∀ n, 0 ≤ δ n) :
    volume (addWellApproximable UnitAddCircle δ) = 1 ↔
      ¬ Summable fun n : ℕ => n.totient * δ n := by
  sorry

end Submission
