import ChallengeDeps
import Submission

open LeanEval.Dynamics
open scoped ENNReal
open MeasureTheory Filter Topology Real

theorem pesin_formula (T T_inv : EucPlane → EucPlane)
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
    (hμ_erg : Ergodic T μ)
    (hμ_dim : dimMeasure μ = 2)
    (hlam_sym : ∫ x, lyapunovUpperAt T x ∂μ
        = -∫ x, lyapunovLowerAt T x ∂μ) :
    kolmogorovSinaiEntropy μ T = ∫ x, lyapunovUpperAt T x ∂μ := by
  exact Submission.pesin_formula T T_inv hT_smooth hT_inv_smooth hT_left hT_right K hK_compact hK_inv μ hμ_supp hμ_pres hμ_erg hμ_dim hlam_sym
