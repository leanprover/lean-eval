import Mathlib
import EvalTools.Markers

namespace LeanEval.Geometry.HopfUmlaufsatz

/-!
# The Hopf Umlaufsatz (theorem of turning tangents)

`hopf_umlaufsatz`: a positively oriented simple closed unit-speed plane curve
has total signed curvature `2π`. Trusted helpers (`signedArea`, `signedCurvature`,
`totalCurvature`, `IsPositiveSimpleClosedUnitSpeedCurve`, `IsTangentAngleLift`,
…) are non-holes. Mathlib has no turning-tangents theorem.
Category-(b) candidate from §170 of the Knill survey.
-/

/-- The Euclidean plane. -/
abbrev Plane := EuclideanSpace ℝ (Fin 2)

/-- The `2π` parameter period. -/
noncomputable def period : ℝ := 2 * Real.pi

/-- Velocity of a parametrized plane curve. -/
noncomputable def velocity (r : ℝ → Plane) (t : ℝ) : Plane := deriv r t

/-- The planar determinant / signed area form. -/
def det2 (u v : Plane) : ℝ := u 0 * v 1 - u 1 * v 0

/-- Signed area swept by a closed curve (Green normalization); its sign fixes
the orientation convention. -/
noncomputable def signedArea (r : ℝ → Plane) : ℝ :=
  (1 / 2 : ℝ) * ∫ t in (0 : ℝ)..period, det2 (r t) (velocity r t)

/-- A positively oriented simple regular closed unit-speed curve. -/
structure IsPositiveSimpleClosedUnitSpeedCurve (r : ℝ → Plane) : Prop where
  smooth : ContDiff ℝ 1 r
  periodic : Function.Periodic r period
  injective_on_period : Set.InjOn r (Set.Ico (0 : ℝ) period)
  unit_speed : ∀ t : ℝ, ‖velocity r t‖ = 1
  positive_orientation : 0 < signedArea r

/-- A real-valued tangent-angle lift: `r'(t) = (cos α(t), sin α(t))`. -/
structure IsTangentAngleLift (r : ℝ → Plane) (α : ℝ → ℝ) : Prop where
  smooth : ContDiff ℝ 1 α
  velocity_eq : ∀ t : ℝ,
    velocity r t = !₂[Real.cos (α t), Real.sin (α t)]

/-- Signed curvature as the derivative of the tangent-angle lift. -/
noncomputable def signedCurvature (α : ℝ → ℝ) (t : ℝ) : ℝ := deriv α t

/-- Total signed curvature over one period. -/
noncomputable def totalCurvature (α : ℝ → ℝ) : ℝ :=
  ∫ t in (0 : ℝ)..period, signedCurvature α t

/-- **Hopf Umlaufsatz.** A positively oriented simple closed unit-speed plane
curve has total signed curvature `2π`. -/
@[eval_problem]
theorem hopf_umlaufsatz
    {r : ℝ → Plane} {α : ℝ → ℝ}
    (_hr : IsPositiveSimpleClosedUnitSpeedCurve r)
    (_hα : IsTangentAngleLift r α) :
    totalCurvature α = 2 * Real.pi := by
  sorry

end LeanEval.Geometry.HopfUmlaufsatz
