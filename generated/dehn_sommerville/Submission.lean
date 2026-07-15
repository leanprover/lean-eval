import ChallengeDeps
import Submission.Helpers

open LeanEval.Combinatorics.DehnSommerville

namespace Submission

theorem dehn_sommerville {d j : ℕ} (X : FiniteSimplicialSphere d) (hj : j ≤ d) :
    hVector X j = hVector X (d - j) := by
  sorry

end Submission
