import Mathlib
import EvalTools.Markers

namespace LeanEval.Geometry.Equichordal

/-!
# Equichordal point theorem

`equichordal_point_unique`: a smooth convex plane curve, packaged as the
frontier of a compact convex planar domain `K` with nonempty interior, cannot
have two distinct equichordal points. The helper `IsEquichordalPoint` records
that the sum of the two opposite radial chord distances through an interior
point is a direction-independent constant. Mathlib has no equichordal-point
result. Category-(b) candidate from §205 of the Knill survey.
-/

open Metric Set

/-- The Euclidean plane. -/
abbrev Plane := EuclideanSpace ℝ (Fin 2)

/-- A point `P` is equichordal for the boundary of a planar domain `K` if
there is a constant chord length `L` such that every unit direction through
`P` meets the boundary at opposite chord endpoints whose total chord length
is `L`.  The open segment condition rules out choosing non-endpoint boundary
crossings for nonconvex star-like domains. -/
def IsEquichordalPoint (K : Set Plane) (P : Plane) : Prop :=
  P ∈ interior K ∧
    ∃ L : ℝ, 0 < L ∧
      ∀ u : Plane, u ∈ sphere (0 : Plane) 1 →
        ∃ a b : ℝ,
          0 < a ∧ 0 < b ∧
            P + a • u ∈ frontier K ∧
              P - b • u ∈ frontier K ∧
                openSegment ℝ (P - b • u) (P + a • u) ⊆ interior K ∧
                  dist (P + a • u) (P - b • u) = L

/-- **Equichordal point theorem** (§205).  A convex planar curve cannot have
two distinct equichordal points. -/
@[eval_problem]
theorem equichordal_point_unique {K : Set Plane}
    (hK : IsCompact K) (hconv : Convex ℝ K) (hne : (interior K).Nonempty) :
    ¬ ∃ P Q : Plane,
      P ≠ Q ∧ IsEquichordalPoint K P ∧ IsEquichordalPoint K Q := by
  sorry

end LeanEval.Geometry.Equichordal
