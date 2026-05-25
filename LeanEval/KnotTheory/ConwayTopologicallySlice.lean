import LeanEval.KnotTheory.ConwayKnot
import EvalTools.Markers

namespace LeanEval
namespace KnotTheory

/-!
# The Conway knot is topologically slice

A direct application of Freedman's theorem: every knot in `S³` whose
Alexander polynomial is trivial bounds a locally flat topological 2-disk
in `B⁴`. The Conway knot 11n34 has `Δ_K(t) = 1`, so it is topologically
slice. The proof requires Freedman's full machinery (topological surgery
in dimension four); this is a hard problem.
-/

/-- **The Conway knot is topologically slice.**

Freedman (1982): every knot with trivial Alexander polynomial bounds a
locally flat topological disk in the 4-ball. The Conway knot has
`Δ_K(t) = 1`, so applying this theorem yields a locally flat topological
slice disk. -/
@[eval_problem]
theorem conway_knot_topologically_slice : conwayKnot.TopologicallySlice := by
  sorry

end KnotTheory
end LeanEval
