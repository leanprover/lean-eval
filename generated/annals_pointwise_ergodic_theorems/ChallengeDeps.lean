import Mathlib.Analysis.Normed.Lp.PiLp
import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statements from Pointwise ergodic theorems for non-conventional bilinear polynomial averages

We formalise the statements of the main results from B. Krause, M. Mirek, and T. Tao,
`Pointwise ergodic theorems for non-conventional bilinear polynomial averages`,
Annals of Math, 195 (3) 2022.
-/

set_option autoImplicit false

namespace PointwiseErgodicTheorems

open MeasureTheory Polynomial Finset Filter Topology

open scoped ENNReal NNReal PNat

/-- We say a sequence `a : ℕ → ℝ≥0` is `Λ-lacunary` if for each `n ∈ ℕ`, `a (n + 1) / a n > Λ`. -/
def Lacunary (Λ : ℝ≥0) (a : ℕ → ℝ≥0) : Prop := ∀ n, a (n + 1) / a n > Λ

/-- We define the `r`-variational norm of a sequence `a : ℕ → ℂ` by
`‖a‖_𝕍ʳ :=`
  `sup_{n ∈ ℕ} |a_n| + sup_{J ∈ ℕ} sup_{N_0 ≤ … ≤ N_J} (∑_j^{J-1} |a_{N_{j+1}} - a_{N_j}|^r)^{1/r}`.
-/
noncomputable def variationalNorm (r : ℝ≥0) (a : ℕ → ℂ) : ℝ≥0∞ :=
  (⨆ n, ‖a n‖ₑ) + ⨆ (J : ℕ) (N : ℕ → ℕ) (_ : Monotone N),
    ENNReal.ofReal ‖(WithLp.toLp r (fun (i : Fin J) ↦ a (N (i + 1)) - a (N i)))‖

/- We assume that `(X, μ, T)` is a Measure-preserving system. That is `(X, μ)` is a
`σ`-finite measure space, and `T : X → X` is an invertible bimeasurable map that is
measure preserving in the sense that `μ(T(E)) = μ(E)` for all measurable `E`.-/
variable {𝓧 : Type*} [σX : MeasurableSpace 𝓧] {μ : Measure 𝓧} [SigmaFinite μ]
  {T : 𝓧 ≃ᵐ 𝓧} (hT : MeasurePreserving T μ μ)

include hT

/-- Given a real number `N ≥ 0`, `P₁, P₂ ∈ ℤ[X]`, `f,g : X → ℂ`, we define the bilinear
averages by the formula
`A T N P₁ P₂ f g x := ⌊N⌋⁻¹ ∑_{n=1}^{⌊N⌋} f(T^{P₁(n)} x) g(T^{P₂(n)} x)`. -/
noncomputable def A (T : 𝓧 ≃ᵐ 𝓧) (N : ℝ≥0) (P₁ : ℤ[X]) (P₂ : ℤ[X]) (f g : 𝓧 → ℂ) (x : 𝓧) : ℂ :=
  (Nat.floor N : ℝ)⁻¹ * ∑ n ∈ Icc 1 (Nat.floor N),
    f ((T ^ (P₁.eval (n : ℤ)) : 𝓧 ≃ 𝓧) x) * g ((T ^ (P₂.eval (n : ℤ)) : 𝓧 ≃ 𝓧) x)

/- Let `P : ℤ[X]` be a polynomial with degree at least `2`. -/
variable {P : ℤ[X]} (hP : P.degree ≥ 2)

include hP

/- Let `p₁, p₂, p` be real numbers such that `1 < p₁, p₂ < ∞` and `p₁⁻¹ + p₂⁻¹ = p⁻¹ ≤ 1`. -/
variable {p₁ p₂ p : ℝ≥0∞} (h₁p₁ : 1 < p₁) (h₁p₂ : 1 < p₂) (h₂p₁ : p₁ < ∞) (h₂p₂ : p₂ < ∞)
  (hp₁p₂p : p₁⁻¹ + p₂⁻¹ = p⁻¹) (hp : p⁻¹ ≤ 1)

include h₁p₁ h₁p₂ h₂p₁ h₁p₂ h₂p₂ hp₁p₂p hp













end PointwiseErgodicTheorems
