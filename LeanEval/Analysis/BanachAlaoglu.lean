import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Bourbaki's locally convex extension of Banach–Alaoglu

§137 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. The classical
Banach–Alaoglu theorem — the closed unit ball of the dual of a Banach space is
weak-star compact — is already in mathlib (`WeakDual.isCompact_closedBall`).
Bourbaki's extension drops the norm: for any real locally convex topological
vector space `E`, the weak-star polar of a neighbourhood of `0` is compact in
the weak dual, extending the statement from closed dual balls to polars of
zero-neighbourhoods in arbitrary locally convex spaces.

mathlib has the normed-space results `WeakDual.isCompact_closedBall` and
`WeakDual.isCompact_polar`, but no corresponding compactness theorem for general
locally convex spaces.
-/

open Set Topology

/-- The weak-star polar of a subset `s` of a real locally convex space `E`:
the continuous functionals `φ` with `‖φ x‖ ≤ 1` for every `x ∈ s`. -/
def weakStarPolar (E : Type*) [AddCommGroup E] [Module ℝ E] [TopologicalSpace E]
    [ContinuousAdd E] [ContinuousSMul ℝ E] (s : Set E) : Set (WeakDual ℝ E) :=
  {φ | ∀ x ∈ s, ‖φ x‖ ≤ 1}

/-- **Bourbaki's locally convex extension of Banach–Alaoglu** (§137). The
weak-star polar of a zero-neighbourhood `U` in a real locally convex space `E`
is weak-star compact. -/
@[eval_problem]
theorem banach_alaoglu_bourbaki (E : Type*) [AddCommGroup E] [Module ℝ E]
    [TopologicalSpace E] [ContinuousAdd E] [ContinuousSMul ℝ E]
    [LocallyConvexSpace ℝ E] (U : Set E) (_hU : U ∈ 𝓝 (0 : E)) :
    IsCompact (weakStarPolar E U) := by
  sorry

end Analysis
end LeanEval
