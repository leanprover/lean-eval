import Mathlib.RingTheory.MvPolynomial.Symmetric.Defs
import TauCeti.Geometry.Manifold.Complex.AlmostComplexStructure
import TauCeti.Geometry.Manifold.Complex.LeviForm
import TauCeti.Geometry.Manifold.DifferentialForm.Closed
import TauCeti.Geometry.Symplectic.Manifold.LiouvilleMeasure
import EvalTools.Markers

/-!
# Main statements from "On `L^∞` estimates for complex Monge–Ampère equations"

We formalise Theorems 1, 2, 4, 5 and 6 of B. Guo, D. H. Phong and F. Tong, *On `L^∞` estimates
for complex Monge–Ampère equations*, Annals of Math. 198 (1) (2023), no. 4,
https://doi.org/10.4007/annals.2023.198.1.4 (arXiv:2106.02224). Theorem numbers are those of the
arXiv text.

Let `(X, ω_X)` be a compact connected Kähler manifold of complex dimension `n`, `V = ∫ ω_X^n`,
and `χ ≥ 0` a smooth closed real (1,1)-form. For `t ∈ (0, 1]` put `ω_t = χ + t ω_X`,
`V_t = ∫ ω_t^n`, and for a `C²` function `φ` let `λ[h_{t,φ}]` be the eigenvalues of
`ω_t + i ∂ ∂bar φ` relative to `ω_X`. Let `(f, Γ)` satisfy the paper's standing assumptions and
the structural condition `det (∂ f(λ[h]) / ∂ h_{ij}) ≥ γ`. The equations are
`f(λ[h_{t,φ}]) = c_t e^{F_t}`, `sup φ = 0`, `λ ∈ Γ`, with `F_t` normalised by
`∫ e^{n F_t} ω_X^n = V`. The paper bounds `sup |φ|` in terms of the entropy
`Ent_p(F) = V⁻¹ ∫ e^{nF} |F|^p ω_X^n` (`p > n`), the relative volume `c_t^n / V_t` and the energy
`E_t(φ) = V_t⁻¹ ∫ (-φ) f(λ[h_{t,φ}])^n ω_X^n`.

## Conventions

* `X` is a complex manifold modelled on `𝓘(ℂ, E)`; its underlying real manifold is modelled on
  `𝓘(ℝ, E)` (the scoped instance `TauCeti.ComplexManifold.isManifold_real`), and its complex
  structure is `J = TauCeti.SmoothAlmostComplexStructure.ofComplexManifold E X`, multiplication by
  `i` on each tangent space `E`.
* A Kähler form is a smooth real two-form `ω` with `ω.IsClosed` and `ω.Compatible J`:
  `J`-invariant and `ω(v, Jv) > 0` for `v ≠ 0` (equivalently `ω.IsKahler J`, by
  `TauCeti.SmoothTwoForm.isKahler_ofComplexManifold_iff`). In the paper's notation
  `ω = i g_{j kbar} dz^j ∧ dzbar^k`, and
  `g_{j kbar} v^j vbar^k = ω(v, Jv) / 2`.
* `i ∂ ∂bar φ` enters through its Hermitian form, the Levi form `TauCeti.manifoldLeviForm E φ x`,
  whose diagonal is `φ_{j kbar} v^j vbar^k` (so `(i ∂ ∂bar φ)(v, Jv) = 2 φ_{j kbar} v^j vbar^k`).
* The measure `α^n` of a semipositive two-form `α` is `n! • TauCeti.SmoothTwoForm.liouvilleMeasure
  α n`, since `liouvilleMeasure` is the measure of `|α^n / n!|`, and `α^n ≥ 0` for the complex
  orientation when `α` is semipositive.
-/

open MeasureTheory TauCeti TauCeti.SmoothAlmostComplexStructure
open scoped Manifold TauCeti.ComplexManifold

/- The scope `ContDiff` would provide `∞`, but also makes `ω` a token. -/
local notation "∞" => ((⊤ : ℕ∞) : WithTop ℕ∞)

noncomputable section

namespace MongeAmpereLInfinity

/-! ### Cones and admissible pairs `(f, Γ)` -/

/-- The cone `Γ_n = {λ : σ_1(λ) > 0, …, σ_n(λ) > 0}`, which is the positive orthant. -/
def gardingConeTop (n : ℕ) : Set (Fin n → ℝ) := {l | ∀ i, 0 < l i}

