import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Geometry.Manifold.SmoothEmbedding
import Mathlib.MeasureTheory.Measure.Haar.OfBasis
import Mathlib.Probability.Distributions.Fernique
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Inscribed rectangles in a smooth Jordan curve attain at least
# one third of all aspect ratios

We formalise the statement of the main result from C. Hugelmeyer, `Inscribed rectangles in a
smooth Jordan curve attain at least one third of all aspect ratios`, Annals of Math, 194 (2) 2021.
-/

set_option autoImplicit false

namespace InscribedRectangles

open Manifold Real MeasureTheory

open scoped ContDiff

/-- Rectangle with sides parallel to the axes, given by opposite corners `a` and `b`. -/
noncomputable def axisAlignedRectangleCorners (a b : ℝ × ℝ) : Fin 4 → ℝ × ℝ :=
  ![(a.1, a.2), (b.1, a.2), (b.1, b.2), (a.1, b.2)]

/-- A rectangle in the Euclidean plane with opposite vertices `a` and `b` rotated by an angle `θ`.
-/
noncomputable def rectangleCorners (a b : ℝ × ℝ) (θ : ℝ) : Fin 4 → ℝ × ℝ :=
  ContinuousLinearMap.rotation θ ∘ axisAlignedRectangleCorners a b

/-- A rectangle is inscribed in a Jordan curve `γ` if all its vertices are distinct and lie on `γ`.
Note: We don't need the smooth hypothesis on the Jordan curve to define this. -/
def IsInscribedRectangle (a b : ℝ × ℝ) (θ : ℝ) (γ : Circle → ℝ × ℝ) : Prop :=
  Function.Injective (rectangleCorners a b θ) ∧ ∀ i : Fin 4, rectangleCorners a b θ i ∈ Set.range γ

/-- The aspect ratio of a rectangle is the ratio of the length of its sides. -/
noncomputable def aspectRatio (a b : ℝ × ℝ) : ℝ :=
  |a.1 - b.1| / |a.2 - b.2|

/-- The set `X` from Theorem 1. More precisely, let `X` be the set of all `r ∈ [0,1]` so that there
is an inscribed rectangle in `γ` of aspect ratio `tan(r·π/4)`. -/
noncomputable def X (γ : Circle → ℝ × ℝ) : Set ℝ :=
  {r : ℝ | r ∈ Set.Icc 0 1 ∧ ∃ a b : ℝ × ℝ, ∃ θ : ℝ,
    aspectRatio a b = tan (r * π / 4) ∧ IsInscribedRectangle a b θ γ}



end InscribedRectangles
