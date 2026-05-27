import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Dynamics

/-!
# Furstenberg multiple recurrence (measure-preserving version) (Furstenberg 1977)

§56 of Knill's *Some Fundamental Theorems in Mathematics* (additional
statement). For every measure-preserving self-map `T` of a probability
space `(Ω, μ)`, every measurable `A` of positive measure, and every
length `d ≥ 1`, there is an integer `n ≥ 1` with
`μ(A ∩ T^{-n}A ∩ T^{-2n}A ∩ ⋯ ∩ T^{-d·n}A) > 0`.

Knill formulates this for an "automorphism" with `T_j(A) = T^j(A)` and
asks for `P[A ∩ T_1(A) ∩ ⋯ ∩ T_d(A)] > 0`. The Lean uses preimages,
which agree with images for an invertible measure-preserving `T` modulo
a change of variables and is the standard formulation for general
(non-invertible) measure-preserving maps. The `d = 1` case is the
classical Poincaré recurrence theorem.

Mathlib has `MeasurePreserving`, `IsProbabilityMeasure`, and Poincaré
recurrence for `d = 1` (`Conservative.ae_mem_imp_frequently_image_mem`
in `Mathlib/Dynamics/Ergodic/Conservative.lean`), but no `d ≥ 2`
multiple recurrence — `grep -ri "furstenberg\|multiple.recurr"` returns
nothing across mathlib. Furstenberg's theorem is the dynamical input to
the Furstenberg–Katznelson proof of Szemerédi's theorem, which is also
absent (only Roth's theorem `k = 3` is in mathlib, at
`Combinatorics/Additive/Corner/Roth.lean`). No open PR for `furstenberg`
or "multiple recurrence" (verified 2026-05-27 against v4.30.0-rc1).
-/

open MeasureTheory

/-- **Furstenberg's multiple recurrence theorem** (measure-preserving
version). For every measure-preserving `T` on a probability space, every
measurable `A` of positive measure, and every `d ≥ 1`, some `n ≥ 1`
satisfies `μ(A ∩ ⋂_{j=1}^{d} T^[j n] ⁻¹' A) > 0`. -/
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
