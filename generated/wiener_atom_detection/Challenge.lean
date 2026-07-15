import ChallengeDeps

open LeanEval.Analysis
open MeasureTheory Filter Topology Real Complex

theorem wiener_atom_detection (μ : Measure (AddCircle (2 * Real.pi))) [IsProbabilityMeasure μ] :
    Tendsto
      (fun N : ℕ =>
        (1 / (N : ℝ)) *
          ∑ k ∈ Finset.Icc (1 : ℤ) N, ‖fourierCoeffMeasure μ k‖ ^ 2)
      atTop
      (𝓝 (∑' x : AddCircle (2 * Real.pi), ((μ {x}).toReal) ^ 2)) := by
  sorry
