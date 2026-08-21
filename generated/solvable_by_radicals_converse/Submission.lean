import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

open Polynomial IntermediateField

namespace Submission

theorem solvable_iff_solvableByRad (F : Type*) [Field F] [CharZero F]
    (p : F[X]) (_hp : p ≠ 0) :
    (∀ x : AlgebraicClosure F, aeval x p = 0 →
        x ∈ solvableByRad F (AlgebraicClosure F)) ↔ Group.IsSolvable p.Gal := by
  sorry

end Submission
