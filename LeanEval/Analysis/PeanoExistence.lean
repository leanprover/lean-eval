import Mathlib
import EvalTools.Markers

namespace LeanEval.Analysis.PeanoExistence

/-!
# Peano existence theorem

`peano_existence`: replacing the Lipschitz hypothesis of Picard–Lindelöf with
mere continuity still yields a local solution of `x' = f(x)`, `x(0) = x₀` (though
uniqueness may fail). Stated for a finite-dimensional space, since Peano's
theorem requires local compactness and fails in general Banach spaces. Mathlib
has Arzelà–Ascoli but not Peano's theorem itself. Category-(b) candidate from
§19 of the Knill survey.
-/

open Set
open scoped NNReal

/-- **Peano existence theorem.** Replacing the Lipschitz condition with mere
continuity still yields a local solution of `x' = f(x)`, `x(0) = x₀` — but
uniqueness may fail (e.g. `x' = √x`, `x(0) = 0`). Stated for a
finite-dimensional space: Peano's theorem requires local compactness and is
false in general (infinite-dimensional) Banach spaces. -/
@[eval_problem]
theorem peano_existence
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {f : E → E} (hf : Continuous f) (x₀ : E) :
    ∃ a : ℝ, 0 < a ∧ ∃ α : ℝ → E, α 0 = x₀ ∧
      ∀ t ∈ Ioo (-a) a, HasDerivAt α (f (α t)) t := by
  sorry

end LeanEval.Analysis.PeanoExistence
