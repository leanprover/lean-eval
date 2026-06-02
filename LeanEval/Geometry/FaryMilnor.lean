import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace FaryMilnorProblem

/-!
# Fary–Milnor theorem

A smooth knot in `ℝ³` whose total curvature is at most `4π` is
unknotted. István Fáry (1949) and John Milnor (1950), independently.
§161 in Knill's *Some Fundamental Theorems in Mathematics*.

A knot is a smooth, regular, simple, `2π`-periodic curve `r : ℝ → ℝ³`,
simple on one half-open fundamental interval `[0, 2π)`. Its curvature
is `κ(t) = ‖r'(t) × r''(t)‖ / ‖r'(t)‖³`; total curvature is the
arc-length integral `∫₀^{2π} κ(t) · ‖r'(t)‖ dt`. Unknottedness is
encoded by a smooth isotopy through smooth knots from `r` to the
standard unit circle.

Mathlib has `deriv`, interval integrals, `ContDiff`, `crossProduct`,
and the Euclidean norm, but no knot-total-curvature or unknottedness
API.
-/

noncomputable section

open Set
open scoped Real
open WithLp

/-- Euclidean 3-space; the `EuclideanSpace ℝ (Fin 3)` wrapper carries
the Euclidean norm. -/
abbrev Space := EuclideanSpace ℝ (Fin 3)

/-- The period used by the parametrisation. -/
def period : ℝ := 2 * Real.pi

/-- Velocity. -/
def velocity (r : ℝ → Space) (t : ℝ) : Space :=
  deriv r t

/-- Acceleration. -/
def acceleration (r : ℝ → Space) (t : ℝ) : Space :=
  deriv (velocity r) t

/-- Curvature `κ(t) = ‖r'(t) × r''(t)‖ / ‖r'(t)‖³`. -/
def curvature (r : ℝ → Space) (t : ℝ) : ℝ :=
  ‖toLp 2 (crossProduct (ofLp (velocity r t)) (ofLp (acceleration r t)))‖ /
    ‖velocity r t‖ ^ 3

/-- Total curvature over one `2π` period, against arc length. -/
def totalCurvature (r : ℝ → Space) : ℝ :=
  ∫ t in (0 : ℝ)..period, curvature r t * ‖velocity r t‖

/-- The standard round unknot in the `xy`-plane. -/
def standardCircle (t : ℝ) : Space :=
  toLp 2 ![Real.cos t, Real.sin t, 0]

/-- A smooth parametrised knot: a regular smooth simple closed curve. -/
structure IsSmoothKnot (r : ℝ → Space) : Prop where
  smooth : ContDiff ℝ ⊤ r
  periodic : Function.Periodic r period
  injective_on_period : Set.InjOn r (Set.Ico (0 : ℝ) period)
  regular : ∀ t : ℝ, velocity r t ≠ 0

/-- Smooth isotopy through knots from `r` to the standard circle. -/
def IsUnknotted (r : ℝ → Space) : Prop :=
  ∃ R : ℝ → ℝ → Space,
    ContDiff ℝ ⊤ (fun p : ℝ × ℝ => R p.1 p.2) ∧
      (∀ t : ℝ, R t 0 = r t) ∧
      (∀ t : ℝ, R t 1 = standardCircle t) ∧
      ∀ s ∈ Set.Icc (0 : ℝ) 1, IsSmoothKnot (fun t : ℝ => R t s)

/-- **Fáry–Milnor theorem** (Fáry 1949 / Milnor 1950). A smooth knot
with total curvature at most `4π` is unknotted. -/
@[eval_problem]
theorem fary_milnor_total_curvature
    {r : ℝ → Space} (_hknot : IsSmoothKnot r)
    (_hK : totalCurvature r ≤ 4 * Real.pi) :
    IsUnknotted r := by
  sorry

end

end FaryMilnorProblem
end Geometry
end LeanEval
