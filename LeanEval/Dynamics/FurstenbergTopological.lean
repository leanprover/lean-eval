import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Dynamics

/-!
# Furstenberg multiple recurrence (topological version) (Furstenberg–Weiss 1978)

§56 of Knill's *Some Fundamental Theorems in Mathematics*. For every
homeomorphism `T` of a nonempty compact metric space `X`, there exists a
point `x ∈ X` that is **multiply recurrent**: for every recurrence
length `d ≥ 1`, the orbits of `x` under `T, T², …, T^d` simultaneously
return arbitrarily close to `x` along a single common time sequence.

Knill writes `T_j(x) = T^j x`, so `T_j^{n_k}(x) = T^{j · n_k}(x)`. The
recurrence statement is: for every `d ≥ 1` there is a strictly
increasing `n : ℕ → ℕ` with `T^{j · n_k}(x) → x` as `k → ∞`, for every
`j ∈ {1, …, d}`.

The compact-**metric** hypothesis is essential under this sequential
formulation. An earlier version that asked only for `[CompactSpace X]`
on an arbitrary topological space was disproved during validation, with
the shift on `Ultrafilter ℤ` (compact Hausdorff but not first-countable)
as counterexample — every convergent sequence in `Ultrafilter ℤ` is
eventually constant, so `T^{j · n_k}(x) → x` along a strictly
increasing `n_k` would force `n_k = 0` eventually, contradicting strict
monotonicity. First-countability would also suffice, but the classical
Furstenberg–Weiss (1978) statement is for compact metric.

Mathlib has `Homeomorph` (`X ≃ₜ X`), `Function.iterate`, and
`Filter.Tendsto … atTop (𝓝 x)`. The single-set Poincaré recurrence (the
`d = 1` case) is in `Mathlib/Dynamics/Ergodic/Conservative.lean` as
`Conservative.ae_mem_imp_frequently_image_mem`. Multiple recurrence for
`d ≥ 2` is absent from mathlib — `grep -ri "furstenberg\|multiple.recurr"`
returns nothing — and there is no in-flight PR (verified 2026-05-27).
-/

open Filter Topology

/-- A point `x : X` is **multiply recurrent** for the self-map `T : X → X`
if for every recurrence length `d ≥ 1` there exists a strictly increasing
sequence `n : ℕ → ℕ` such that for every `j ∈ {1, …, d}` the subsequence
`k ↦ T^{j · n_k}(x)` converges to `x`. -/
def IsMultiplyRecurrent {X : Type*} [TopologicalSpace X]
    (T : X → X) (x : X) : Prop :=
  ∀ d : ℕ, 1 ≤ d →
    ∃ n : ℕ → ℕ, StrictMono n ∧
      ∀ j : ℕ, 1 ≤ j → j ≤ d →
        Tendsto (fun k : ℕ => T^[j * n k] x) atTop (𝓝 x)

/-- **Furstenberg's multiple recurrence theorem** (topological version).
Every homeomorphism `T` of a nonempty compact metric space `X` has a
multiply recurrent point. -/
@[eval_problem]
theorem furstenberg_topological_recurrence {X : Type*} [MetricSpace X]
    [CompactSpace X] [Nonempty X] (T : X ≃ₜ X) :
    ∃ x : X, IsMultiplyRecurrent (T : X → X) x := by
  sorry

end Dynamics
end LeanEval
