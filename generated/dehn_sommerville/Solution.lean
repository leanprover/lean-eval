import ChallengeDeps
import Submission

open LeanEval.Combinatorics.DehnSommerville

theorem dehn_sommerville {d j : ℕ} (X : FiniteSimplicialSphere d) (hj : j ≤ d) :
    hVector X j = hVector X (d - j) := by
  exact Submission.dehn_sommerville X hj
