import ChallengeDeps
import Submission

open LinearSubspaces
open ENNReal Real Module exteriorPower InnerProductGeometry
open scoped LinearAlgebra.Projectivization

variable {d : ℕ}
local notation "ℝᵈ" => EuclideanSpace ℝ (Fin d)
local notation "ℤᵈ" => intPoints

theorem theorem_1 (hd : 2 ≤ d) (l : ℕ) (hl0 : 0 < l) (hld : l < d) (k : ℕ) (hk1 : 1 ≤ k) (hkl : k ≤ l) :
    (∀ x : Submodule ℝ ℝᵈ, finrank ℝ x = l → diophantineExponent k x ≥ d / (k * (d - l))) ∧
    (∃ x : Submodule ℝ ℝᵈ, finrank ℝ x = l ∧ diophantineExponent k x = d / (k * (d - l))) := by
  exact Submission.theorem_1 hd l hl0 hld k hk1 hkl
