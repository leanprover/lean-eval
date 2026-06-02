import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace SardTheoremProblem

/-!
# Sard's theorem (Morse 1939 / Sard 1942)

For a smooth map `f : ℝᵐ → ℝⁿ`, the image of the set where the Jacobian
`df(x)` does not have full rank — equivalently, where the rank is less
than both `m` and `n`, so `df(x)` is neither injective nor surjective —
has Lebesgue measure zero. The manifold form follows from the
finite-dimensional Euclidean version chart-by-chart, so the substance
of the theorem lives at the Euclidean level used here. §125 of Knill's
*Some Fundamental Theorems in Mathematics*.

Mathlib has the equal-dimension case `μ (f '' s) = 0` when `det (f' x) = 0`
on `s` (`MeasureTheory.addHaar_image_eq_zero_of_det_fderivWithin_eq_zero`),
plus topological corollaries via Hausdorff dimension, but no general
critical-set / Sard statement.
-/

open MeasureTheory Module
open scoped ContDiff

/-- The Euclidean model space `ℝⁿ`. -/
abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- The rank of the Fréchet derivative of `f` at `x`. -/
noncomputable def fderivRank {m n : ℕ} (f : E m → E n) (x : E m) : ℕ :=
  finrank ℝ (LinearMap.range (fderiv ℝ f x).toLinearMap)

/-- A **critical point** of `f`: a point where `df(x)` has rank less
than both `m` and `n`, so `df(x)` fails to have full rank `min m n`. -/
def IsCriticalPoint {m n : ℕ} (f : E m → E n) (x : E m) : Prop :=
  fderivRank f x < m ∧ fderivRank f x < n

/-- The **critical set** of `f`: the image in `ℝⁿ` of the set of
critical points (the "critical values"). -/
def criticalSet {m n : ℕ} (f : E m → E n) : Set (E n) :=
  f '' {x | IsCriticalPoint f x}

/-- **Sard's theorem** (Morse 1939 / Sard 1942). The critical set of a
smooth map `f : ℝᵐ → ℝⁿ` has zero Lebesgue measure in `ℝⁿ`. -/
@[eval_problem]
theorem sard {m n : ℕ} (f : E m → E n) (_hf : ContDiff ℝ ∞ f) :
    volume (criticalSet f) = 0 := by
  sorry

end SardTheoremProblem
end Geometry
end LeanEval
