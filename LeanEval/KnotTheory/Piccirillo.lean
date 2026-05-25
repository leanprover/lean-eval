import LeanEval.KnotTheory.ConwayKnot
import EvalTools.Markers

namespace LeanEval
namespace KnotTheory

/-!
# The Conway knot is not smoothly slice

Lisa Piccirillo, *The Conway knot is not slice* (Annals of Mathematics,
2020; arXiv 1808.02923). The Conway knot 11n34 is the smallest non-slice
knot, completing the classification of slice knots through 12 crossings.
Combined with `ConwayTopologicallySlice`, this gives the first explicit
witness in the smooth/topological slice gap.

Piccirillo's strategy: exhibit a knot `K'` having the same `0`-trace as
the Conway knot. Since the `0`-trace determines the smooth slice genus
(up to 4-manifold-level work), `K'` has smooth slice genus equal to that
of the Conway knot, and a direct computation shows Rasmussen's
`s`-invariant satisfies `s(K') ≠ 0`. Standard slice obstructions of this
flavour are Rasmussen's `s` and the Ozsváth–Szabó `τ`-invariant.
-/

/-- **Piccirillo, "The Conway knot is not slice."**

The Conway knot 11n34 does not bound a smoothly properly embedded 2-disk
in `ℝ³ × [0, ∞)`. -/
@[eval_problem]
theorem conway_knot_not_smoothly_slice : ¬ conwayKnot.SmoothlySlice := by
  sorry

end KnotTheory
end LeanEval
