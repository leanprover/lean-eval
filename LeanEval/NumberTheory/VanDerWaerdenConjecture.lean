/-
Copyright (c) 2025 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Analysis.Asymptotics.Defs
import Mathlib.FieldTheory.PolynomialGaloisGroup
import EvalTools.Markers

/-!
# Main Statement from Galois groups of random integer polynomials and van der Waerden's Conjecture

We formalise the statement of the main result from M. Bhargava,
`Galois groups of random integer polynomials and van der Waerden's Conjecture`,
Annals of Math, 201 (2) 2025.
-/

set_option autoImplicit false

namespace vanDerWaerdenConjecture

open Function Polynomial Filter

noncomputable section

/-- Definition of `Eₙ(H)` as the number of monic integer polynomials `f(x) = xⁿ + a₁ xⁿ⁻¹ + … aₙ` of
degree `n` with `|aᵢ| ≤ H` for all `i` such that the Galois group of `f` is not `Sₙ`.
-/
def E (n H : ℕ) : ℕ :=
  {p : ℤ[X] | p.Monic ∧ p.degree = n ∧ (∀ i < n, |p.coeff i| ≤ H) ∧
    Nat.card (p.map (algebraMap ℤ ℚ)).Gal < n.factorial}.ncard

/--
Statement of Theorem 1:

`Eₙ(H) = O(Hⁿ⁻¹)` for `n ≥ 3`.

The degree restriction is necessary: the theorem is false as stated for `n = 2`.
-/
@[eval_problem]
theorem theorem_1 (n : ℕ) (hn : 3 ≤ n) :
    (fun H ↦ (E n H : ℝ)) =O[atTop] (fun H ↦ (H ^ (n - 1) : ℝ)) := by
  sorry

end

end vanDerWaerdenConjecture
