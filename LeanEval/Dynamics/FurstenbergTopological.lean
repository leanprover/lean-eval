import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Dynamics

/-!
# Furstenberg–Weiss topological multiple recurrence (single-transformation form)

For every homeomorphism `T` of a nonempty compact metric space `X`,
there is a point `x ∈ X` that is **multiply recurrent**: for every
`d ≥ 1`, the iterates `T, T², …, T^d` of `x` return arbitrarily close
to `x` along a single common time sequence — `T^{j · n_k}(x) → x` as
`k → ∞` for every `j ∈ {1, …, d}`, with a strictly increasing
`n : ℕ → ℕ` shared across `j`.

This is the single-transformation formulation in Knill §56, which
specialises the full Furstenberg–Weiss recurrence theorem to the
family `T, T², …, T^d` instead of arbitrary commuting homeomorphisms.

Compact-Hausdorff alone is insufficient for this sequential
formulation: on the shift over `Ultrafilter ℤ` (compact Hausdorff, not
first-countable), every convergent sequence is eventually constant, so
`T^{j · n_k}(x) → x` along a strictly increasing `n_k` would force
`n_k = 0` eventually. First-countability would suffice as a hypothesis;
the compact-metric form is the standard Furstenberg–Weiss statement.
-/

open Filter Topology

/-- A point `x : X` is **multiply recurrent** for `T : X → X` if for
every `d ≥ 1` there is a strictly increasing `n : ℕ → ℕ` such that
`T^{j · n_k}(x) → x` for every `j ∈ {1, …, d}`. -/
def IsMultiplyRecurrent {X : Type*} [TopologicalSpace X]
    (T : X → X) (x : X) : Prop :=
  ∀ d : ℕ, 1 ≤ d →
    ∃ n : ℕ → ℕ, StrictMono n ∧
      ∀ j : ℕ, 1 ≤ j → j ≤ d →
        Tendsto (fun k : ℕ => T^[j * n k] x) atTop (𝓝 x)

/-- **Furstenberg–Weiss topological multiple recurrence** (single-
transformation form). Every homeomorphism `T` of a nonempty compact
metric space `X` has a multiply recurrent point. -/
@[eval_problem]
theorem furstenberg_topological_recurrence {X : Type*} [MetricSpace X]
    [CompactSpace X] [Nonempty X] (T : X ≃ₜ X) :
    ∃ x : X, IsMultiplyRecurrent (T : X → X) x := by
  sorry

end Dynamics
end LeanEval
