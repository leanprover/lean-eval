import LeanEval.Topology.AnnulusBase
import EvalTools.Markers

namespace LeanEval
namespace Topology

open scoped unitInterval

/-!
# The Annulus Theorem in dimension ≥ 5 (Kirby, 1969)

The closed region between two disjoint, nested, locally flat embedded
`(n-1)`-spheres in `ℝⁿ`, for ambient dimension `n ≥ 5`, is homeomorphic to
`Sⁿ⁻¹ × [0,1]`. This was the hard core of Kirby's proof of the stable
homeomorphism conjecture, via the torus trick.

See `AnnulusBase` for the shared definitions (`FlatSphere`, `inside`,
`regionBetween`, local flatness). The `n = 4` case (Quinn) is a separate eval
problem, `annulus_theorem_dim_four`, of a quite different difficulty.
-/

/-- **The Annulus Theorem in dimension `≥ 5`** (Kirby, 1969). Let `f` be a
locally flat embedded `(n-1)`-sphere in `ℝⁿ` (`n ≥ 5`) and `g` a second one
nested strictly inside `f`: the two images are disjoint and `g`'s image lies in
the inside of `f`. Then the closed region between them is homeomorphic to the
product `Sⁿ⁻¹ × [0,1]`. -/
@[eval_problem]
theorem annulus_theorem_high_dim {n : ℕ} [NeZero n] (hn : 5 ≤ n)
    (f g : FlatSphere n)
    (hdisj : Disjoint (Set.range f.toFun) (Set.range g.toFun))
    (hnest : Set.range g.toFun ⊆ inside (Set.range f.toFun)) :
    Nonempty ((regionBetween f g) ≃ₜ (Sph n × I)) := by
  sorry

end Topology
end LeanEval
