import ChallengeDeps

open LeanEval.Combinatorics.UpperBoundSimplicialSpheresProblem
open BigOperators

theorem upper_bound_theorem_simplicial_spheres {d n k : ℕ} (X : FiniteSimplicialSphere d)
    (_hn : faceCount X 0 = n) (_hk : k < d) :
    faceCount X k ≤ cyclicPolytopeFaceCount n d k := by
  sorry
