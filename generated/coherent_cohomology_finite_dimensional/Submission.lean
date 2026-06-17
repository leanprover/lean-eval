import ChallengeDeps
import Submission.Helpers

open LeanEval.AlgebraicGeometry
open CategoryTheory AlgebraicGeometry TensorProduct

variable {X : Scheme.{0}} {M : X.Modules}

namespace Submission

theorem coherent_cohomology_finite_dimensional (f : X ⟶ Spec (CommRingCat.of ℚ)) [IsProper f]
    [M.IsFiniteType] [M.IsQuasicoherent] (n : ℕ) :
    Module.Finite ℚ (ℚ ⊗[ℤ] M.sheaf.H n) := by
  sorry

end Submission
