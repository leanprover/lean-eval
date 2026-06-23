import Mathlib

namespace LeanEval
namespace Analysis

/-!
# Nonexistence of bounded projections from `L^1` onto `H^1`

The Hardy space `H^1` consists of those `L^1` functions on the unit circle whose
negative Fourier coefficients vanish. D. J. Newman showed that there is no bounded
linear projection from `L^1` onto `H^1`. The theorem below phrases the result
using `Submodule.ClosedComplemented`.
-/

open MeasureTheory Submodule

/-- The boundary Hardy space `H^1`: those `L^1` functions whose negative Fourier
coefficients vanish. -/
def H1 : Submodule ℂ (Lp ℂ 1 (AddCircle.haarAddCircle (T := 1))) where
  carrier := {f | ∀ n : ℤ, n < 0 → fourierCoeff f n = 0}
  zero_mem' := by simp [fourierCoeff]
  add_mem' := by
    intro f g hf hg n hn
    rw [fourierCoeff_congr_ae (Lp.coeFn_add f g),
      fourierCoeff.add (L1.integrable_coeFn f) (L1.integrable_coeFn g)]
    simp_all
  smul_mem' := by
    intro c f n hn
    rw [fourierCoeff_congr_ae (Lp.coeFn_smul c f), fourierCoeff.const_smul]
    simp_all



end Analysis
end LeanEval
