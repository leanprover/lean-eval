import Mathlib
import EvalTools.Markers

namespace LeanEval.LinearAlgebra.DesnanotJacobi

/-!
# Desnanot–Jacobi identity

`desnanot_jacobi_identity`: for an `(n + 2) × (n + 2)` matrix over a commutative
ring, the product of the full determinant and the central (boundary-deleted)
minor equals the determinant of the four corner minors arranged as a `2 × 2`
determinant. Trusted helpers (`interiorFin`, `deleteFirstFirst`,
`deleteLastLast`, `deleteFirstLast`, `deleteLastFirst`, `deleteBoundaryBoundary`)
are non-holes. Mathlib has determinants and submatrices but not the
Desnanot–Jacobi / Dodgson condensation identity. Category-(b) candidate from
§201 of the Knill survey.
-/

open Matrix

variable {R : Type*}

/-- The embedding selecting the interior indices `1, ..., n` inside
`0, ..., n+1`. -/
def interiorFin (n : ℕ) : Fin n → Fin (n + 2) :=
  Fin.succ ∘ Fin.castAdd 1

/-- Delete the first row and first column of an `(n+2) × (n+2)` matrix. -/
def deleteFirstFirst {R : Type*} (n : ℕ) (A : Matrix (Fin (n + 2)) (Fin (n + 2)) R) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) R :=
  A.submatrix Fin.succ Fin.succ

/-- Delete the last row and last column of an `(n+2) × (n+2)` matrix. -/
def deleteLastLast {R : Type*} (n : ℕ) (A : Matrix (Fin (n + 2)) (Fin (n + 2)) R) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) R :=
  A.submatrix (Fin.castAdd 1) (Fin.castAdd 1)

/-- Delete the first row and last column of an `(n+2) × (n+2)` matrix. -/
def deleteFirstLast {R : Type*} (n : ℕ) (A : Matrix (Fin (n + 2)) (Fin (n + 2)) R) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) R :=
  A.submatrix Fin.succ (Fin.castAdd 1)

/-- Delete the last row and first column of an `(n+2) × (n+2)` matrix. -/
def deleteLastFirst {R : Type*} (n : ℕ) (A : Matrix (Fin (n + 2)) (Fin (n + 2)) R) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) R :=
  A.submatrix (Fin.castAdd 1) Fin.succ

/-- Delete both boundary rows and both boundary columns. -/
def deleteBoundaryBoundary {R : Type*} (n : ℕ)
    (A : Matrix (Fin (n + 2)) (Fin (n + 2)) R) : Matrix (Fin n) (Fin n) R :=
  A.submatrix (interiorFin n) (interiorFin n)

/-- **Desnanot–Jacobi identity** for the four corner minors.  Knill's `n × n`
statement is represented here as an `(n+2) × (n+2)` matrix: after deleting
both boundary rows and columns the remaining minor has size `n`. -/
@[eval_problem]
theorem desnanot_jacobi_identity [CommRing R] (n : ℕ)
    (A : Matrix (Fin (n + 2)) (Fin (n + 2)) R) :
    A.det * (deleteBoundaryBoundary n A).det =
      (deleteFirstFirst n A).det * (deleteLastLast n A).det -
        (deleteLastFirst n A).det * (deleteFirstLast n A).det := by
  sorry

end LeanEval.LinearAlgebra.DesnanotJacobi
