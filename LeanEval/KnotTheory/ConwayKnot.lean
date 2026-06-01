import LeanEval.KnotTheory.Slice
import LeanEval.KnotTheory.BraidClosure

namespace LeanEval
namespace KnotTheory

/-!
# The Conway knot 11n34 as a PL knot

The Conway knot has braid index 4 and a standard 4-braid representation in
KnotInfo. We package the resulting polyline as a `PLKnot`.

`conwayKnot` is now a trusted, `sorry`-free term: its only proof field,
`three_le`, is discharged by kernel computation of the (78-vertex) list
length. Simplicity of the polyline — an embedded simple closed curve —
is a `PLKnot.IsSimple` fact rather than a structure field, and is posed
as the separate benchmark hole `conwayKnot_isSimple` in `Piccirillo`
rather than carried here as an unchecked proof field. The topological
problem `conway_knot_topologically_slice` reuses this same trusted
`conwayKnot`; a solver there must likewise establish simplicity in order
to exhibit a smooth representative.
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

set_option maxRecDepth 10000 in
/-- The Conway knot 11n34 as a piecewise-linear closed polyline in `ℝ³`,
realized as the braid closure of `conwayBraidWord` on 4 strands. -/
noncomputable def conwayKnot : PLKnot where
  vertices := braidClosure 4 conwayBraidWord
  three_le := by
    have h : (braidClosure 4 conwayBraidWord).length = 78 := by rfl
    omega

end KnotTheory
end LeanEval
