import ChallengeDeps
import Submission

open LeanEval.Geometry.Morley
open scoped EuclideanGeometry

theorem morley_theorem (A B C P Q R : Plane)
    (h : IsMorleyConfiguration A B C P Q R) :
    IsEquilateralTriple P Q R := by
  exact Submission.morley_theorem A B C P Q R h
