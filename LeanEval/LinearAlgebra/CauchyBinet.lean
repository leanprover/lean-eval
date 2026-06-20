import Mathlib
import EvalTools.Markers

namespace LeanEval.LinearAlgebra.CauchyBinet

/-!
# Lagrange / Cauchy–Binet identity

`lagrange_cauchy_binet`: for an `n × m` real matrix `F`, `det(FᵀF)` equals the
sum over all `m`-element row-subsets `S ⊆ Fin n` of the squared maximal minor
`det(F_S)²`. This is the Cauchy–Binet formula applied to `Fᵀ * F`, equivalently
Pythagoras / the Lagrange identity in `det²` form. Mathlib does not yet have the
Cauchy–Binet determinant formula (the subject of an in-flight PR); the indexing
mirrors the prospective `Matrix.det_mul_cauchyBinet`. Category-(b) candidate from
§2 of the Knill survey.
-/

open Matrix

/-- **Lagrange identity (Cauchy–Binet).** For an `n × m` real matrix `F`,
`det(FᵀF)` is the sum over all `m`-element row-subsets `S ⊆ Fin n` of the squared
maximal minor `det(F_S)²`, where `F_S` is the `m × m` submatrix on rows `S`. -/
@[eval_problem]
theorem lagrange_cauchy_binet {n m : ℕ} (F : Matrix (Fin n) (Fin m) ℝ) :
    (Fᵀ * F).det =
      ∑ S : {s : Finset (Fin n) // s.card = m},
        ((F.submatrix (S.1.orderEmbOfFin S.2) id).det) ^ 2 := by
  sorry

end LeanEval.LinearAlgebra.CauchyBinet
