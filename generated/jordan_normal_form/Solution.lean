import ChallengeDeps
import Submission

open LeanEval.LinearAlgebra.JordanNormalForm

theorem jordan_normal_form {K : Type*} [Field K] [IsAlgClosed K] (n : ℕ)
    (f : Module.End K (StdSpace K n)) :
    Nonempty (JordanChainBasis f) := by
  exact Submission.jordan_normal_form n f
