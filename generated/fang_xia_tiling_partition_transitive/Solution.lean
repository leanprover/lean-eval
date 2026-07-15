import ChallengeDeps
import Submission

open LeanEval.Combinatorics.FangXiaTilingProblem
open scoped BigOperators

theorem fang_xia_partition_transitive_of_tiling {n : ℕ} {Y : Set (Equiv.Perm (Fin n))}
    (_h : IsTiling (transpositionsWithOne n) Y) :
    ∀ lam : PartitionShape n, 0 ≤ lam.contentSum → IsPartitionTransitive Y lam := by
  exact Submission.fang_xia_partition_transitive_of_tiling _h
