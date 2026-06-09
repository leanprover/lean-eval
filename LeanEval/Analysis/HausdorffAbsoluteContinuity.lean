import Mathlib
import EvalTools.Markers

namespace LeanEval.Analysis.HausdorffAbsoluteContinuity

/-!
# Hausdorff moment problem: absolute-continuity criterion

`hausdorff_absolute_continuity`: a positive probability measure `μ` on the unit
cube is uniformly absolutely continuous with respect to Lebesgue measure iff its
moment differences are dominated by those of Lebesgue measure. This is the third
statement of §115 of the Knill survey (the moment realizability and positivity
criteria are the companion lean-eval problems). The trusted helpers (`cube`,
`monomial`, `momentOf`, `multiChoose`, `diff`, `UniformlyAbsolutelyContinuous`)
are non-holes. Mathlib has `SignedMeasure`, finite measures, and set integrals
but no moment-problem machinery.

Category-(b) candidate from §115 of the Knill survey (additional statement 2).
-/

open MeasureTheory
open scoped BigOperators NNReal

/-- The closed unit cube `Iᵈ = [0,1]ᵈ ⊆ ℝᵈ`. -/
def cube (d : ℕ) : Set (EuclideanSpace ℝ (Fin d)) :=
  {x | ∀ i, x i ∈ Set.Icc (0 : ℝ) 1}

/-- The monomial `xⁿ = ∏ᵢ xᵢ^{nᵢ}`. -/
def monomial {d : ℕ} (n : Fin d → ℕ) (x : EuclideanSpace ℝ (Fin d)) : ℝ :=
  ∏ i, (x i) ^ (n i)

/-- The `n`-th moment `∫_{Iᵈ} xⁿ dμ`. -/
noncomputable def momentOf {d : ℕ} (μ : Measure (EuclideanSpace ℝ (Fin d)))
    (n : Fin d → ℕ) : ℝ :=
  ∫ x in cube d, monomial n x ∂μ

/-- The multi-index binomial coefficient `C(n,k) = ∏ᵢ C(nᵢ, kᵢ)`. -/
def multiChoose {d : ℕ} (n k : Fin d → ℕ) : ℕ := ∏ i, (n i).choose (k i)

/-- The iterated backward partial difference `(Δᵏa)ₙ` in closed form. -/
noncomputable def diff {d : ℕ} (a : (Fin d → ℕ) → ℝ) (k n : Fin d → ℕ) : ℝ :=
  ∑ j ∈ Finset.Iic k,
    (-1 : ℝ) ^ (∑ i, (k i - j i)) * (multiChoose k j : ℝ) * a (n - j)

/-- `μ` is **uniformly absolutely continuous** w.r.t. `ν`: `μ ≤ C • ν` for some
constant `C` (an essentially-bounded Radon–Nikodym density). -/
def UniformlyAbsolutelyContinuous {d : ℕ}
    (μ ν : Measure (EuclideanSpace ℝ (Fin d))) : Prop :=
  ∃ C : ℝ≥0, μ ≤ C • ν

/-- **Absolute continuity criterion (Hausdorff moment problem).** A positive
probability measure `μ` on the cube is uniformly absolutely continuous w.r.t.
Lebesgue measure iff there is `C` with `(Δᵏμ)ₙ ≤ C·(Δᵏν)ₙ` for all `k ≤ n`. -/
@[eval_problem]
theorem hausdorff_absolute_continuity {d : ℕ}
    (μ : Measure (EuclideanSpace ℝ (Fin d)))
    [IsProbabilityMeasure μ] (hμ : μ ((cube d)ᶜ) = 0) :
    UniformlyAbsolutelyContinuous μ (volume.restrict (cube d)) ↔
      ∃ C : ℝ, ∀ k n : Fin d → ℕ, k ≤ n →
        diff (momentOf μ) k n ≤ C * diff (momentOf (volume.restrict (cube d))) k n := by
  sorry

end LeanEval.Analysis.HausdorffAbsoluteContinuity
