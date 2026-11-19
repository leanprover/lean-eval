import TauCeti.Geometry.Manifold.Complex.AlmostComplexStructure
import TauCeti.Geometry.Manifold.Complex.LeviForm
import TauCeti.Geometry.Symplectic.Manifold.LiouvilleMeasure
import EvalTools.Markers

/-!
# Main statements from "On `L^∞` estimates for fully non-linear partial differential equations"

We formalise Theorem 1 and Corollary 1 of B. Guo and D. H. Phong, *On `L^∞` estimates for fully
non-linear partial differential equations*, Annals of Math. 200 (1) (2024), no. 6,
https://doi.org/10.4007/annals.2024.200.1.6 (arXiv:2204.12549).

Let `(X, ω)` be a compact connected Hermitian manifold of complex dimension `n`. For a `C²`
function `φ`, let `λ[h_φ]` be the eigenvalues of `ω_φ = ω + i ∂ ∂bar φ` relative to `ω`. Let
`(f, Γ)` satisfy the structural conditions (1)–(4) of the paper, with constant `γ`. Theorem 1:
for every `p > n`, a `C²` solution of `f(λ[h_φ]) = e^F`, `λ[h_φ] ∈ Γ`, normalised by
`sup φ = 0`, satisfies `sup |φ| ≤ C`, where `C` depends only on `X, ω, n, p, γ` and the entropy
`∫_X (1 + |F|^p) e^{nF} ω^n`.

## Conventions

* `X` is a complex manifold modelled on `𝓘(ℂ, E)`; its underlying real manifold is modelled on
  `𝓘(ℝ, E)` (the scoped instance `TauCeti.ComplexManifold.isManifold_real`), and its complex
  structure is `J = TauCeti.SmoothAlmostComplexStructure.ofComplexManifold E X`, multiplication by
  `i` on each tangent space `E`.
* A Hermitian metric is a smooth real two-form `ω` with `ω.Compatible J`: it is `J`-invariant and
  `ω(v, Jv) > 0` for `v ≠ 0`. In the paper's notation `ω = i g_{j kbar} dz^j ∧ dzbar^k`, and
  `g_{j kbar} v^j vbar^k = ω(v, Jv) / 2`.
* `i ∂ ∂bar φ` enters through its Hermitian form, the Levi form `TauCeti.manifoldLeviForm E φ x`,
  whose diagonal is `φ_{j kbar} v^j vbar^k` (so `(i ∂ ∂bar φ)(v, Jv) = 2 φ_{j kbar} v^j vbar^k`).
* The measure `ω^n` is `n! • TauCeti.SmoothTwoForm.liouvilleMeasure ω n`, since `liouvilleMeasure`
  is the measure of `ω^n / n!`.
-/

open MeasureTheory TauCeti TauCeti.SmoothAlmostComplexStructure
open scoped Manifold TauCeti.ComplexManifold

/- The scope `ContDiff` would provide `∞`, but also makes `ω` a token. -/
local notation "∞" => ((⊤ : ℕ∞) : WithTop ℕ∞)

noncomputable section

namespace FullyNonlinearLInfinity

/-! ### Admissible pairs `(f, Γ)` -/

/-- The cone `Γ_n = {λ : σ_1(λ) > 0, …, σ_n(λ) > 0}`, which is the positive orthant. -/
def gardingConeTop (n : ℕ) : Set (Fin n → ℝ) := {l | ∀ i, 0 < l i}

/-- The half-space `Γ_1 = {λ : λ_1 + ⋯ + λ_n > 0}`. -/
def gardingConeOne (n : ℕ) : Set (Fin n → ℝ) := {l | 0 < ∑ i, l i}

/-- The structural conditions (1)–(4) of Guo–Phong on an operator `f` on `Γ`, with constant `γ`
in (4):
1. `Γ` is a symmetric open cone with `Γ_n ⊆ Γ ⊆ Γ_1`;
2. `f` is symmetric and homogeneous of degree one;
3. `∂f/∂λ_j > 0` on `Γ` for each `j`;
4. `∏_j ∂f/∂λ_j ≥ γ` on `Γ`.

The paper also takes `f` positive on `Γ`; that is a separate hypothesis of `theorem_1`, so that
this definition is the same as in `LeanEval.Geometry.MongeAmpereLInfinity`. The paper states no
regularity of `f`; it is taken `C¹` on `Γ`, as in the ComplexHessianEquations roadmap. The values
of `f` outside `Γ` are irrelevant. -/
structure IsAdmissiblePair {n : ℕ} (Γ : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ) (γ : ℝ) :
    Prop where
  isOpen : IsOpen Γ
  smul_mem : ∀ t : ℝ, 0 < t → ∀ l ∈ Γ, t • l ∈ Γ
  comp_perm_mem : ∀ σ : Equiv.Perm (Fin n), ∀ l ∈ Γ, l ∘ σ ∈ Γ
  gardingConeTop_subset : gardingConeTop n ⊆ Γ
  subset_gardingConeOne : Γ ⊆ gardingConeOne n
  comp_perm : ∀ σ : Equiv.Perm (Fin n), ∀ l ∈ Γ, f (l ∘ σ) = f l
  homogeneous : ∀ t : ℝ, 0 < t → ∀ l ∈ Γ, f (t • l) = t * f l
  contDiffOn : ContDiffOn ℝ 1 f Γ
  partial_pos : ∀ l ∈ Γ, ∀ j, 0 < fderiv ℝ f l (Pi.single j 1)
  le_prod_partial : ∀ l ∈ Γ, γ ≤ ∏ j, fderiv ℝ f l (Pi.single j 1)

