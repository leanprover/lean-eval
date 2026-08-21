import ChallengeDeps
import Submission.Helpers

open ReverseMinkowski
open Module Real Matrix

variable {n : ℕ}
local notation "ℝⁿ" => EuclideanSpace ℝ (Fin n)

namespace Submission

theorem theorem_1_2 (ℒ : Submodule ℤ ℝⁿ) [DiscreteTopology ℒ] (hℒ : IsZLattice ℝ ℒ)
    (h : ∀ ℒ' (_hℒℒ' : ℒ' ≤ ℒ) [DiscreteTopology ℒ'], determinant ℒ' ≥ 1) :
    let t : ℝ := 10 * (log n + 2)
    ρ (1 / t) ℒ ≤ 3 / 2 := by
  sorry

end Submission
