import Mathlib

namespace LeanEval
namespace Analysis

/-!
# Euler–Lagrange equation

§44 of Oliver Knill's *Some Fundamental Theorems in Mathematics* (the additional
statement of the calculus-of-variations section). A sufficiently regular
stationary path `x` of the action `I(y) = ∫_a^b L(t, y(t), y'(t)) dt` satisfies
the Euler–Lagrange equation `∂L/∂x = (d/dt)(∂L/∂x')` pointwise on `(a, b)`.

mathlib has the fundamental lemma of the calculus of variations
(`IsOpen.ae_eq_zero_of_integral_contDiff_smul_eq_zero` and neighbours), but it
has no notion of a variational extremum of an action functional and no
Euler–Lagrange theorem (`grep -i 'euler.*lagrange'` in mathlib finds nothing in
the analytic sense). Here a path is a variational extremum when the first
variation of the action vanishes against every smooth compactly supported
perturbation, and the conclusion is the classical pointwise equation for `C²`
data.
-/

open MeasureTheory Set
open scoped ContDiff

/-- `∂L/∂x` along the path `x` at time `t`: the derivative of the partial map
`y ↦ L t y (x' t)` at `y = x t`. -/
noncomputable def lagrangianPartialX
    (L : ℝ → ℝ → ℝ → ℝ) (x : ℝ → ℝ) (t : ℝ) : ℝ :=
  deriv (fun y => L t y (deriv x t)) (x t)

/-- `∂L/∂x'` along the path `x` at time `t`: the derivative of the partial map
`z ↦ L t (x t) z` at `z = x' t`. -/
noncomputable def lagrangianPartialV
    (L : ℝ → ℝ → ℝ → ℝ) (x : ℝ → ℝ) (t : ℝ) : ℝ :=
  deriv (fun z => L t (x t) z) (deriv x t)

/-- A `C¹` path `x : ℝ → ℝ` is a **variational extremum** of the action
`I(y) := ∫_a^b L(t, y(t), y'(t)) dt` on `(a, b)` if for every smooth compactly
supported variation `h` with `tsupport h ⊆ (a, b)`, the first variation
`d/dε|_{ε=0} ∫_a^b L(t, x(t) + ε h(t), x'(t) + ε h'(t)) dt` vanishes. -/
def IsVariationalExtremum
    (a b : ℝ) (L : ℝ → ℝ → ℝ → ℝ) (x : ℝ → ℝ) : Prop :=
  ContDiff ℝ 1 x ∧
  ∀ h : ℝ → ℝ, ContDiff ℝ ∞ h → HasCompactSupport h →
    tsupport h ⊆ Set.Ioo a b →
    deriv (fun ε : ℝ => ∫ t in Set.Ioo a b,
        L t (x t + ε * h t) (deriv x t + ε * deriv h t)) 0 = 0



end Analysis
end LeanEval
