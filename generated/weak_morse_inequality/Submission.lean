import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.WeakMorseInequality
open scoped Manifold ContDiff Topology
open CategoryTheory

namespace Submission

theorem weak_morse_inequality {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H} [I.Boundaryless]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M] [IsManifold I ∞ M]
    [CompactSpace M] [T2Space M] (f : M → ℝ) (_hf : IsMorseFunction I f) (k : ℕ) :
    bettiNumber M k ≤ morseCount I f k := by
  sorry

end Submission