/-! ### The eigenvalue vector `λ[h_φ]` -/

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℂ E] [FiniteDimensional ℂ E]
  {X : Type*} [TopologicalSpace X] [ChartedSpace E X] [IsManifold 𝓘(ℂ, E) ∞ X]

/-- The Hermitian quadratic form `v ↦ g_{j kbar} v^j vbar^k = ω(v, Jv) / 2` of a real two-form
`ω` on the tangent space `E` at `x`. -/
def hermitianQuadratic (ω : SmoothTwoForm 𝓘(ℝ, E) X) (x : X) (v : E) : ℝ :=
  ω.eval₂ x v (ofComplexManifold E X x v) / 2

/-- `l` is an eigenvalue vector `λ[h_φ]` at `x` of `ω_φ = ω + i ∂ ∂bar φ` relative to `ω`: some
complex basis `(b_i)` of the tangent space `E` is unitary for `ω` and diagonalises `ω_φ` with
diagonal entries `l`. Equivalently, `l` lists the eigenvalues of the endomorphism `h_φ` with
`(h_φ)^i_j = g^{i kbar} (g_φ)_{j kbar}` of `T^{1,0}_x X`, in some order. Both forms are
Hermitian, so they are determined by their diagonals; the condition is stated on the diagonals. -/
def IsEigenvalueVector {n : ℕ} (ω : SmoothTwoForm 𝓘(ℝ, E) X) (φ : X → ℝ) (x : X)
    (l : Fin n → ℝ) : Prop :=
  ∃ b : Module.Basis (Fin n) ℂ E, ∀ c : Fin n → ℂ,
    hermitianQuadratic ω x (∑ i, c i • b i) = ∑ i, ‖c i‖ ^ 2 ∧
      hermitianQuadratic ω x (∑ i, c i • b i) +
          (manifoldLeviForm E φ x (∑ i, c i • b i) (∑ i, c i • b i)).re =
        ∑ i, l i * ‖c i‖ ^ 2

/-- The measure `ω^n` of a two-form on a manifold of real dimension `2n`. -/
def omegaPowMeasure [MeasurableSpace X] [BorelSpace X] [LindelofSpace X] (n : ℕ)
    [Fact (Module.finrank ℝ E = 2 * n)] (ω : SmoothTwoForm 𝓘(ℝ, E) X) : Measure X :=
  (n.factorial : ENNReal) • ω.liouvilleMeasure n

/-! ### The statements -/

/-- **Guo–Phong, Theorem 1.** Let `(X, ω)` be a compact connected Hermitian manifold of complex
dimension `n`, `p > n`, `γ > 0` and `K`. There is `C` such that for every `(f, Γ)` satisfying the
structural conditions with constant `γ` and `f > 0` on `Γ`, every smooth `F` and every `C²`
solution `φ` of `f(λ[h_φ]) = e^F`, `λ[h_φ] ∈ Γ`, with `sup_X φ = 0` and
`∫_X (1 + |F|^p) e^{nF} ω^n ≤ K`, we have `sup_X |φ| ≤ C`. -/
@[eval_problem]
theorem theorem_1 {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X] [CompactSpace X]
    [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hω : ω.Compatible (ofComplexManifold E X))
    (p : ℝ) (hp : (n : ℝ) < p) (γ : ℝ) (hγ : 0 < γ) (K : ℝ) :
    ∃ C : ℝ, ∀ (Γ : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ), IsAdmissiblePair Γ f γ →
      (∀ l ∈ Γ, 0 < f l) →
      ∀ F : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) ∞ F →
      ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω φ x l ∧ l ∈ Γ ∧ f l = Real.exp (F x)) →
        ⨆ x, φ x = 0 →
        ∫ x, (1 + |F x| ^ p) * Real.exp (n * F x) ∂(omegaPowMeasure n ω) ≤ K →
        ∀ x, |φ x| ≤ C := by
  sorry

/-- **Guo–Phong, Corollary 1.** Let `(X, ω)` be a compact connected Hermitian manifold of
complex dimension `n`, `p > n` and `K > 0`. There is `c > 0` such that for every `C²` function `φ`
with `ω_φ = ω + i ∂ ∂bar φ > 0`, writing `e^{nF} = ω_φ^n / ω^n = det h_φ = ∏_j λ_j[h_φ]`: if
`∫_X e^{nF} |F|^p ω^n ≤ K` then `∫_X ω_φ^n = ∫_X e^{nF} ω^n ≥ c`.

The relative volume `e^{nF}` is the function `D` below. -/
@[eval_problem]
theorem corollary_1 {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X] [CompactSpace X]
    [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hω : ω.Compatible (ofComplexManifold E X))
    (p : ℝ) (hp : (n : ℝ) < p) (K : ℝ) (hK : 0 < K) :
    ∃ c : ℝ, 0 < c ∧ ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
      ∀ D : X → ℝ,
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω φ x l ∧ l ∈ gardingConeTop n ∧
          D x = ∏ i, l i) →
        ∫ x, D x * |Real.log (D x) / n| ^ p ∂(omegaPowMeasure n ω) ≤ K →
        c ≤ ∫ x, D x ∂(omegaPowMeasure n ω) := by
  sorry

end FullyNonlinearLInfinity
