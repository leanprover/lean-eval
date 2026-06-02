import ChallengeDeps
import Submission.Helpers

open LeanEval.Combinatorics.FangXiaTilingProblem
open scoped BigOperators

namespace Submission

theorem fang_xia_partition_transitive_of_tiling {n : ℕ} {Y : Set (Equiv.Perm (Fin n))}
    (_h : IsTiling (transpositionsWithOne n) Y) :
    ∀ lam : PartitionShape n, 0 ≤ lam.contentSum → IsPartitionTransitive Y lam := by
  sorry

end Submission
