import Mathlib.Analysis.Calculus.FDeriv.Defs
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import EvalTools.Markers

/-!
# Holomorphy of integrated sums of powers with positive bases

Let `r i` be positive measurable real-valued functions on a measure space. Suppose
the integral of the sum of their real powers is finite for every exponent greater
than `a`. Then their complex powers have an integrable sum for each `z` in the
half-plane `a < z.re`, and integrating this sum gives a holomorphic function there.

This statement occurs as `GlobalTheory.T.dirichlet_series_integral_holomorphic`
in the Riemann hypothesis development, at commit
`2f097b744a6460c73f3e4cc550baa83698409876`, in
`Development/AbelianVarietyTheory/Proofs/DivisorProofs/DirichletSeriesIntegralHolomorphicStatement.lean`.
The hypotheses and conclusions are preserved, including the arbitrary index type
and measure. Only Mathlib definitions are needed to state the problem.
-/

namespace LeanEval.ComplexAnalysis

open MeasureTheory

/-- Finite integrated real-power sums on a half-plane imply integrability of the
complex-power sums and holomorphy of their integral on that half-plane. -/
@[eval_problem]
theorem integrated_power_sums_holomorphic
    {X I : Type} [MeasurableSpace X]
    (μ : Measure X) (r : I → X → ℝ) (a : ℝ)
    (_hmeasurable : ∀ i, Measurable (r i))
    (_hpositive : ∀ i x, 0 < r i x)
    (_hfinite : ∀ σ : ℝ, a < σ →
      ∫⁻ x, ∑' i, ENNReal.ofReal (r i x ^ σ) ∂μ < ⊤) :
    (∀ z : ℂ, a < z.re →
      Integrable (fun x ↦ ∑' i, (r i x : ℂ) ^ z) μ) ∧
    DifferentiableOn ℂ
      (fun z : ℂ ↦ ∫ x, ∑' i, (r i x : ℂ) ^ z ∂μ)
      {z | a < z.re} := by
  sorry

end LeanEval.ComplexAnalysis
