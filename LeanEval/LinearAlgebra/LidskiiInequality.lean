import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace LinearAlgebra

/-!
# Lidskii's inequality

§99 of Oliver Knill's *Some Fundamental Theorems in Mathematics* (an
additional statement of the section on spectral perturbation; the boxed
main theorem `lidskii_last` follows as the `p = 1` case combined with an
entrywise bound).

For two self-adjoint complex `n × n` matrices `A, B` with eigenvalues
sorted in the same order, the `ℓ^p` displacement of the eigenvalues is
bounded by the `ℓ^p` norm of the eigenvalues of `C := B − A`, for every
real `p ≥ 1`:

  `∑ⱼ |αⱼ − βⱼ|^p ≤ ∑ⱼ |γⱼ|^p`.

mathlib has `Matrix.IsHermitian.eigenvalues₀` (the spectral-theorem
eigenvalues) but none of the classical eigenvalue-perturbation bounds
(Lidskii, Ky Fan, Hoffman–Wielandt). No formalization of Lidskii's
inequality was found in any other proof assistant.
-/

open Matrix

/-- **Lidskii's inequality.** For two self-adjoint complex `n × n` matrices
`A, B`, with eigenvalues sorted in the same order and `p ≥ 1`,
`∑ⱼ |αⱼ − βⱼ|^p ≤ ∑ⱼ |γⱼ|^p` where `γⱼ` are the eigenvalues of `B − A`. -/
@[eval_problem]
theorem lidskii_inequality {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℂ} (hA : A.IsHermitian) (hB : B.IsHermitian)
    {p : ℝ} (_hp : 1 ≤ p) :
    ∑ j, |hA.eigenvalues₀ j - hB.eigenvalues₀ j| ^ p ≤
      ∑ j, |(hB.sub hA).eigenvalues₀ j| ^ p := by
  sorry

end LinearAlgebra
end LeanEval
