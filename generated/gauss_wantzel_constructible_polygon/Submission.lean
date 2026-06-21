import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.GaussWantzel

namespace Submission

theorem gauss_wantzel_constructible_polygon (n : ℕ) (hn : 3 ≤ n) :
    IsConstructible (Real.cos (2 * Real.pi / n)) ↔ GaussWantzelNumber n := by
  sorry

end Submission
