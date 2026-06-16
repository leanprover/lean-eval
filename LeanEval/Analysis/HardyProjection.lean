import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.Topology.Algebra.Module.Complement
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Nonexistence of bounded projections from `L^1` onto `H^1`

Newman's theorem says that there is no bounded linear projection from `L^1` on
the circle onto the Hardy space `H^1`. We use the boundary model of the Hardy
space on the disk: `H^1` consists of those `L^1` functions on the unit circle
whose negative Fourier coefficients vanish.

The theorem below phrases the result as nonexistence of a topological
complement, using `Submodule.IsTopCompl`. Such a complement is exactly the data
of an algebraic complement together with continuity of the associated
projection.
-/

noncomputable section

open MeasureTheory

local instance : Fact (0 < (1 : ℝ)) := ⟨zero_lt_one⟩

/-- The unit circle as the additive circle `R/Z`, equipped below with normalized Haar measure. -/
abbrev HardyCircle : Type :=
  AddCircle (1 : ℝ)

/-- The ambient `L^1` space for boundary functions on the unit circle. -/
abbrev CircleL1 : Type :=
  Lp ℂ 1 (AddCircle.haarAddCircle : Measure HardyCircle)

/-- The boundary Hardy space `H^1`: those `L^1` functions whose negative Fourier
coefficients vanish. -/
def hardyH1 : Submodule ℂ CircleL1 where
  carrier := {f | ∀ n : ℤ, n < 0 → fourierCoeff (T := (1 : ℝ)) f n = 0}
  zero_mem' := by
    intro n _hn
    simp [fourierCoeff]
  add_mem' := by
    intro f g hf hg n hn
    have hf_int : Integrable (fun x : HardyCircle => f x) AddCircle.haarAddCircle :=
      memLp_one_iff_integrable.mp (Lp.memLp f)
    have hg_int : Integrable (fun x : HardyCircle => g x) AddCircle.haarAddCircle :=
      memLp_one_iff_integrable.mp (Lp.memLp g)
    calc
      fourierCoeff (T := (1 : ℝ)) (f + g) n =
          fourierCoeff (T := (1 : ℝ))
            (fun x : HardyCircle => f x + g x) n := by
        simpa only [Pi.add_apply] using
          congr_fun (fourierCoeff_congr_ae (T := (1 : ℝ)) (Lp.coeFn_add f g)) n
      _ = fourierCoeff (T := (1 : ℝ)) f n +
          fourierCoeff (T := (1 : ℝ)) g n := by
        exact congr_fun (fourierCoeff.add (T := (1 : ℝ)) hf_int hg_int) n
      _ = 0 := by
        simp [hf n hn, hg n hn]
  smul_mem' := by
    intro c f hf n hn
    calc
      fourierCoeff (T := (1 : ℝ)) (c • f) n =
          fourierCoeff (T := (1 : ℝ))
            (fun x : HardyCircle => c • f x) n := by
        simpa only [Pi.smul_apply] using
          congr_fun (fourierCoeff_congr_ae (T := (1 : ℝ)) (Lp.coeFn_smul c f)) n
      _ = c • fourierCoeff (T := (1 : ℝ)) f n := by
        exact fourierCoeff.const_smul (T := (1 : ℝ)) f c n
      _ = 0 := by
        simp [hf n hn]

/-- There is no bounded projection from `L^1` on the unit circle onto the Hardy
space `H^1` of functions with vanishing negative Fourier coefficients. In the
language of topological vector spaces, `H^1` has no topological complement in
`L^1`. -/
@[eval_problem]
theorem no_bounded_projection_L1_hardyH1 :
    ¬ ∃ K : Submodule ℂ CircleL1, Submodule.IsTopCompl hardyH1 K := by
  sorry

end

end Analysis
end LeanEval
