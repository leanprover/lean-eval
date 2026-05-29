import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace WhitneyEmbeddingProblem

/-!
# Whitney embedding theorem (strong form, sharp dimension `2n`)

Any smooth `n`-manifold `M` (`n ≥ 1`, Hausdorff and second-countable)
admits a smooth embedding into `ℝ^{2n}`. Hassler Whitney, *The
self-intersections of a smooth n-manifold in 2n-space*, Ann. of Math.
**45** (1944). §112 in Knill's *Some Fundamental Theorems in
Mathematics*.

A smooth embedding here is a smooth map (`ContMDiff … ∞`) that is
simultaneously a topological embedding (`IsEmbedding`) and an immersion
(the manifold differential `mfderiv` is injective at every point) — the
standard mathlib triple that captures "smooth injection whose image is
diffeomorphic to the source".

Mathlib's `SmoothBumpCovering.exists_embedding_euclidean_of_compact`
proves the easy compact form (some `ℝ^k`, no dimension bound, requires
compactness). The sharp `2n` bound here is the strong Whitney theorem,
whose proof passes through the *Whitney trick* (cancelling pairs of
self-intersections); mathlib has neither Sard's theorem nor the Whitney
trick. The `n = 0` case is excluded because the strong Whitney bound is
false there: a countable discrete `0`-manifold embeds in `ℝ¹` but not
in `ℝ⁰ = {0}` once it has two points.
-/

open scoped Manifold ContDiff
open Topology

/-- **Whitney embedding theorem** (Whitney 1944). Every smooth
`n`-manifold (`n ≥ 1`, Hausdorff, second-countable) admits a smooth
embedding into `ℝ^{2n}`. -/
@[eval_problem]
theorem whitney_embedding (n : ℕ) (_hn : 1 ≤ n)
    {M : Type*} [TopologicalSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin n)) M] [IsManifold (𝓡 n) ∞ M]
    [T2Space M] [SecondCountableTopology M] :
    ∃ e : M → EuclideanSpace ℝ (Fin (2 * n)),
      ContMDiff (𝓡 n) (𝓡 (2 * n)) ∞ e ∧
      IsEmbedding e ∧
      ∀ x : M, Function.Injective (mfderiv (𝓡 n) (𝓡 (2 * n)) e x) := by
  sorry

end WhitneyEmbeddingProblem
end Geometry
end LeanEval
