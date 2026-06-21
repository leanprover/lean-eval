import Mathlib
import EvalTools.Markers

namespace LeanEval.Analysis.WienerOneOverF

/-!
# Wiener's `1/f` theorem

§226 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. Wiener's
lemma for the circle algebra: if a continuous function on the circle has
absolutely summable Fourier coefficients and is nowhere zero, then its
pointwise inverse again has absolutely summable Fourier coefficients.

mathlib has the additive circle, the Fourier characters `fourier`, Fourier
coefficients `fourierCoeff`, and `hasSum_fourier_series_of_summable`, but not
the Wiener algebra or the spectral-invariance theorem.
-/

open Set
open scoped ComplexConjugate Real

noncomputable section

variable {T : ℝ} [Fact (0 < T)]

/-- The Wiener-algebra predicate on the additive circle: a continuous
complex-valued function whose Fourier coefficients are absolutely summable.
For complex series, `Summable` is equivalent to absolute summability of the
norms. -/
def InWienerAlgebra (f : C(AddCircle T, ℂ)) : Prop :=
  Summable (fourierCoeff f)

/-- **Wiener's `1/f` theorem.** If a function on the circle belongs to the
Wiener algebra and has no zero on the circle, then its pointwise reciprocal
again belongs to the Wiener algebra. -/
@[eval_problem]
theorem wiener_inverse_closed (f : C(AddCircle T, ℂ))
    (hf : InWienerAlgebra f) (hzero : ∀ x, f x ≠ 0) :
    ∃ g : C(AddCircle T, ℂ),
      (∀ x, g x = (f x)⁻¹) ∧ InWienerAlgebra g := by
  sorry

end

end LeanEval.Analysis.WienerOneOverF
