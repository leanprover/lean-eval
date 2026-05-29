import ChallengeDeps
import Submission

open LeanEval.ComplexAnalysis

theorem poincare_siegel (α : ℝ) (_hα : IsDiophantine α)
    (lam : ℂ) (_hlam : lam = Complex.exp (2 * Real.pi * Complex.I * (α : ℂ)))
    (f : ℂ → ℂ) (_hf : AnalyticAt ℂ f 0) (_hf0 : f 0 = 0)
    (_hmult : deriv f 0 = lam) :
    ∃ u : ℂ → ℂ, AnalyticAt ℂ u 0 ∧ u 0 = 0 ∧ deriv u 0 = 1 ∧
      ∀ᶠ z in nhds (0 : ℂ), f (u z) = u (lam * z) := by
  exact Submission.poincare_siegel α _hα lam _hlam f _hf _hf0 _hmult
