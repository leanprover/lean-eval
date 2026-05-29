import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Dynamics

/-!
# Furstenberg measure-preserving multiple recurrence (Furstenberg 1977)

For every measure-preserving self-map `T` of a probability space
`(Ω, μ)`, every measurable set `A` of positive measure, and every
`d ≥ 1`, there is an integer `n ≥ 1` with

  `μ(A ∩ T^{-n}A ∩ T^{-2n}A ∩ ⋯ ∩ T^{-d·n}A) > 0`.

§56 of Knill's *Some Fundamental Theorems in Mathematics* (additional
statement). Knill writes the statement for an automorphism using
images `T^j(A)`; this file states the standard preimage version for a
general measure-preserving transformation. For invertible `T` the two
formulations are equivalent: apply the preimage statement to `T⁻¹` (or
shift the intersection by an iterate of `T`).

The `d = 1` case is the classical Poincaré recurrence theorem.
-/

open MeasureTheory

/-- **Furstenberg's multiple recurrence theorem** (measure-preserving
version). For every measure-preserving `T` on a probability space,
every measurable `A` of positive measure, and every `d ≥ 1`, some
`n ≥ 1` satisfies `μ(A ∩ ⋂_{j=1}^{d} T^[j n] ⁻¹' A) > 0`. -/
@[eval_problem]
theorem furstenberg_measure_recurrence {Ω : Type*}
    [MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω)
    [MeasureTheory.IsProbabilityMeasure μ]
    {T : Ω → Ω} (_hT : MeasureTheory.MeasurePreserving T μ μ)
    {A : Set Ω} (_hA : MeasurableSet A) (_h0 : 0 < μ A)
    (d : ℕ) (_hd : 1 ≤ d) :
    ∃ n : ℕ, 1 ≤ n ∧
      0 < μ (A ∩ ⋂ j ∈ Finset.Icc 1 d, T^[j * n] ⁻¹' A) := by
  sorry

end Dynamics
end LeanEval
