import ChallengeDeps
import Submission.Helpers

open LinearSubspaces
open ENNReal Real Module exteriorPower InnerProductGeometry
open scoped LinearAlgebra.Projectivization

variable {d : ℕ}
local notation "ℝᵈ" => EuclideanSpace ℝ (Fin d)
local notation "ℤᵈ" => intPoints

namespace Submission

theorem theorem_1 (hd : 2 ≤ d) (l : ℕ) (hl0 : 0 < l) (hld : l < d) (k : ℕ) (hk1 : 1 ≤ k) (hkl : k ≤ l) :
    (∀ x : Submodule ℝ ℝᵈ, finrank ℝ x = l → diophantineExponent k x ≥ d / (k * (d - l))) ∧
    (∃ x : Submodule ℝ ℝᵈ, finrank ℝ x = l ∧ diophantineExponent k x = d / (k * (d - l))) := by
  sorry

end Submission
