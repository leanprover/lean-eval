import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis.WienerOneOverF
open Set
open scoped ComplexConjugate Real

variable {T : ℝ} [Fact (0 < T)]

namespace Submission

theorem wiener_inverse_closed (f : C(AddCircle T, ℂ))
    (hf : InWienerAlgebra f) (hzero : ∀ x, f x ≠ 0) :
    ∃ g : C(AddCircle T, ℂ),
      (∀ x, g x = (f x)⁻¹) ∧ InWienerAlgebra g := by
  sorry

end Submission
