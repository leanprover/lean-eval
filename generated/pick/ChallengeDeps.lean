import Mathlib

namespace LeanEval.Geometry.PicksTheorem

/-!
# Pick's theorem

`pick` (Pick 1899): a simple lattice polygon has area `I + B/2 − 1`, with `I`/`B`
the interior/boundary lattice-point counts. Trusted helpers (`toPlane`,
`latPoly`, `inside`, `area`, `Adjacent`, `IsSimple`, `boundaryPts`,
`interiorPts`) are non-holes. Mathlib has `Polygon` and its boundary but no
polygon interior, lattice-point counts, or Pick's theorem.
Category-(b) candidate from §154 of the Knill survey.
-/

open MeasureTheory

/-- Coordinatewise cast of a lattice point to the plane. -/
def toPlane (z : ℤ × ℤ) : ℝ × ℝ := ((z.1 : ℝ), (z.2 : ℝ))

/-- The lattice polygon on integer vertex data `v`. -/
def latPoly {n : ℕ} (v : Fin n → ℤ × ℤ) : Polygon (ℝ × ℝ) n :=
  ⟨fun i => toPlane (v i)⟩

/-- The open interior region of a planar curve `S`: points off `S` whose
component in `Sᶜ` is bounded (the Jordan interior for a simple closed curve). -/
def inside (S : Set (ℝ × ℝ)) : Set (ℝ × ℝ) :=
  {x | x ∉ S ∧ Bornology.IsBounded (connectedComponentIn Sᶜ x)}

/-- Enclosed area: Lebesgue measure of the interior region. -/
noncomputable def area (S : Set (ℝ × ℝ)) : ℝ := (volume (inside S)).toReal

/-- Cyclic adjacency of edge indices. -/
def Adjacent {n : ℕ} (i j : Fin n) : Prop :=
  finRotate n i = j ∨ finRotate n j = i

/-- A simple (Jordan) polygon. -/
def IsSimple {n : ℕ} (poly : Polygon (ℝ × ℝ) n) : Prop :=
  poly.HasNondegenerateEdges ∧
  (∀ i j : Fin n, i ≠ j → ¬ Adjacent i j →
      Disjoint (poly.edgeSet ℝ i) (poly.edgeSet ℝ j)) ∧
  (∀ i : Fin n, poly.edgeSet ℝ i ∩ poly.edgeSet ℝ (finRotate n i)
      = {poly (finRotate n i)})

/-- Number of boundary lattice points. -/
noncomputable def boundaryPts {n : ℕ} (v : Fin n → ℤ × ℤ) : ℕ :=
  Nat.card {z : ℤ × ℤ | toPlane z ∈ (latPoly v).boundary (R := ℝ)}

/-- Number of interior lattice points. -/
noncomputable def interiorPts {n : ℕ} (v : Fin n → ℤ × ℤ) : ℕ :=
  Nat.card {z : ℤ × ℤ | toPlane z ∈ inside ((latPoly v).boundary (R := ℝ))}



end LeanEval.Geometry.PicksTheorem
