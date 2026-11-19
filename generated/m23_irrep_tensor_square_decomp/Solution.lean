import Mathlib
import Submission

open scoped TensorProduct

theorem m23_irrep_tensor_square_decomp :
    ∃ (G : Type) (_ : Group G) (_ : Fintype G),
      Fintype.card G = 10200960 ∧
      IsSimpleGroup G ∧
      ∃ (V : Type) (_ : AddCommGroup V) (_ : Module ℂ V) (ρ : Representation ℂ G V),
        Module.finrank ℂ V = 22 ∧
        ρ.IsIrreducible ∧
        (@isotypicComponents (MonoidAlgebra ℂ G) (V ⊗[ℂ] V) _ _
          (Module.compHom (V ⊗[ℂ] V)
            (Representation.asAlgebraHom (ρ.tprod ρ)).toRingHom)).ncard = 4 := by
  exact Submission.m23_irrep_tensor_square_decomp
