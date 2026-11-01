import Mathlib

namespace LeanEval.Analysis.NyquistShannon

/-!
# Nyquist–Shannon sampling theorem

`nyquist_shannon_sampling`: a Schwartz function whose Fourier transform is
supported in the Nyquist band `[-1/2, 1/2]` (mathlib's `e^{-2π i x ξ}`
convention) is reconstructed from its integer samples by the Whittaker–Shannon
cardinal series `f(t) = ∑_{n : ℤ} f(n) * sinc(π(n - t))`. Trusted helpers
(`sinc`, `FourierSupportedInNyquist`) are non-holes. Mathlib has Schwartz space,
the Fourier transform, inversion, Plancherel and Poisson summation, but not the
sampling theorem. Category-(b) candidate from §179 of the Knill survey.
-/

open scoped FourierTransform SchwartzMap
open Set

/-- The unnormalised cardinal sine, with the removable singularity filled by
the standard value `1`.  Knill writes `sinc x = sin x / x`; the reconstruction
formula evaluates this at `0` when `t` is an integer, so the total version is
the faithful formal spelling. -/
noncomputable def sinc (x : ℝ) : ℂ :=
  if x = 0 then 1 else ((Real.sin x / x : ℝ) : ℂ)

/-- The Fourier transform of `f` is supported in the Nyquist band for
mathlib's `e^{-2π i x ξ}` Fourier convention, namely `[-1/2, 1/2]`. -/
def FourierSupportedInNyquist (f : 𝓢(ℝ, ℂ)) : Prop :=
  ∀ ξ : ℝ, ξ ∉ Icc (-(1 / 2 : ℝ)) (1 / 2 : ℝ) → 𝓕 f ξ = 0



end LeanEval.Analysis.NyquistShannon
