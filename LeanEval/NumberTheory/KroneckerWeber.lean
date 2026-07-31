import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-- **Kronecker-Weber Theorem**. Every finite abelian extension of `ℚ` is a subfield of a cyclotomic field. -/
@[eval_problem]
theorem kronecker_weber (K : Type*) [Field K] [Algebra ℚ K] [FiniteDimensional ℚ K]
    [IsGalois ℚ K] [IsMulCommutative (K ≃ₐ[ℚ] K)] :
    ∃ (n : ℕ), Nonempty (K →ₐ[ℚ] CyclotomicField n ℚ) := by
  sorry

end NumberTheory
end LeanEval
