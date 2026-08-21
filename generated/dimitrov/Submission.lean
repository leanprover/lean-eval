import Mathlib.NumberTheory.NumberField.House
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

namespace Submission

theorem dimitrov {K : Type*} [Field K] [NumberField K]
    (α : K)
    (α_int : IsIntegral ℤ α)
    (α_ne_zero : α ≠ 0)
    (α_not_rootOfUnity : ¬ IsOfFinOrder α) :
    (2 : ℝ) ^ (1 / (4 * (Finset.univ.image fun σ : K →+* ℂ ↦ (σ α).arg).card) : ℝ) ≤
      NumberField.house α := by
  sorry

end Submission
