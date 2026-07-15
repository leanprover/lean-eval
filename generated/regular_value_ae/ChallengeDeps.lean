import Mathlib

namespace LeanEval.Geometry.RegularValue

/-!
# Sard's regular-value corollary

`regular_value_ae`: for a smooth `f : ℝᵐ → ℝ`, almost every `c ∈ ℝ` is a regular
value (every point of the level set `f⁻¹(c)` has nonzero derivative). This is the
measure-theoretic heart of the regular-value form of Sard's theorem; the main
critical-set-null Sard theorem is already in lean-eval (§125 main / `sard`).
The trusted helper `IsRegularValue` is a non-hole. Mathlib has the equal-
dimension Jacobian-null lemma and Hausdorff-dimension corollaries but not the
general critical-values-are-null statement.

Category-(b) candidate from §125 of the Knill survey (additional statement 1).
-/

open MeasureTheory
open scoped ContDiff

/-- `c` is a **regular value** of `f : ℝᵐ → ℝ`: every point of the level set
`f⁻¹(c)` has nonzero derivative. -/
def IsRegularValue {m : ℕ} (f : EuclideanSpace ℝ (Fin m) → ℝ) (c : ℝ) : Prop :=
  ∀ x, f x = c → fderiv ℝ f x ≠ 0



end LeanEval.Geometry.RegularValue
