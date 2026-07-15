import ChallengeDeps
import Submission.Helpers

open LeanEval.Topology
open scoped unitInterval

namespace Submission

theorem annulus_theorem_dim_four (f g : FlatSphere 4)
    (hdisj : Disjoint (Set.range f.toFun) (Set.range g.toFun))
    (hnest : Set.range g.toFun ⊆ inside (Set.range f.toFun)) :
    Nonempty ((regionBetween f g) ≃ₜ (Sph 4 × I)) := by
  sorry

end Submission
