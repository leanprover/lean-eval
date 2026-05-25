import LeanEval.KnotTheory.Slice
import LeanEval.KnotTheory.BraidClosure

namespace LeanEval
namespace KnotTheory

/-!
# The Conway knot 11n34 as a PL knot

The Conway knot has braid index 4 and a standard 4-braid representation in
KnotInfo. We package the resulting polyline as a `PLKnot`.

Both `three_le` and `isSimple` are auxiliary `sorry`s: discharging them
amounts to verifying basic combinatorial / geometric facts about a fixed
finite vertex list, work that is independent of the slice-theoretic
content of the three problems that use `conwayKnot`.
-/

/-- A braid word for the Conway knot 11n34, on 4 strands, of length 11
and writhe `-1`. Each `±i` represents the braid generator `σ_i` (or its
inverse, for negative sign).

Source: KnotInfo's `11n_34` record, `braid_notation` field. The Knot Atlas
records a different but Markov-equivalent presentation for the same knot,
`[1, 1, 2, -3, 2, 1, -3, -2, -2, -3, -3]` (which it labels `K11n34`, the
mirror of the Conway knot); both representations agree on braid index 4,
braid length 11, and writhe `-1`. Sliceness is mirror-invariant, so either
braid word is a valid witness for `conway_knot_not_smoothly_slice`. -/
def conwayBraidWord : List ℤ := [-1, -1, 2, -1, 2, -1, 3, -2, -2, 3, 3]

/-- The Conway knot 11n34 as a piecewise-linear closed polyline in `ℝ³`,
realized as the braid closure of `conwayBraidWord` on 4 strands. -/
noncomputable def conwayKnot : PLKnot where
  vertices := braidClosure 4 conwayBraidWord
  three_le := by sorry
  isSimple := by sorry

end KnotTheory
end LeanEval
