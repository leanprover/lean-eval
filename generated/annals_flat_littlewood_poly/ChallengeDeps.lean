import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Analysis.Complex.Norm
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Flat Littlewood polynomials exist

We formalise the statement of the main result from P. Balister, B. Bollobás, R. Morris,
J. Sahasrabudhe, and M. Tiba, `Flat Littlewood polynomials exist`, Annals of Math, 192 (3) 2020.
-/

set_option autoImplicit false

namespace FlatLittlewoodPoly

open scoped Polynomial

/-- A polynomial is a Littlewood polynomial if all its coefficients are either `-1` or `1`. -/
def IsLittlewoodPolynomial {F : Type*} [Ring F] (P : F[X]) : Prop :=
  ∀ i ≤ P.natDegree, P.coeff i = 1 ∨ P.coeff i = -1



end FlatLittlewoodPoly
