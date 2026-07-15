import Mathlib

namespace LeanEval
namespace Geometry
namespace SardTheoremProblem

/-!
# Sard's theorem (Morse 1939 / Sard 1942), Knill's rank-deficient form

For a smooth map `f : ℝᵐ → ℝⁿ`, the image of the rank-deficient set
`{x | rank df(x) < m ∧ rank df(x) < n}` — points where the Jacobian
`df(x)` is neither injective nor surjective — has Lebesgue measure
zero. The manifold form follows from this Euclidean version
chart-by-chart, so the substance of the theorem lives at the
Euclidean level used here. §125 of Knill's *Some Fundamental Theorems
in Mathematics*.

This is Knill's specific phrasing: "rank smaller than both `m` and
`n`". The standard textbook Sard theorem instead defines critical
points by `rank df(x) < n` (failure of surjectivity), which is a
weaker condition than Knill's and produces a larger critical set; the
textbook statement therefore *implies* the form proved here. The two
agree when `m ≥ n`; for `m < n` a smooth immersion has every point
critical under the textbook definition but no critical points under
Knill's.

Mathlib has the equal-dimension case `μ (f '' s) = 0` when
`det (f' x) = 0` on `s`
(`MeasureTheory.addHaar_image_eq_zero_of_det_fderivWithin_eq_zero`)
plus topological corollaries via Hausdorff dimension, but no general
critical-value / Sard statement.
-/

open MeasureTheory Module
open scoped ContDiff

/-- The Euclidean model space `ℝⁿ`. -/
abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- The rank of the Fréchet derivative of `f` at `x`. -/
noncomputable def fderivRank {m n : ℕ} (f : E m → E n) (x : E m) : ℕ :=
  finrank ℝ (LinearMap.range (fderiv ℝ f x).toLinearMap)

/-- A **critical point** of `f` (Knill's definition): a point where
`df(x)` has rank less than both `m` and `n`, so `df(x)` fails to have
full rank `min m n`. Weaker than the textbook condition
`rank df(x) < n`; see the module docstring. -/
def IsCriticalPoint {m n : ℕ} (f : E m → E n) (x : E m) : Prop :=
  fderivRank f x < m ∧ fderivRank f x < n

/-- The **critical values** of `f`: the image in `ℝⁿ` of the
rank-deficient locus. -/
def criticalValues {m n : ℕ} (f : E m → E n) : Set (E n) :=
  f '' {x | IsCriticalPoint f x}



end SardTheoremProblem
end Geometry
end LeanEval
