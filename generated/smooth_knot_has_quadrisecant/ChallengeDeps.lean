import Mathlib

namespace LeanEval.KnotTheory.Quadrisecant

/-!
# The Pannwitz–Kuperberg quadrisecant theorem

`smooth_knot_has_quadrisecant`: every smooth knot that is not the unknot has a
quadrisecant (a line meeting it in four points). Trusted helpers (`IsSmoothKnot`,
`IsUnknotted`, `HasQuadrisecant`, …) are non-holes. Mathlib has no knot theory.
(The Fáry–Milnor total-curvature theorem of §161 is a separate lean-eval problem.)
Category-(b) candidate from §161 of the Knill survey.
-/

/-- Euclidean 3-space (Euclidean norm via `EuclideanSpace`). -/
abbrev Space := EuclideanSpace ℝ (Fin 3)

/-- The `2π` period. -/
noncomputable def period : ℝ := 2 * Real.pi

/-- Velocity of a parametrized curve. -/
noncomputable def velocity (r : ℝ → Space) (t : ℝ) : Space := deriv r t

/-- The standard round unknot in the `xy`-plane. -/
noncomputable def standardCircle (t : ℝ) : Space :=
  !₂[Real.cos t, Real.sin t, 0]

/-- A smooth knot: a regular smooth simple closed space curve. -/
structure IsSmoothKnot (r : ℝ → Space) : Prop where
  smooth : ContDiff ℝ ⊤ r
  periodic : Function.Periodic r period
  injective_on_period : Set.InjOn r (Set.Ico (0 : ℝ) period)
  regular : ∀ t : ℝ, velocity r t ≠ 0

/-- Smooth isotopy through knots from `r` to the standard circle. -/
def IsUnknotted (r : ℝ → Space) : Prop :=
  ∃ R : ℝ → ℝ → Space,
    ContDiff ℝ ⊤ (fun p : ℝ × ℝ => R p.1 p.2) ∧
      (∀ t : ℝ, R t 0 = r t) ∧ (∀ t : ℝ, R t 1 = standardCircle t) ∧
      ∀ s ∈ Set.Icc (0 : ℝ) 1, IsSmoothKnot (fun t : ℝ => R t s)

/-- A quadrisecant: four distinct parameter values whose image points are
collinear. -/
def HasQuadrisecant (r : ℝ → Space) : Prop :=
  ∃ t0 t1 t2 t3 : ℝ, ∃ p v : Space, ∃ a0 a1 a2 a3 : ℝ,
    t0 ∈ Set.Ico (0 : ℝ) period ∧ t1 ∈ Set.Ico (0 : ℝ) period ∧
      t2 ∈ Set.Ico (0 : ℝ) period ∧ t3 ∈ Set.Ico (0 : ℝ) period ∧
      [t0, t1, t2, t3].Nodup ∧ v ≠ 0 ∧
      r t0 = p + a0 • v ∧ r t1 = p + a1 • v ∧
      r t2 = p + a2 • v ∧ r t3 = p + a3 • v



end LeanEval.KnotTheory.Quadrisecant
