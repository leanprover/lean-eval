import Mathlib

namespace LeanEval.Analysis.WienerLevy

/-!
# Wiener–Lévy theorem (analytic functional calculus)

§226 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. The
Wiener–Lévy theorem: if `φ` is complex-analytic on a neighbourhood of the
range of a Wiener-algebra function `f`, then the composition `φ ∘ f` is again
in the Wiener algebra.

mathlib has the additive circle, the Fourier characters `fourier`, Fourier
coefficients `fourierCoeff`, and `hasSum_fourier_series_of_summable`, but not
the Wiener algebra or its analytic functional calculus.
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



end

end LeanEval.Analysis.WienerLevy
