import LeanEval.Topology.AnnulusBase
import EvalTools.Markers

namespace LeanEval
namespace Topology

open scoped unitInterval

/-!
# The Annulus Theorem in dimension 4 (Quinn, 1982)

The closed region between two disjoint, nested, locally flat embedded `3`-spheres
in `ℝ⁴` is homeomorphic to `S³ × [0,1]`. This four-dimensional case of the
annulus theorem is of an entirely different difficulty from the `n ≥ 5` case: it
was settled by Quinn (1982), building on Freedman's topology of 4-manifolds.

See `AnnulusBase` for the shared definitions (`FlatSphere`, `inside`,
`regionBetween`, local flatness). The `n ≥ 5` case (Kirby) is a separate eval
problem, `annulus_theorem_high_dim`.
-/

/-- **The Annulus Theorem in dimension `4`** (Quinn, 1982, building on Freedman).
Let `f` be a locally flat embedded `3`-sphere in `ℝ⁴` and `g` a second one nested
strictly inside `f`: the two images are disjoint and `g`'s image lies in the
inside of `f`. Then the closed region between them is homeomorphic to the product
`S³ × [0,1]`. -/
@[eval_problem]
theorem annulus_theorem_dim_four
    (f g : FlatSphere 4)
    (hdisj : Disjoint (Set.range f.toFun) (Set.range g.toFun))
    (hnest : Set.range g.toFun ⊆ inside (Set.range f.toFun)) :
    Nonempty ((regionBetween f g) ≃ₜ (Sph 4 × I)) := by
  sorry

end Topology
end LeanEval
