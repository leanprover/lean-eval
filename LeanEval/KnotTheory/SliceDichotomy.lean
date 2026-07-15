import LeanEval.KnotTheory.Slice
import EvalTools.Markers

namespace LeanEval
namespace KnotTheory

/-!
# Existence of a topologically slice, not smoothly slice knot

The Casson / Akbulut–Matveyev / Hedden–Kirk–Livingston dichotomy in
dimension four: there exist knots in `S³` that bound a locally flat
topological disk in the 4-ball but no smoothly embedded one. This problem
asks only for some such knot; the celebrated specific witness — the
Conway knot 11n34 — is the subject of `Piccirillo` and
`ConwayTopologicallySlice`.

Rasmussen's `s`-invariant and the Ozsváth–Szabó `τ`-invariant obstruct
*smooth* sliceness: `s(K) ≠ 0` (or `τ(K) ≠ 0`) implies `K` is not
smoothly slice. Topologically slice knots can perfectly well have
nonzero `s` and `τ` — which is exactly how witnesses to this dichotomy
are detected. The easiest historical example is the positive Whitehead
double of the right-handed trefoil: trivial Alexander polynomial gives
topological sliceness by Freedman, and `τ ≠ 0` rules out smooth
sliceness (Akbulut–Matveyev).
-/

/-- **Existence of a topologically slice, not smoothly slice knot.**

There exists a piecewise-linear knot in `ℝ³` that bounds a locally flat
topological 2-disk in `ℝ³ × [0, ∞)` but no smoothly properly embedded
2-disk in `ℝ³ × [0, ∞)`.

This was first established by Casson; explicit examples were given by
Akbulut–Matveyev and Hedden–Kirk–Livingston. The solver may take any
witness — historically tractable ones are positive Whitehead doubles
of certain knots (Akbulut–Matveyev, 1997). -/
@[eval_problem]
theorem exists_topologically_slice_not_smoothly_slice :
    ∃ K : PLKnot, K.TopologicallySlice ∧ ¬ K.SmoothlySlice := by
  sorry

end KnotTheory
end LeanEval
