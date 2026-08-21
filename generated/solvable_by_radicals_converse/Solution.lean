import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

open Polynomial IntermediateField

theorem solvable_iff_solvableByRad (F : Type*) [Field F] [CharZero F]
    (p : F[X]) (_hp : p ≠ 0) :
    (∀ x : AlgebraicClosure F, aeval x p = 0 →
        x ∈ solvableByRad F (AlgebraicClosure F)) ↔ Group.IsSolvable p.Gal := by
  exact Submission.solvable_iff_solvableByRad F p _hp
