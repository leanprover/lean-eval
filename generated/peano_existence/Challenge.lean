import Mathlib

open Set
open scoped NNReal

theorem peano_existence {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {f : E → E} (hf : Continuous f) (x₀ : E) :
    ∃ a : ℝ, 0 < a ∧ ∃ α : ℝ → E, α 0 = x₀ ∧
      ∀ t ∈ Ioo (-a) a, HasDerivAt α (f (α t)) t := by
  sorry
