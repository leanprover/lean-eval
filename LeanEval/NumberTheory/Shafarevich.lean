import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-- **Shafarevich's Theorem**. Every finite solvable group is realizable as a Galois group over `ℚ`. -/
@[eval_problem]
theorem shafarevich (G : Type*) [Group G] [Finite G] [IsSolvable G] :
    ∃ (K : Type*) (_ : Field K) (_ : Algebra ℚ K) (_ : FiniteDimensional ℚ K) (_ : IsGalois ℚ K),
      Nonempty (G ≃* (K ≃ₐ[ℚ] K)) := by
  sorry

end NumberTheory
end LeanEval
