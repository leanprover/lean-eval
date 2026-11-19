import Mathlib

namespace LeanEval
namespace Combinatorics
namespace FraserKakeyaProblem

/-!
# Fraser: Fourier decay for finite-field Kakeya sets

For every dimension `d ≥ 2`, every finite-field Kakeya set
`K ⊆ F_q^d` supports a probability measure whose finite-field Fourier
transform is bounded by `q^{-1}` at every nonzero frequency, **and**
this exponent is sharp in every dimension (for sufficiently large
`q`). Jonathan M. Fraser, *Fourier analytic properties of Kakeya sets
in finite fields*, Bull. London Math. Soc. **58**(5) (2026); DOI
`10.1112/blms.70367`; arXiv:2505.09464.

A *finite-field Kakeya set* is a subset of `F_q^d` containing a line
in every direction. The theorem combines the upper Fourier-decay
bound with a matching sharpness construction valid in arbitrary
ambient dimension.
-/

open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- The ambient finite vector space `F_q^d`. -/
abbrev Space (F : Type*) (d : ℕ) := Fin d → F

/-- Standard dot product on `F_q^d`. -/
def dot {d : ℕ} (x y : Space F d) : F :=
  ∑ i, x i * y i

/-- The affine line with base point `y` and direction `x`. -/
def affineLine {d : ℕ} (y x : Space F d) : Set (Space F d) :=
  {z | ∃ a : F, z = y + a • x}

/-- A **Kakeya set**: it contains a line in every direction. -/
def IsKakeya {d : ℕ} (K : Set (Space F d)) : Prop :=
  ∀ x : Space F d, ∃ y : Space F d, affineLine y x ⊆ K

/-- A real-valued probability measure on the finite vector space
whose support is contained in `K`. -/
def IsProbabilityMeasureOn {d : ℕ} (K : Set (Space F d))
    (μ : Space F d → ℝ) : Prop :=
  (∀ x, 0 ≤ μ x) ∧ (∑ x, μ x = 1) ∧ ∀ x, μ x ≠ 0 → x ∈ K

/-- The finite-field Fourier transform with respect to a nontrivial
additive character. -/
noncomputable def fourier {d : ℕ} (χ : AddChar F ℂ) (μ : Space F d → ℝ)
    (ξ : Space F d) : ℂ :=
  ∑ x, χ (-(dot ξ x)) * (μ x : ℂ)



end FraserKakeyaProblem
end Combinatorics
end LeanEval
