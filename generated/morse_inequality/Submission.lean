import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.MorseInequalities
open scoped Manifold ContDiff Topology
open CategoryTheory

namespace Submission

theorem morse_inequality {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H} [I.Boundaryless]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M] [IsManifold I ∞ M]
    [CompactSpace M] [T2Space M] (f : M → ℝ) (_hf : IsMorseFunction I f) (k : ℕ) :
    alternatingPartialSum (bettiNumber M) k ≤
      alternatingPartialSum (morseCount I f) k := by
  sorry

end Submission
