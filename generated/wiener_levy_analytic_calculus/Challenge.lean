import ChallengeDeps

open LeanEval.Analysis.WienerLevy
open Set
open scoped ComplexConjugate Real

variable {T : ℝ} [Fact (0 < T)]

theorem wiener_levy_analytic_calculus (f : C(AddCircle T, ℂ))
    (φ : ℂ → ℂ) (U : Set ℂ) (hf : InWienerAlgebra f)
    (hU : IsOpen U) (hrange : range f ⊆ U)
    (hφ : AnalyticOnNhd ℂ φ U) :
    ∃ g : C(AddCircle T, ℂ),
      (∀ x, g x = φ (f x)) ∧ InWienerAlgebra g := by
  sorry
