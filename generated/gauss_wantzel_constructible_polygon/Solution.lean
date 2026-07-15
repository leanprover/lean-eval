import ChallengeDeps
import Submission

open LeanEval.NumberTheory.GaussWantzel

theorem gauss_wantzel_constructible_polygon (n : ℕ) (hn : 3 ≤ n) :
    IsConstructible (Real.cos (2 * Real.pi / n)) ↔ GaussWantzelNumber n := by
  exact Submission.gauss_wantzel_constructible_polygon n hn
