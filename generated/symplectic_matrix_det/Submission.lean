import Mathlib
import Submission.Helpers

open Matrix

namespace Submission

theorem symplectic_matrix_det {l R : Type*} [DecidableEq l] [Fintype l] [CommRing R]
    {A : Matrix (l ⊕ l) (l ⊕ l) R} (_hA : A ∈ Matrix.symplecticGroup l R) :
    A.det = 1 := by
  sorry

end Submission
