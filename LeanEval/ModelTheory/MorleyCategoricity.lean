import Mathlib.ModelTheory.Satisfiability
import EvalTools.Markers

namespace LeanEval
namespace ModelTheory

open Cardinal

/-!
Morley's categoricity theorem.

A complete theory in a countable language, all of whose models are infinite, that is
categorical in some uncountable cardinal is categorical in every uncountable cardinal.  -/

@[eval_problem]
theorem morley_categoricity_theorem
    (L : FirstOrder.Language.{0, 0}) (hL : L.card ≤ ℵ₀)
    (T : L.Theory) (hT : T.IsComplete)
    (hInf : ∀ M : FirstOrder.Language.Theory.ModelType.{0, 0, 0} T, Infinite M)
    {κ : Cardinal.{0}} (hκ : ℵ₀ < κ) (hcat : κ.Categorical T)
    {μ : Cardinal.{0}} (hμ : ℵ₀ < μ) :
    μ.Categorical T := by
  sorry

end ModelTheory
end LeanEval
