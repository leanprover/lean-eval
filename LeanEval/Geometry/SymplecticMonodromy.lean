/-
Copyright (c) 2026 Justus Springer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Justus Springer
-/

import Mathlib.Analysis.CStarAlgebra.Classes
import Mathlib.LinearAlgebra.Dimension.Basic
import Mathlib.RingTheory.Ideal.Quotient.Defs
import Mathlib.RingTheory.MvPowerSeries.Derivative
import Mathlib.Topology.UnitInterval
import EvalTools.Markers

/-!
# Main Statement from Symplectic monodromy at radius zero and equimultiplicity of
# μ-constant families

We formalise the statement of the main result from J. Fernández de Bobadilla and T. Pełka,
`Symplectic monodromy at radius zero and equimultiplicity of μ-constant families`,
Annals of Math, 200 (1) 2024.
-/

set_option autoImplicit false

namespace SymplecticMonodromy

open MvPowerSeries

/-- The Milnor number of `f` is `dim_ℂ ℂ⟦z₁, ⋯, zₙ⟧ / ⟨∂f/∂z₁, ⋯, ∂f/∂zₙ⟩`. -/
noncomputable def milnorNumber {σ R : Type*} [CommRing R] (f : MvPowerSeries σ R) : ℕ∞ :=
  (Module.rank R (MvPowerSeries σ R ⧸ Ideal.span (Set.range (pderiv R · f)))).toENat

/--
Statement of Theorem 1.1:

Let `(fₜ)` be a continuous family of power series. If the Milnor number `μ(fₜ)` is independent
of `t` and finite, then the multiplicity `ν(fₜ)` is also independent of `t`.

Note that what the paper calls "multiplicity" is exactly `MvPowerSeries.order`; see
for instance `MvPowerSeries.order_eq_nat`.

Even though not explicitly mentioned by the paper, we need to require the constant coefficients
to vanish. This is equivalent to saying that `fₜ` is a germ `(ℂⁿ, 0) → (ℂ, 0)`, i.e. that it's
a family of isolated hypersurface singularities through the origin, which is mentioned both in the
abstract and in Corollary 1.3, but not explicitly in Theorem 1.1. For an example showing that we
need this assumption, consider `fₜ = z + t`: The Milnor number is `1` for all `t`, but
`order(f₀) = 1` while `order(f₁) = 0`.
-/
@[eval_problem]
theorem theorem_1_1 (n : ℕ) (f : unitInterval → MvPowerSeries (Fin n) ℂ)
    (cont : ∀ d, Continuous fun t ↦ coeff d (f t)) (h_const : ∀ t, constantCoeff (f t) = 0)
    (h : ∃ μ : ℕ, ∀ t, milnorNumber (f t) = μ) : ∀ t₁ t₂, (f t₁).order = (f t₂).order := by
  sorry

end SymplecticMonodromy
