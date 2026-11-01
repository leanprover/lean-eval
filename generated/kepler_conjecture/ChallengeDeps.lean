import Mathlib

namespace LeanEval
namespace Geometry
namespace KeplerConjectureProblem

/-!
# Kepler conjecture (optimal sphere packing density in ℝ³)

The optimal sphere-packing density in three dimensions is `π / √18`,
achieved by the face-centred-cubic packing. Conjectured by Johannes
Kepler (1611); announced by Thomas Hales in 1998 and published as
Hales 2005; formally verified in HOL Light + Isabelle by the
*Flyspeck* project, completed August 2014.
Wiedijk-1000 #209; §96 in Knill's *Some Fundamental Theorems in
Mathematics*.

The definitions take a `Set` (rather than e.g. `Submodule ℤ`) for the
centre set because Kepler's optimal density is the supremum over *all*
unit-sphere packings, not just lattice packings.
-/

open scoped ENNReal
open MeasureTheory Filter

/-- The model space `ℝ^d`. -/
abbrev E (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- `X ⊆ ℝ^d` is the centre set of a **unit sphere packing**: the open
unit balls centred at the points of `X` are pairwise disjoint. -/
def IsPacking {d : ℕ} (X : Set (E d)) : Prop :=
  X.Pairwise (fun x y => Disjoint (Metric.ball x 1) (Metric.ball y 1))

/-- Fraction of the ball `B_R(0)` covered by the union of the unit
balls of the packing `X`. -/
noncomputable def coveredFraction {d : ℕ} (X : Set (E d)) (R : ℝ) : ℝ :=
  (volume ((⋃ x ∈ X, Metric.ball x 1) ∩ Metric.ball (0 : E d) R)).toReal /
    (volume (Metric.ball (0 : E d) R)).toReal

/-- Density of the packing `X`: `limsup_{R → ∞}` of the covered
fraction. -/
noncomputable def density {d : ℕ} (X : Set (E d)) : ℝ :=
  Filter.limsup (coveredFraction X) Filter.atTop

/-- Optimal unit-sphere-packing density in dimension `d`: the supremum
over all packings. -/
noncomputable def Δ (d : ℕ) : ℝ :=
  sSup {δ : ℝ | ∃ X : Set (E d), IsPacking X ∧ density X = δ}



end KeplerConjectureProblem
end Geometry
end LeanEval
