import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis.WignerSemicircleProblem
open scoped ENNReal NNReal Topology
open MeasureTheory ProbabilityTheory Filter

namespace Submission

theorem wigner_semicircle {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ℕ → ℕ → Ω → ℝ)
    (_hX_meas : ∀ i j, Measurable (X i j))
    (_hX_indep : iIndepFun
      (fun ij : {p : ℕ × ℕ // p.1 ≤ p.2} => X ij.val.1 ij.val.2) μ)
    (_hX_iid : ∀ i j i' j', i ≤ j → i' ≤ j' →
      ProbabilityTheory.IdentDistrib (X i j) (X i' j') μ μ)
    (_hX_int : ∀ i j, i ≤ j → Integrable (X i j) μ)
    (_hX_sq_int : ∀ i j, i ≤ j → Integrable (fun ω => (X i j ω) ^ 2) μ)
    (_hX_mean : ∀ i j, i ≤ j → ∫ ω, X i j ω ∂μ = 0)
    (_hX_var : ∀ i j, i ≤ j → ∫ ω, (X i j ω) ^ 2 ∂μ = 1) :
    ∀ᵐ ω ∂μ,
      ∀ (f : ℝ → ℝ), Continuous f → (∃ M, ∀ x, ‖f x‖ ≤ M) →
        Tendsto
          (fun n : ℕ =>
            ∫ x, f x ∂ (empiricalSpectralMeasureHerm
              (wignerMatrix_isHermitian X n ω)).map
                (fun x : ℝ => x / Real.sqrt n))
          atTop (𝓝 (∫ x, f x ∂semicircleLaw)) := by
  sorry

end Submission
