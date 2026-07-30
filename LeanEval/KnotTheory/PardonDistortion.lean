import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import EvalTools.Markers

namespace LeanEval
namespace KnotTheory
namespace PardonDistortion

/-!
# Pardon's lower bound for the distortion of torus knots

For a rectifiable simple closed curve `γ` in `ℝ³`, its distortion is the
supremum of the intrinsic arclength distance between two points of `γ` divided
by their Euclidean distance.  John Pardon proved that the infimum of this
quantity over all rectifiable representatives of the `(p, q)`-torus-knot
isotopy class is at least `min(p, q) / 160`.

The shared knot model in `LeanEval.KnotTheory.Prelude` describes smooth knots,
not arbitrary rectifiable curves.  The theorem below is therefore the faithful
smooth specialization of Pardon's result: every smooth representative smoothly
ambient-isotopic to the explicitly parametrized standard torus knot obeys the
same bound.  The isotopy and circle reparametrization are orientation-preserving,
as in the shared prelude; this only narrows the collection of representatives
covered by the published, unoriented statement.
-/

noncomputable section

open Set
open scoped ENNReal

/-
These definitions mirror the shared knot-theory prelude. They are included
here because generated eval workspaces retain declarations from this file but
do not import other `LeanEval` modules.
-/

/-- The ambient Euclidean space `ℝ³`. -/
abbrev R3 : Type := EuclideanSpace ℝ (Fin 3)

/-- An oriented smooth knot in `ℝ³`. -/
structure Knot where
  curve : ℝ → R3
  smooth : ContDiff ℝ (⊤ : ℕ∞) curve
  periodic : ∀ t, curve (t + 2 * Real.pi) = curve t
  injOn : Set.InjOn curve (Set.Ico 0 (2 * Real.pi))
  immersion : ∀ t, deriv curve t ≠ 0

/-- A smooth one-parameter family of diffeomorphisms of `ℝ³`, starting at
the identity. -/
structure AmbientIsotopy where
  H : ℝ → R3 → R3
  Hinv : ℝ → R3 → R3
  smooth : ContDiff ℝ (⊤ : ℕ∞) (Function.uncurry H)
  smooth_inv : ContDiff ℝ (⊤ : ℕ∞) (Function.uncurry Hinv)
  inv_left : ∀ t x, Hinv t (H t x) = x
  inv_right : ∀ t x, H t (Hinv t x) = x
  start : H 0 = id

/-- An orientation-preserving smooth reparametrization of the circle,
presented by a lift to `ℝ`. -/
structure CircleReparam where
  f : ℝ → ℝ
  finv : ℝ → ℝ
  smooth : ContDiff ℝ (⊤ : ℕ∞) f
  smooth_inv : ContDiff ℝ (⊤ : ℕ∞) finv
  left_inv : ∀ t, finv (f t) = t
  right_inv : ∀ t, f (finv t) = t
  periodic : ∀ t, f (t + 2 * Real.pi) = f t + 2 * Real.pi
  periodic_inv : ∀ t, finv (t + 2 * Real.pi) = finv t + 2 * Real.pi
  mono : StrictMono f

/-- The speed of a smooth knot with its given parametrization. -/
def speed (K : Knot) (t : ℝ) : ℝ :=
  ‖deriv K.curve t‖

/-- Arclength of the parametrized arc between `s` and `t`.  The absolute value
makes this independent of the order of the endpoints. -/
def parameterArcLength (K : Knot) (s t : ℝ) : ℝ :=
  |∫ u in s..t, speed K u|

/-- Total arclength over the fundamental interval `[0, 2π]`. -/
def totalArcLength (K : Knot) : ℝ :=
  parameterArcLength K 0 (2 * Real.pi)

/-- Intrinsic distance along the closed curve, for parameters in one
fundamental interval: the shorter of the two complementary arc lengths. -/
def intrinsicDistance (K : Knot) (s t : ℝ) : ℝ :=
  min (parameterArcLength K s t) (totalArcLength K - parameterArcLength K s t)

/-- The distortion ratio for the two points with parameters `s` and `t`. -/
def distortionRatio (K : Knot) (s t : ℝ) : ℝ :=
  intrinsicDistance K s t / dist (K.curve s) (K.curve t)

/-- Distortion of a smooth knot as an extended nonnegative real: the supremum
of the distortion ratios over distinct parameters in the half-open fundamental
interval `[0, 2π)`. The extended codomain also represents infinite
distortion. -/
def distortion (K : Knot) : ℝ≥0∞ :=
  sSup {d : ℝ≥0∞ | ∃ s ∈ Ico (0 : ℝ) (2 * Real.pi),
    ∃ t ∈ Ico (0 : ℝ) (2 * Real.pi),
      s ≠ t ∧ d = ENNReal.ofReal (distortionRatio K s t)}

/-- The standard `(p, q)`-torus curve on the torus of revolution with major
radius `2` and minor radius `1`.  It winds `p` times around the axis of the
torus and `q` times around a meridian. -/
def standardTorusCurve (p q : ℕ) (t : ℝ) : R3 :=
  WithLp.toLp 2 (fun i : Fin 3 =>
    if i.val = 0 then
      (2 + Real.cos ((q : ℝ) * t)) * Real.cos ((p : ℝ) * t)
    else if i.val = 1 then
      (2 + Real.cos ((q : ℝ) * t)) * Real.sin ((p : ℝ) * t)
    else
      Real.sin ((q : ℝ) * t))

/-- **Pardon's torus-knot distortion bound (smooth specialization).**

If `p` and `q` are positive and coprime, every smooth knot in the
orientation-preserving smooth ambient-isotopy class of the explicit standard
`(p, q)`-torus curve has distortion at least `min(p, q) / 160`. -/
@[eval_problem]
theorem pardon_torus_knot_distortion
    (p q : ℕ) (_hp : 0 < p) (_hq : 0 < q) (_hc : Nat.Coprime p q)
    (K : Knot)
    (_hclass : ∃ Φ : AmbientIsotopy, ∃ σ : CircleReparam,
      ∀ t, Φ.H 1 (K.curve t) = standardTorusCurve p q (σ.f t)) :
    (1 / 160 : ℝ≥0∞) * (Nat.min p q : ℝ≥0∞) ≤ distortion K := by
  sorry

end

end PardonDistortion
end KnotTheory
end LeanEval
