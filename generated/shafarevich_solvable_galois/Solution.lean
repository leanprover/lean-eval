import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem shafarevich_solvable_galois (G : Type*) [Group G] [Finite G] [Group.IsSolvable G] :
    ∃ (K : Type) (_ : Field K) (_ : Algebra ℚ K) (_ : FiniteDimensional ℚ K) (_ : IsGalois ℚ K),
      Nonempty (G ≃* (K ≃ₐ[ℚ] K)) := by
  exact Submission.shafarevich_solvable_galois G
