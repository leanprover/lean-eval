import Mathlib
import EvalTools.Markers

namespace LeanEval.Analysis.WangZahlKakeya

/-!
# The three-dimensional Kakeya conjecture

Hong Wang and Joshua Zahl proved that every Kakeya set in three-dimensional
Euclidean space has Hausdorff dimension `3`. A Kakeya set is compact and
contains a unit line segment pointing in every direction.

The helper `IsKakeya` below includes compactness and makes both "unit"
conditions explicit: the direction vector has norm `1`, and the parameter of
the line segment ranges over `[0, 1]`. It is trusted scaffolding rather than a
benchmark hole.
-/

open MeasureTheory

/-- Three-dimensional Euclidean space. -/
abbrev Space := EuclideanSpace ℝ (Fin 3)

/-- A **Kakeya set** is a compact subset of three-dimensional Euclidean space
that contains a unit line segment pointing in every unit direction. -/
def IsKakeya (K : Set Space) : Prop :=
  IsCompact K ∧
    ∀ v : Space, ‖v‖ = 1 →
      ∃ x : Space, ∀ t : ℝ, t ∈ Set.Icc 0 1 → x + t • v ∈ K

/-- **Wang--Zahl's three-dimensional Kakeya theorem.** Every Kakeya set in
three-dimensional Euclidean space has full Hausdorff dimension. -/
@[eval_problem]
theorem wang_zahl_kakeya_dimH {K : Set Space} (hK : IsKakeya K) :
    dimH K = 3 := by
  sorry

end LeanEval.Analysis.WangZahlKakeya
