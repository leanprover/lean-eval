import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace PoincareConjectureProblem

/-!
# Poincaré conjecture (Perelman 2003)

A closed (compact, boundaryless), simply-connected, smooth 3-manifold
`M` is homeomorphic to the standard 3-sphere `S³ ⊂ ℝ⁴`. Conjectured by
Poincaré (1904); proved by Grigori Perelman (2003) via Hamilton's Ricci
flow with surgery. Wiedijk-100 #84; §132 in Knill's *Some Fundamental
Theorems in Mathematics*.

`[I.Boundaryless]` makes "closed" mean *without boundary* (otherwise the
3-disk `D³` is a counterexample); `[T2Space M]` is the standard
Hausdorffness convention; `SimplyConnectedSpace M` is Knill's
"connected + trivial `π₁`" and already entails `Nonempty M`.

Mathlib v4.30 ships `Mathlib/Geometry/Manifold/PoincareConjecture.lean`
(Junyan Xu 2024) with this statement as `proof_wanted`
(`SimplyConnectedSpace.nonempty_homeomorph_sphere_three`) using a
topological framing; the proof — Ricci flow with surgery — is absent.
-/

open scoped Manifold ContDiff Topology ContinuousMap
open Metric

/-- **Poincaré conjecture** (Poincaré 1904, Perelman 2003). A closed
(compact, boundaryless), simply-connected, smooth 3-manifold `M` is
homeomorphic to the standard 3-sphere `S³ ⊂ ℝ⁴`. -/
@[eval_problem]
theorem poincare_conjecture
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E] [CompleteSpace E]
    {H : Type*} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    (M : Type*) [TopologicalSpace M] [ChartedSpace H M] [IsManifold I ∞ M]
    [I.Boundaryless] [T2Space M] [CompactSpace M] [SimplyConnectedSpace M]
    (_hdim : Module.finrank ℝ E = 3) :
    Nonempty (M ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) := by
  sorry

end PoincareConjectureProblem
end Geometry
end LeanEval
