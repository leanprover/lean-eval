/-
Copyright (c) 2025 Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Katerina Hristova, Kevin Buzzard, Bhavik Mehta
-/

import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Analysis.Complex.Norm
import EvalTools.Markers

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

/--
Statement of Theorem 1.1:

There exist constants `∆ > δ > 0` such that, for all `n ≥ 2`, there exists a Littlewood
polynomial `P(z)` of degree `n` with `δ√n ≤ |P (z)| ≤ ∆√n` for all `z ∈ ℂ` with `|z| = 1`.
-/
@[eval_problem]
theorem theorem_1_1 :
    ∃ Δ δ : ℝ, Δ > δ ∧ δ > 0 ∧ ∀ n ≥ 2,
      ∃ P : ℂ[X], IsLittlewoodPolynomial P ∧ P.natDegree = n ∧
      ∀ z : ℂ, ‖z‖ = 1 → δ * √n ≤ ‖P.eval z‖ ∧
      ‖P.eval z‖ ≤ Δ * √n := by
  sorry

end FlatLittlewoodPoly
