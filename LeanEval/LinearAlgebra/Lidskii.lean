import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace LinearAlgebra

/-!
# Lidskii–Last eigenvalue-perturbation theorem

§99 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. For two
self-adjoint complex `n × n` matrices `A, B` with eigenvalues sorted in the
same order, the total eigenvalue displacement is bounded by the entrywise
`ℓ¹` distance:

  `∑ⱼ |αⱼ − βⱼ| ≤ ∑ᵢⱼ |Aᵢⱼ − Bᵢⱼ|`.

This is Last's theorem (≈ 1993), a consequence of Lidskii's inequality
(1950). mathlib has `Matrix.IsHermitian.eigenvalues₀` (the spectral-theorem
eigenvalues) but none of the classical eigenvalue-perturbation bounds
(Lidskii, Ky Fan, Hoffman–Wielandt). The statement needs no auxiliary
definitions.
-/

open Matrix

/-- **Lidskii–Last theorem.** For two self-adjoint complex `n × n` matrices
`A, B`, with eigenvalues sorted in the same order,
`∑ⱼ |αⱼ − βⱼ| ≤ ∑ᵢⱼ |Aᵢⱼ − Bᵢⱼ|`. -/
@[eval_problem]
theorem lidskii_last {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℂ} (hA : A.IsHermitian) (hB : B.IsHermitian) :
    ∑ j, |hA.eigenvalues₀ j - hB.eigenvalues₀ j| ≤
      ∑ i, ∑ j, ‖A i j - B i j‖ := by
  sorry

end LinearAlgebra
end LeanEval
