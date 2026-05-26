import LeanEval.KnotTheory.ConwayKnot
import EvalTools.Markers

namespace LeanEval
namespace KnotTheory

/-!
# The Conway knot is not smoothly slice

Lisa Piccirillo, *The Conway knot is not slice* (Annals of Mathematics,
2020; arXiv 1808.02923). Piccirillo resolved the last remaining case in
the classification of slice knots through 12 crossings by showing the
Conway knot 11n34 is not smoothly slice. Combined with
`ConwayTopologicallySlice`, this is a celebrated small witness in the
smooth/topological slice gap (earlier explicit witnesses such as the
Akbulut–Matveyev positive Whitehead doubles existed; Conway is notable
for its low crossing number and its history as a long-standing open case).

Piccirillo's strategy: exhibit a knot `K'` having the same `0`-trace as
the Conway knot. The trace-embedding argument then transfers sliceness:
if the Conway knot were smoothly slice, `K'` would be smoothly slice as
well. A direct Khovanov-homological computation shows Rasmussen's
`s`-invariant satisfies `s(K') ≠ 0`, contradicting smooth sliceness of
`K'`. Note that for the Conway knot itself the standard smooth slice
obstructions `s` and `τ` both vanish, which is why this trace-embedding
detour through `K'` is needed.
-/

/-- **Piccirillo, "The Conway knot is not slice."**

The Conway knot 11n34 does not bound a smoothly properly embedded 2-disk
in `ℝ³ × [0, ∞)`. -/
@[eval_problem]
theorem conway_knot_not_smoothly_slice : ¬ conwayKnot.SmoothlySlice := by
  sorry

end KnotTheory
end LeanEval
