import Mathlib
import EvalTools.Markers

namespace LeanEval.LinearAlgebra.NormalSpectralTheorem

/-!
# Normal spectral theorem

`normal_spectral_theorem`: a complex matrix `A` is normal (`IsStarNormal A`,
i.e. `Aᴴ A = A Aᴴ`) iff it is unitarily diagonalizable, `A = U (diagonal d) Uᴴ`
with `U` unitary. Mathlib has the Hermitian special case
(`Matrix.IsHermitian.spectral_theorem`) but not the normal generalization; the
forward implication (a normal matrix has an orthonormal eigenbasis) is the
substantive content. Category-(b) candidate from §14 of the Knill survey.
-/

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Spectral theorem** (§14). A complex matrix `A` is **normal**
(`Aᴴ A = A Aᴴ`, i.e. `IsStarNormal A`) **iff** it is **unitarily
diagonalizable**: there is a unitary `U` and a diagonal matrix `diagonal d`
with `A = U (diagonal d) Uᴴ`. -/
@[eval_problem]
theorem normal_spectral_theorem (A : Matrix n n ℂ) :
    IsStarNormal A ↔
      ∃ U ∈ unitary (Matrix n n ℂ), ∃ d : n → ℂ,
        A = U * diagonal d * star U := by
  sorry

end LeanEval.LinearAlgebra.NormalSpectralTheorem
