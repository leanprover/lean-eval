import Mathlib
import Submission.Helpers

open Matrix

namespace Submission

theorem lidskii_last {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℂ} (hA : A.IsHermitian) (hB : B.IsHermitian) :
    ∑ j, |hA.eigenvalues₀ j - hB.eigenvalues₀ j| ≤
      ∑ i, ∑ j, ‖A i j - B i j‖ := by
  sorry

end Submission
