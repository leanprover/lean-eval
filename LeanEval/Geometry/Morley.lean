import Mathlib
import EvalTools.Markers

namespace LeanEval.Geometry.Morley

/-!
# Morley's trisector theorem

`morley_theorem`: the triangle formed by the adjacent angle-trisectors of any
nondegenerate Euclidean triangle is equilateral. Trusted helpers
(`IsEquilateralTriple`, `LiesInTriangle`, `IsMorleyConfiguration`) are
non-holes. Mathlib has Euclidean angles but not Morley's theorem.
Category-(b) candidate from §162 of the Knill survey.
-/

open scoped EuclideanGeometry

/-- The Euclidean plane. -/
abbrev Plane := EuclideanSpace ℝ (Fin 2)

/-- Three points form an equilateral triangle (equal side lengths). -/
def IsEquilateralTriple (P Q R : Plane) : Prop :=
  dist P Q = dist Q R ∧ dist Q R = dist R P

/-- A point lies in the closed triangle spanned by `A`, `B`, `C`. -/
def LiesInTriangle (A B C X : Plane) : Prop :=
  X ∈ convexHull ℝ ({A, B, C} : Set Plane)

/-- The six Morley trisector incidences for a nondegenerate triangle `ABC`. -/
def IsMorleyConfiguration (A B C P Q R : Plane) : Prop :=
  ¬ Collinear ℝ ({A, B, C} : Set Plane) ∧
  LiesInTriangle A B C P ∧ LiesInTriangle A B C Q ∧ LiesInTriangle A B C R ∧
  0 < (∠ C A R) ∧ (∠ C A R) = (∠ R A P) ∧ (∠ R A P) = (∠ P A B) ∧
  3 * (∠ P A B) = (∠ C A B) ∧
  0 < (∠ A B P) ∧ (∠ A B P) = (∠ P B Q) ∧ (∠ P B Q) = (∠ Q B C) ∧
  3 * (∠ Q B C) = (∠ A B C) ∧
  0 < (∠ B C Q) ∧ (∠ B C Q) = (∠ Q C R) ∧ (∠ Q C R) = (∠ R C A) ∧
  3 * (∠ R C A) = (∠ B C A)

/-- **Morley's theorem.** The adjacent-trisector triangle `PQR` of a
nondegenerate triangle `ABC` is equilateral. -/
@[eval_problem]
theorem morley_theorem (A B C P Q R : Plane)
    (h : IsMorleyConfiguration A B C P Q R) :
    IsEquilateralTriple P Q R := by
  sorry

end LeanEval.Geometry.Morley
