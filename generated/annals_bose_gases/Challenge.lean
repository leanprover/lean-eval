import ChallengeDeps

/-
Copyright (c) 2026 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.Analysis.Normed.Lp.MeasurableSpace
import Mathlib.MeasureTheory.Function.LocallyIntegrable
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Measure.Haar.OfBasis
/-!
# Main Statement from The energy of dilute Bose gases

We formalise the statement of the main result from S. Fournais and J. P. Solovej,
`The energy of dilute Bose gases`, Annals of Math, 192 (3) 2020.
-/

set_option autoImplicit false

namespace BoseGases

open Filter Metric MeasureTheory Laplacian

open scoped ContDiff Topology Real

local notation "ℝ³" => EuclideanSpace ℝ (Fin 3)



local notation "Δ[" i "]" => partialLaplacian i





local notation "⟪" f ", " g "⟫_["N "," L"]" => ∫ x in box N L, f x * g x

local notation "‖" f "‖_["N "," L"]" => √ ⟪f,f⟫_[N,L]

















/-- Constant `η` in Theorem 1.2. -/
noncomputable def η : ℝ := sorry

/-- Constant `𝓒` in Theorem 1.2. -/
noncomputable def 𝓒 (𝓡 : ℝ) (r : ℝ) : ℝ := sorry

/--
Statement of Theorem 1.2 (The Lee-Huang-Yang Formula):

For any non-zero, non-negative, radial potential `v ∈ L¹(ℝ³)` with compact support contained
in some ball `B(0,R)`, there exists `η > 0` and `𝓒` (depending only on `𝓡`and `R / a`) such that
as `ρ → 0⁺`,

`e ρ v ≥ 4πρ²a(1 + 128/(15√π)√(ρa³) - 𝓒(ρa³)^{1/2 + η})`.

Note: We (equivalently) take the limit as `ρ → 0⁺` rather than `ρa³ → 0⁺` as in the paper.

Note: While the wording of Theorem 1.2 in the paper suggests that `η` should also be allowed to
depend on `𝓡` and `R / a`, Theorem 6.8 makes it clear that `η` is in fact a universal constant.

Note: Since `v` is in `L¹(ℝ³)`, we interpret `v ≠ 0` to mean that `v` is not zero in `L¹(ℝ³)`.
-/
theorem theorem_1_2 (v : ℝ³ → ℝ) (hv_ne_zero : ¬ v =ᵐ[volume] 0) (hv_nonneg : 0 ≤ v)
    (hv_radial : IsRadial v) (hv_memL1 : MemLp v 1) {R : ℝ} (hR : 0 < R)
    (hv_supp : tsupport v ⊆ ball 0 R) : 0 < η ∧ ∀ᶠ ρ in 𝓝[>] 0,
      e ρ v ≥ 4 * π * ρ ^ 2 * a v * (1 + (128 / (15 * √ π)) * √ (ρ * a v ^ 3) -
        𝓒 (𝓡 v) (R / a v) * (ρ * a v ^ 3) ^ (1 / 2 + η)) := by
  sorry

end BoseGases
