import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-- **Kronecker-Weber Theorem**. Every finite abelian extension of `ℚ` is a subfield of a cyclotomic field. -/
@[eval_problem]
theorem kronecker_weber (K : Type*) [Field K] [Algebra ℚ K] [FiniteDimensional ℚ K]
    [IsGalois ℚ K] (h_ab : ∀ σ τ : K ≃ₐ[ℚ] K, σ * τ = τ * σ) :
    ∃ (n : ℕ) (L : Type*) (_ : Field L) (_ : Algebra ℚ L) (_ : IsCyclotomicExtension {n} ℚ L),
      Nonempty (K →ₐ[ℚ] L) := by
  sorry

end NumberTheory
end LeanEval
