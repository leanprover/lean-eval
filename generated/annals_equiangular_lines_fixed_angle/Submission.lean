import ChallengeDeps
import Submission.Helpers

open EquiangularLinesFixedAngle
open Filter
open scoped RealInnerProductSpace

namespace Submission

theorem theorem_1_2 (α : ℝ) (hα : α ∈ Set.Ioo 0 1) :
    let k := spectralRadiusOrder ((1 - α) / (2 * α))
    (k < ⊤ → ∀ᶠ d in atTop, N α d = ⌊(k.toNat * (d - 1) : ℝ) / (k.toNat - 1 : ℝ)⌋₊) ∧
    (k = ⊤ → ∃ e : ℕ → ℝ, e =o[atTop] (Nat.cast : ℕ → ℝ) ∧ ∀ d, N α d = d + e d) := by
  sorry

end Submission
