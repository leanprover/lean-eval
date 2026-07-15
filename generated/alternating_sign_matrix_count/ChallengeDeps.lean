import Mathlib

namespace LeanEval.Combinatorics.AlternatingSignMatrix

/-!
# The alternating sign matrix theorem

`alternating_sign_matrix_count` (Zeilberger 1994 / Kuperberg 1996): the number
of `n × n` alternating sign matrices is the Robbins product
`∏_{k<n} (3k+1)! / (n+k)!`. Trusted helpers (`IsAlternatingSignMatrix`,
`AlternatingSignMatrix`, `robbinsProduct`, …) are non-holes. Mathlib has no ASM
enumeration.
Category-(b) candidate from §168 of the Knill survey.
-/

open Matrix
open scoped BigOperators

/-- Partial sum of row `i` up through column `k`. -/
def rowPartialSum {n : ℕ} (A : Matrix (Fin n) (Fin n) ℤ) (i k : Fin n) : ℤ :=
  Finset.sum (Finset.univ.filter (fun j : Fin n => j ≤ k)) (fun j => A i j)

/-- Partial sum of column `j` up through row `k`. -/
def colPartialSum {n : ℕ} (A : Matrix (Fin n) (Fin n) ℤ) (j k : Fin n) : ℤ :=
  Finset.sum (Finset.univ.filter (fun i : Fin n => i ≤ k)) (fun i => A i j)

/-- A permitted partial sum value for an ASM. -/
def IsZeroOrOne (a : ℤ) : Prop := a = 0 ∨ a = 1

/-- An `n × n` alternating sign matrix (via the partial-sum characterisation). -/
def IsAlternatingSignMatrix {n : ℕ} (A : Matrix (Fin n) (Fin n) ℤ) : Prop :=
  (∀ i j, A i j = -1 ∨ A i j = 0 ∨ A i j = 1) ∧
  (∀ i k, IsZeroOrOne (rowPartialSum A i k)) ∧
  (∀ j k, IsZeroOrOne (colPartialSum A j k)) ∧
  (∀ i, ∑ j, A i j = 1) ∧
  (∀ j, ∑ i, A i j = 1)

/-- The type of `n × n` alternating sign matrices. -/
abbrev ASMatrix (n : ℕ) :=
  { A : Matrix (Fin n) (Fin n) ℤ // IsAlternatingSignMatrix A }

/-- The Robbins / ASM product in `ℚ`. -/
def robbinsProduct (n : ℕ) : ℚ :=
  Finset.prod (Finset.range n)
    (fun k => (Nat.factorial (3 * k + 1) : ℚ) / (Nat.factorial (n + k) : ℚ))



end LeanEval.Combinatorics.AlternatingSignMatrix
