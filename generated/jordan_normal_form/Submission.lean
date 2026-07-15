import ChallengeDeps
import Submission.Helpers

open LeanEval.LinearAlgebra.JordanNormalForm

namespace Submission

theorem jordan_normal_form {K : Type*} [Field K] [IsAlgClosed K] (n : ℕ)
    (f : Module.End K (StdSpace K n)) :
    Nonempty (JordanChainBasis f) := by
  sorry

end Submission
