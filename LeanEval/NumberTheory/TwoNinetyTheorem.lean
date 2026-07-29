/-
Copyright (c) 2026 Project Numina. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Numina Team
-/
import Mathlib
import EvalTools.Markers

namespace Matrix

variable {R : Type} [Ring R] {n : ℕ}

/-- A quadratic form, represented as a matrix, takes a particular value for some
integer vector input. -/
def TakesValue (M : Matrix (Fin n) (Fin n) R) (m : ℕ) : Prop :=
  ∃ v : Fin n → ℤ, (fun i => (v i : R)) ⬝ᵥ (M *ᵥ (fun i => (v i : R))) = (m : R)

/-- A quadratic form, represented as a matrix, is universal if it takes every
positive integer value. -/
def Universal (M : Matrix (Fin n) (Fin n) R) : Prop :=
  ∀ m : ℕ, 0 < m → M.TakesValue m

/-- A quadratic form is integral if it takes only integer values on integer
vectors. -/
def Integral (M : Matrix (Fin n) (Fin n) R) : Prop :=
  ∀ v : Fin n → ℤ,
    (fun i => (v i : R)) ⬝ᵥ (M *ᵥ (fun i => (v i : R))) ∈ Set.range ((↑) : ℤ → R)

end Matrix

namespace TwoNinety

/-!
# The 290 theorem

A positive-definite integral quadratic form represents every positive integer
as soon as it represents the 29 critical numbers
`1, 2, 3, 5, 6, 7, 10, 13, 14, 15, 17, 19, 21, 22, 23, 26, 29, 30, 31, 34, 35,
37, 42, 58, 93, 110, 145, 203, 290`.

 See <https://en.wikipedia.org/wiki/15_and_290_theorems>.
-/

section Main

open Matrix

/-- The 29 critical numbers of the 290 theorem. -/
def critical_290_numbers : Finset ℕ :=
  {1, 2, 3, 5, 6, 7, 10, 13, 14, 15, 17, 19, 21, 22, 23, 26, 29, 30, 31,
   34, 35, 37, 42, 58, 93, 110, 145, 203, 290}

@[eval_problem]
theorem two_ninety_theorem {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ)
    (hpos : M.PosDef)
    (hIntegral : M.Integral)
    (hrep : ∀ m ∈ critical_290_numbers, M.TakesValue m) :
    M.Universal := by
  sorry

end Main

end TwoNinety