/-- The half-space `Γ_1 = {λ : λ_1 + ⋯ + λ_n > 0}`. -/
def gardingConeOne (n : ℕ) : Set (Fin n → ℝ) := {l | 0 < ∑ i, l i}

/-- The `k`-th elementary symmetric function `σ_k(λ)`. -/
def sigma {n : ℕ} (k : ℕ) (l : Fin n → ℝ) : ℝ :=
  MvPolynomial.eval l (MvPolynomial.esymm (Fin n) ℝ k)

/-- The Gårding cone `Γ_k = {λ : σ_1(λ) > 0, …, σ_k(λ) > 0}`. -/
def hessianCone (n k : ℕ) : Set (Fin n → ℝ) := {l | ∀ j ∈ Finset.Icc 1 k, 0 < sigma j l}

/-- The standing assumptions of Guo–Phong–Tong on `(f, Γ)` and the structural condition (1.4)
with constant `γ`:
1. `Γ` is an open symmetric cone with vertex at the origin and `Γ_n ⊆ Γ ⊆ Γ_1`;
2. `f` is symmetric and homogeneous of degree one on `Γ`;
3. `f` is elliptic: `∂f/∂λ_j > 0` on `Γ` for each `j`;
4. `det (∂ f(λ[h]) / ∂ h_{ij}) ≥ γ`, which for symmetric `f` is `∏_j ∂f/∂λ_j ≥ γ` on `Γ`.

The paper states no regularity of `f`; it is taken `C¹` on `Γ`, as in the ComplexHessianEquations
roadmap. This definition is the same as in `LeanEval.Geometry.FullyNonlinearLInfinity`. The values
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

/-! ### Forms, eigenvalues and measures -/

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℂ E] [FiniteDimensional ℂ E]
  {X : Type*} [TopologicalSpace X] [ChartedSpace E X] [IsManifold 𝓘(ℂ, E) ∞ X]

/-- The Hermitian quadratic form `v ↦ g_{j kbar} v^j vbar^k = α(v, Jv) / 2` of a real two-form
`α` on the tangent space `E` at `x`. -/
def hermitianQuadratic (α : SmoothTwoForm 𝓘(ℝ, E) X) (x : X) (v : E) : ℝ :=
  α.eval₂ x v (ofComplexManifold E X x v) / 2

/-- `χ` is a smooth closed real (1,1)-form with `χ ≥ 0`: closed, `J`-invariant, and
`χ(v, Jv) ≥ 0` for every tangent vector `v`. -/
def IsClosedSemipositive (χ : SmoothTwoForm 𝓘(ℝ, E) X) : Prop :=
  χ.IsClosed ∧ χ.Invariant (ofComplexManifold E X) ∧ ∀ x v, 0 ≤ hermitianQuadratic χ x v

/-- `l` is an eigenvalue vector at `x` of `α + i ∂ ∂bar φ` relative to `ω`: some complex basis
`(b_i)` of the tangent space `E` is unitary for `ω` and diagonalises `α + i ∂ ∂bar φ` with
diagonal entries `l`. For `α = ω_t` this is the paper's `λ[h_{t,φ}]`, the eigenvalues of the
endomorphism `(h_{t,φ})^j_k = g^{j mbar} (ω_t + i ∂ ∂bar φ)_{mbar k}`, in some order. Both forms
are Hermitian, so they are determined by their diagonals; the condition is stated on the
diagonals. -/
def IsEigenvalueVector {n : ℕ} (ω α : SmoothTwoForm 𝓘(ℝ, E) X) (φ : X → ℝ) (x : X)
    (l : Fin n → ℝ) : Prop :=
  ∃ b : Module.Basis (Fin n) ℂ E, ∀ c : Fin n → ℂ,
    hermitianQuadratic ω x (∑ i, c i • b i) = ∑ i, ‖c i‖ ^ 2 ∧
      hermitianQuadratic α x (∑ i, c i • b i) +
          (manifoldLeviForm E φ x (∑ i, c i • b i) (∑ i, c i • b i)).re =
        ∑ i, l i * ‖c i‖ ^ 2

/-- The measure `α^n` of a semipositive two-form on a manifold of real dimension `2n`. -/
def omegaPowMeasure [MeasurableSpace X] [BorelSpace X] [LindelofSpace X] (n : ℕ)
    [Fact (Module.finrank ℝ E = 2 * n)] (α : SmoothTwoForm 𝓘(ℝ, E) X) : Measure X :=
  (n.factorial : ENNReal) • α.liouvilleMeasure n

