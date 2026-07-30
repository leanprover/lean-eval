import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-- **Shafarevich's theorem on solvable Galois groups**. Every finite solvable
group is realizable as a Galois group over `ℚ`. -/
@[eval_problem]
theorem shafarevich_solvable_galois (G : Type*) [Group G] [Finite G] [IsSolvable G] :
    ∃ (K : Type) (_ : Field K) (_ : Algebra ℚ K) (_ : FiniteDimensional ℚ K) (_ : IsGalois ℚ K),
      Nonempty (G ≃* (K ≃ₐ[ℚ] K)) := by
  sorry

end NumberTheory
end LeanEval
