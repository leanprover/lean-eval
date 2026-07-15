import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry

/-!
# Isoperimetric inequality (`n`-dimensional, topological-frontier form)

For any measurable bounded `B ⊆ ℝⁿ` with `n ≥ 2`,

  `n^n · volume(B)^{n−1} · volume(closedBall 0 1) ≤ μHE[n−1](frontier B)^n`,

where `μHE[n−1]` is the `(n−1)`-dimensional Euclidean Hausdorff measure
on the topological frontier. For a smooth bounded domain with regular
bounding hypersurface `S = frontier B`, `μHE[n−1] (frontier B)` agrees
with the classical surface area, so the statement specialises to the
smooth form Knill writes in §63 of *Some Fundamental Theorems in
Mathematics*.

This is the topological-frontier formulation, not the canonical De
Giorgi finite-perimeter form. The topological frontier of a measurable
set can strictly contain its reduced boundary, so this is a strictly
weaker inequality than the perimeter-level statement, but valid for
any measurable bounded set.

The `n = 1` case is excluded because the `ENNReal` formulation fails
for `B = ∅`: `0^0 · vol(B₁) = 2` while `μHE[0](∅) = 0`.
-/

open MeasureTheory ENNReal Metric

/-- The Euclidean model space `ℝⁿ`. -/
abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- **Isoperimetric inequality** (`n`-dim, topological-frontier form).
For any measurable bounded `B ⊆ ℝⁿ` with `n ≥ 2`,
`n^n · volume B^{n−1} · volume (closedBall 0 1) ≤ μHE[n−1] (frontier B)^n`. -/
@[eval_problem]
theorem isoperimetric (n : ℕ) (_hn : 2 ≤ n) (B : Set (E n))
    (_hB : MeasurableSet B) (_hBdd : Bornology.IsBounded B) :
    (n : ℝ≥0∞) ^ n * (volume B) ^ (n - 1) * volume (closedBall (0 : E n) 1)
      ≤ (μHE[n - 1] (frontier B)) ^ n := by
  sorry

end Geometry
end LeanEval
