import Mathlib

namespace LeanEval.NumberTheory.TwoNinety

/-!
# The 290 theorem

A positive-definite integral quadratic form represents every positive integer
as soon as it represents the 29 critical numbers
`1, 2, 3, 5, 6, 7, 10, 13, 14, 15, 17, 19, 21, 22, 23, 26, 29, 30, 31, 34, 35,
37, 42, 58, 93, 110, 145, 203, 290`.

See <https://en.wikipedia.org/wiki/15_and_290_theorems>.
-/

open Matrix

variable {R : Type*} [Ring R] {n : ℕ}

/--
Evaluate a quadratic form `Q(x) = ∑_{i,j} Q_{ij} x_i x_j` given by
the matrix `Q` at a vector `x`.
-/
def evalQ (M : Matrix (Fin n) (Fin n) R) (v : Fin n → R) : R := v ⬝ᵥ M *ᵥ v

/-- A quadratic form, represented as a matrix, takes a particular value for some
integer vector input. -/
def Represents (M : Matrix (Fin n) (Fin n) R) (m : ℕ) : Prop :=
  ∃ v : Fin n → ℤ, evalQ M (v · : _ → R) = m

/-- A quadratic form, represented as a matrix, is universal if it takes every
positive integer value. -/
def IsUniversal (M : Matrix (Fin n) (Fin n) R) : Prop :=
  ∀ m : ℕ, 0 < m → Represents M m

/-- A quadratic form is integral if it takes only integer values on integer
vectors. -/
def Integral (M : Matrix (Fin n) (Fin n) R) : Prop :=
  ∀ v : Fin n → ℤ, evalQ M (v · : _ → R) ∈ Set.range ((↑) : ℤ → R)

/-- The 29 critical numbers of the 290 theorem. -/
def criticalNumbers : Finset ℕ :=
  {1, 2, 3, 5, 6, 7, 10, 13, 14, 15, 17, 19, 21, 22, 23, 26, 29, 30, 31,
   34, 35, 37, 42, 58, 93, 110, 145, 203, 290}



end LeanEval.NumberTheory.TwoNinety
