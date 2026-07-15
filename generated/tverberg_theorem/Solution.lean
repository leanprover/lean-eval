import ChallengeDeps
import Submission

open LeanEval.Combinatorics.Tverberg
open scoped BigOperators

theorem tverberg_theorem (d r : ℕ) (hr : 1 ≤ r)
    (f : Fin ((r - 1) * (d + 1) + 1) → Space d) :
    HasTverbergPartition (r := r) f := by
  exact Submission.tverberg_theorem d r hr f