/-- The volume `∫_X α^n` of a semipositive two-form. -/
def formVolume [MeasurableSpace X] [BorelSpace X] [LindelofSpace X] (n : ℕ)
    [Fact (Module.finrank ℝ E = 2 * n)] (α : SmoothTwoForm 𝓘(ℝ, E) X) : ℝ :=
  (omegaPowMeasure n α).real Set.univ

/-! ### The statements -/

/-- **Guo–Phong–Tong, Theorem 1** (fixed background), as stated. Let `(X, ω_X)` be a compact
connected Kähler manifold of complex dimension `n`, `p > n`, `γ > 0` and `K`. There is `C` such
that for every `(f, Γ)` satisfying the structural condition with constant `γ`, every smooth `F`
normalised by `∫ e^{nF} ω_X^n = V` with `Ent_p(F) ≤ K`, and every `C²` solution `φ` of
`f(λ[h_φ]) = e^F`, `λ[h_φ] ∈ Γ`, `sup_X φ = 0`, we have `sup_X |φ| ≤ C`. -/
@[eval_problem]
theorem theorem_1 {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X] [CompactSpace X]
    [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hωc : ω.IsClosed)
    (hω : ω.Compatible (ofComplexManifold E X))
    (p : ℝ) (hp : (n : ℝ) < p) (γ : ℝ) (hγ : 0 < γ) (K : ℝ) :
    ∃ C : ℝ, ∀ (Γ : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ), IsAdmissiblePair Γ f γ →
      ∀ F : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) ∞ F →
      ∫ x, Real.exp (n * F x) ∂(omegaPowMeasure n ω) = formVolume n ω →
      (formVolume n ω)⁻¹ * ∫ x, Real.exp (n * F x) * |F x| ^ p ∂(omegaPowMeasure n ω) ≤ K →
      ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω ω φ x l ∧ l ∈ Γ ∧
          f l = Real.exp (F x)) →
        ⨆ x, φ x = 0 →
        ∀ x, |φ x| ≤ C := by
  sorry

/-- **Guo–Phong–Tong, Theorem 1** (fixed background), in the form its proof establishes: the
right-hand side is `c e^F` with `F` normalised and `c^n` bounded by `A`. With `c = 1` this is
`theorem_1`; unlike `theorem_1` it has instances for the Hessian pairs `(σ_k^{1/k}, Γ_k)`,
`k < n`, which admit no solution with `c = 1` and normalised `F`. -/
@[eval_problem]
theorem theorem_1_rescaled {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X]
    [CompactSpace X] [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hωc : ω.IsClosed)
    (hω : ω.Compatible (ofComplexManifold E X))
    (p : ℝ) (hp : (n : ℝ) < p) (γ : ℝ) (hγ : 0 < γ) (A K : ℝ) :
    ∃ C : ℝ, ∀ (Γ : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ), IsAdmissiblePair Γ f γ →
      ∀ F : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) ∞ F →
      ∫ x, Real.exp (n * F x) ∂(omegaPowMeasure n ω) = formVolume n ω →
      (formVolume n ω)⁻¹ * ∫ x, Real.exp (n * F x) * |F x| ^ p ∂(omegaPowMeasure n ω) ≤ K →
      ∀ c : ℝ, 0 < c → c ^ n ≤ A →
      ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω ω φ x l ∧ l ∈ Γ ∧
          f l = c * Real.exp (F x)) →
        ⨆ x, φ x = 0 →
        ∀ x, |φ x| ≤ C := by
  sorry

/-- **Guo–Phong–Tong, Theorem 2** (degenerating backgrounds). Let `(X, ω_X)` be a compact
connected Kähler manifold of complex dimension `n`, `χ ≥ 0` a smooth closed real (1,1)-form,
`p > n`, `γ > 0`, and `A`, `B`, `K` upper bounds. There is `C` such that for every `t ∈ (0, 1]`,
every `(f, Γ)` satisfying the structural condition with constant `γ`, every smooth `F` normalised
by `∫ e^{nF} ω_X^n = V`, every `c > 0` and every `C²` solution `φ` of
`f(λ[h_{t,φ}]) = c e^F`, `λ[h_{t,φ}] ∈ Γ`, `sup_X φ = 0`, with `c^n / V_t ≤ A`,
`E_t(φ) ≤ B` and `Ent_p(F) ≤ K`, we have `sup_X |φ| ≤ C`.

