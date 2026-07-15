import ChallengeDeps

open LeanEval.Geometry.LiouvilleArnold
open Set
open scoped ContDiff

theorem liouville_arnold {n : ℕ} (F : Fin n → E n → ℝ) (U : Set (E n)) (_hU : IsOpen U)
    (_hLI : IsLiouvilleIntegrable F U)
    (c : Fin n → ℝ)
    (_hMc_sub : levelSet F c ⊆ U)
    (_hMc_compact : IsCompact (levelSet F c))
    (_hMc_connected : IsConnected (levelSet F c)) :
    Nonempty ((levelSet F c) ≃ₜ (Fin n → AddCircle (1 : ℝ))) := by
  sorry
