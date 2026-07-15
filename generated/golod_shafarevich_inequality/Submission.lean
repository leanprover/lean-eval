import ChallengeDeps
import Submission.Helpers

open LeanEval.GroupTheory
open CategoryTheory

namespace Submission

theorem golod_shafarevich_inequality (p : ℕ) [Fact p.Prime] (Q : Type)
    [Group Q] [TopologicalSpace Q] [IsTopologicalGroup Q]
    [DiscreteTopology Q] [Finite Q] :
    IsPGroup p Q → Nontrivial Q →
      (generatorRank Q : ℝ) ^ 2 < 4 * (relationRank p Q : ℝ) := by
  sorry

end Submission
