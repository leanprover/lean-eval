import ChallengeDeps
import Submission

open LeanEval.Combinatorics
open scoped BigOperators

theorem szemeredi (A : Set ℕ) (h : 0 < upperDensity A) :
    ContainsArbitraryAPs A := by
  exact Submission.szemeredi A h
