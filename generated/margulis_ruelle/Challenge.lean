import ChallengeDeps

open LeanEval.Dynamics
open scoped ENNReal
open MeasureTheory Filter Topology Real

theorem margulis_ruelle (T T_inv : EucPlane → EucPlane)
    (hT_smooth : ContDiff ℝ 2 T)
    (hT_inv_smooth : ContDiff ℝ 2 T_inv)
    (hT_left : Function.LeftInverse T_inv T)
    (hT_right : Function.RightInverse T_inv T)
    (K : Set EucPlane)
    (hK_compact : IsCompact K)
    (hK_inv : T '' K = K)
    (μ : Measure EucPlane) [IsProbabilityMeasure μ]
    (hμ_supp : μ Kᶜ = 0)
    (hμ_pres : MeasurePreserving T μ μ)
    (hμ_erg : Ergodic T μ) :
    kolmogorovSinaiEntropy μ T
      ≤ max 0 (∫ x, lyapunovUpperAt T x ∂μ)
          + max 0 (∫ x, lyapunovLowerAt T x ∂μ) := by
  sorry
