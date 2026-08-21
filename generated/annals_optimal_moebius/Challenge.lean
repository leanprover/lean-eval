import ChallengeDeps

open OptimalMoebius
open Topology ContDiff

local notation "ℝ²" => EuclideanSpace ℝ (Fin 2)
local notation "ℝ³" => EuclideanSpace ℝ (Fin 3)

theorem theorem_1_1 (a : ℝ) (ha : a > 0) (f : ℝ² → ℝ³) (hf : IsMoebiusEmbedding a f) :
    a > √3 := by
  sorry