On a solution `f(λ[h_{t,φ}])^n = c^n e^{nF}`, so the energy is written with `c^n e^{nF}`. -/
@[eval_problem]
theorem theorem_2 {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X] [CompactSpace X]
    [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hωc : ω.IsClosed)
    (hω : ω.Compatible (ofComplexManifold E X))
    (χ : SmoothTwoForm 𝓘(ℝ, E) X) (hχ : IsClosedSemipositive χ)
    (p : ℝ) (hp : (n : ℝ) < p) (γ : ℝ) (hγ : 0 < γ) (A B K : ℝ) :
    ∃ C : ℝ, ∀ t ∈ Set.Ioc (0 : ℝ) 1,
      ∀ (Γ : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ), IsAdmissiblePair Γ f γ →
      ∀ F : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) ∞ F →
      ∫ x, Real.exp (n * F x) ∂(omegaPowMeasure n ω) = formVolume n ω →
      (formVolume n ω)⁻¹ * ∫ x, Real.exp (n * F x) * |F x| ^ p ∂(omegaPowMeasure n ω) ≤ K →
      ∀ c : ℝ, 0 < c → c ^ n / formVolume n (χ + t • ω) ≤ A →
      ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω (χ + t • ω) φ x l ∧ l ∈ Γ ∧
          f l = c * Real.exp (F x)) →
        ⨆ x, φ x = 0 →
        (formVolume n (χ + t • ω))⁻¹ *
            ∫ x, -φ x * (c * Real.exp (F x)) ^ n ∂(omegaPowMeasure n ω) ≤ B →
        ∀ x, |φ x| ≤ C := by
  sorry

/-- **Guo–Phong–Tong, Theorem 4** (Monge–Ampère on degenerating backgrounds; Kołodziej,
Eyssidieux–Guedj–Zeriahi, Demailly–Pali). Let `(X, ω_X)` be a compact connected Kähler manifold
of complex dimension `n`, `χ ≥ 0` a smooth closed real (1,1)-form, `q > n` and `K`. There is `C`
such that for every `t ∈ (0, 1]`, every smooth `F` normalised by `∫ e^{nF} ω_X^n = V` with
`V⁻¹ ∫ e^{nF} |F|^q ω_X^n ≤ K`, every `c > 0` and every `C²` solution `φ` of
`(ω_t + i ∂ ∂bar φ)^n = c^n e^{nF} ω_X^n`, `ω_t + i ∂ ∂bar φ > 0`, `sup_X φ = 0`, we have
`sup_X |φ| ≤ C`. The equation is written with `(ω_t + i ∂ ∂bar φ)^n / ω_X^n = ∏_j λ_j`. -/
@[eval_problem]
theorem theorem_4 {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X] [CompactSpace X]
    [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hωc : ω.IsClosed)
    (hω : ω.Compatible (ofComplexManifold E X))
    (χ : SmoothTwoForm 𝓘(ℝ, E) X) (hχ : IsClosedSemipositive χ)
    (q : ℝ) (hq : (n : ℝ) < q) (K : ℝ) :
    ∃ C : ℝ, ∀ t ∈ Set.Ioc (0 : ℝ) 1,
      ∀ F : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) ∞ F →
      ∫ x, Real.exp (n * F x) ∂(omegaPowMeasure n ω) = formVolume n ω →
      (formVolume n ω)⁻¹ * ∫ x, Real.exp (n * F x) * |F x| ^ q ∂(omegaPowMeasure n ω) ≤ K →
      ∀ c : ℝ, 0 < c →
      ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω (χ + t • ω) φ x l ∧
          l ∈ gardingConeTop n ∧ ∏ i, l i = (c * Real.exp (F x)) ^ n) →
        ⨆ x, φ x = 0 →
        ∀ x, |φ x| ≤ C := by
  sorry

