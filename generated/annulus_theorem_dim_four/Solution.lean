import ChallengeDeps
import Submission

open LeanEval.Topology
open scoped unitInterval

theorem annulus_theorem_dim_four (f g : FlatSphere 4)
    (hdisj : Disjoint (Set.range f.toFun) (Set.range g.toFun))
    (hnest : Set.range g.toFun ⊆ inside (Set.range f.toFun)) :
    Nonempty ((regionBetween f g) ≃ₜ (Sph 4 × I)) := by
  exact Submission.annulus_theorem_dim_four f g hdisj hnest
