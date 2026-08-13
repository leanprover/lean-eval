import ChallengeDeps

open LeanEval.NumberTheory.VinogradovMeanValue

theorem vinogradov_mean_value (s k : ℕ) (ε : ℝ) (hε : 0 < ε) :
    J s k =O[Filter.atTop]
      fun X ↦ (X ^ (s + ε) + X ^ ((2 * s : ℝ) - k * (k + 1) / 2 + ε) : ℝ) := by
  sorry