/-- **Guo–Phong–Tong, Theorem 5** (fully non-linear equations in `Γ_k` on degenerating
backgrounds). In the setting of `theorem_2`, fix `1 ≤ k ≤ n`, `q > n / k` and upper bounds `A`,
`L`. There is `C` such that for every `t ∈ (0, 1]`, every `(f, Γ)` with structural constant `γ`,
every smooth normalised `F` with `∫ e^{nqF} ω_X^n ≤ L` (the `q`-th power of `‖e^{nF}‖_{L^q}`),
every `c > 0` with `c^n / V_t ≤ A` and every `C²` solution `φ` of `f(λ[h_{t,φ}]) = c e^F`,
`λ[h_{t,φ}] ∈ Γ ∩ Γ_k`, `sup_X φ = 0`, we have `sup_X |φ| ≤ C`. -/
@[eval_problem]
theorem theorem_5 {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X] [CompactSpace X]
    [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hωc : ω.IsClosed)
    (hω : ω.Compatible (ofComplexManifold E X))
    (χ : SmoothTwoForm 𝓘(ℝ, E) X) (hχ : IsClosedSemipositive χ)
    (γ : ℝ) (hγ : 0 < γ) (k : ℕ) (hk : 1 ≤ k) (hkn : k ≤ n) (q : ℝ) (hq : (n : ℝ) / k < q)
    (A L : ℝ) :
    ∃ C : ℝ, ∀ t ∈ Set.Ioc (0 : ℝ) 1,
      ∀ (Γ : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ), IsAdmissiblePair Γ f γ →
      ∀ F : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) ∞ F →
      ∫ x, Real.exp (n * F x) ∂(omegaPowMeasure n ω) = formVolume n ω →
      ∫ x, Real.exp (n * F x) ^ q ∂(omegaPowMeasure n ω) ≤ L →
      ∀ c : ℝ, 0 < c → c ^ n / formVolume n (χ + t • ω) ≤ A →
      ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω (χ + t • ω) φ x l ∧ l ∈ Γ ∧
          l ∈ hessianCone n k ∧ f l = c * Real.exp (F x)) →
        ⨆ x, φ x = 0 →
        ∀ x, |φ x| ≤ C := by
  sorry

/-- **Guo–Phong–Tong, Theorem 6** (Hessian equations with a big class). Let `(X, ω_X)` be a
compact connected Kähler manifold of complex dimension `n`, `χ ≥ 0` a smooth closed real
(1,1)-form with `∫ χ^n > 0`, `1 ≤ k < n`, `q > n / k` and `L`. There is `C` such that for every
`t ∈ (0, 1]`, every smooth `F` normalised by `∫ e^{nF} ω_X^n = V` with `∫ e^{nqF} ω_X^n ≤ L`,
every `c > 0` and every `C²` solution `φ` of
`(ω_t + i ∂ ∂bar φ)^k ∧ ω_X^{n-k} = c^k e^{kF} ω_X^n`, `λ[h_{t,φ}] ∈ Γ_k`, `sup_X φ = 0`, we have
`sup_X |φ| ≤ C`. The equation is written with
`(ω_t + i ∂ ∂bar φ)^k ∧ ω_X^{n-k} / ω_X^n = σ_k(λ) / binom(n, k)`. -/
@[eval_problem]
theorem theorem_6 {n : ℕ} [Fact (Module.finrank ℝ E = 2 * n)] [T2Space X] [CompactSpace X]
    [ConnectedSpace X] [MeasurableSpace X] [BorelSpace X]
    (ω : SmoothTwoForm 𝓘(ℝ, E) X) (hωc : ω.IsClosed)
    (hω : ω.Compatible (ofComplexManifold E X))
    (χ : SmoothTwoForm 𝓘(ℝ, E) X) (hχ : IsClosedSemipositive χ) (hbig : 0 < formVolume n χ)
    (k : ℕ) (hk : 1 ≤ k) (hkn : k < n) (q : ℝ) (hq : (n : ℝ) / k < q) (L : ℝ) :
    ∃ C : ℝ, ∀ t ∈ Set.Ioc (0 : ℝ) 1,
      ∀ F : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) ∞ F →
      ∫ x, Real.exp (n * F x) ∂(omegaPowMeasure n ω) = formVolume n ω →
      ∫ x, Real.exp (n * F x) ^ q ∂(omegaPowMeasure n ω) ≤ L →
      ∀ c : ℝ, 0 < c →
      ∀ φ : X → ℝ, ContMDiff 𝓘(ℝ, E) 𝓘(ℝ) 2 φ →
        (∀ x, ∃ l : Fin n → ℝ, IsEigenvalueVector ω (χ + t • ω) φ x l ∧
          l ∈ hessianCone n k ∧ sigma k l / n.choose k = (c * Real.exp (F x)) ^ k) →
        ⨆ x, φ x = 0 →
        ∀ x, |φ x| ≤ C := by
  sorry

end MongeAmpereLInfinity
