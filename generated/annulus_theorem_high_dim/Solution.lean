import ChallengeDeps
import Submission

open LeanEval.Topology
open scoped unitInterval

theorem annulus_theorem_high_dim {n : ℕ} [NeZero n] (hn : 5 ≤ n)
    (f g : FlatSphere n)
    (hdisj : Disjoint (Set.range f.toFun) (Set.range g.toFun))
    (hnest : Set.range g.toFun ⊆ inside (Set.range f.toFun)) :
    Nonempty ((regionBetween f g) ≃ₜ (Sph n × I)) := by
  exact Submission.annulus_theorem_high_dim hn f g hdisj hnest
