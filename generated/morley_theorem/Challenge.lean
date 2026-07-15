import ChallengeDeps

open LeanEval.Geometry.Morley
open scoped EuclideanGeometry

theorem morley_theorem (A B C P Q R : Plane)
    (h : IsMorleyConfiguration A B C P Q R) :
    IsEquilateralTriple P Q R := by
  sorry
