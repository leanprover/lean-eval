import TauCeti.Geometry.Symplectic.Manifold.AlmostComplex.Topology
import TauCeti.Geometry.Symplectic.Manifold.AlmostComplex.Chart
import TauCeti.Geometry.Symplectic.Manifold.AlmostComplex.Pullback
import TauCeti.Geometry.Manifold.Complex.AlmostComplexStructure
import TauCeti.Geometry.Symplectic.JHolomorphic.Linearization
import TauCeti.Analysis.Complex.RiemannSurface.Degree
import TauCeti.Analysis.Complex.RiemannSurface.LocalMultiplicity
import TauCeti.AlgebraicTopology.Singular.SurfaceGenus
import TauCeti.Geometry.Manifold.ContMDiffMap.Chart.Topology
import EvalTools.Markers

/-!
# Main statements from "Transversality and super-rigidity for multiply covered holomorphic curves"

We formalise Theorems A, B and C of C. Wendl, *Transversality and super-rigidity for
multiply covered holomorphic curves*, Ann. of Math. 198 (1) (2023), no. 2,
https://doi.org/10.4007/annals.2023.198.1.2 (arXiv:1609.09867).

Let `(M, ω)` be a symplectic manifold of dimension `2n ≥ 4`, `J_fix` an `ω`-compatible almost
complex structure and `𝒰 ⊆ M` open with compact closure. `J(M, ω; 𝒰, J_fix)` is the space of
smooth `ω`-compatible almost complex structures agreeing with `J_fix` outside `𝒰`, with the
`C^∞` topology. Then for `J` in a comeagre subset:

* (Theorem A) if `dim M ≥ 6`, every simple `J`-holomorphic curve of index `0` meeting `𝒰` is
  super-rigid; the same holds for `dim M = 4` and curves of genus `0` or `1`;
* (Theorem B) every unbranched cover of a simple `J`-holomorphic curve meeting `𝒰` is Fredholm
  regular;
* (Theorem C) a branched cover `u ∘ φ` of a simple curve meeting `𝒰` with
  `ind(u) ≥ (n - 1) r`, where `r` is the number of critical values of `φ`, is a `C^∞` limit of
  Fredholm regular covers `u_ε ∘ φ_ε` (with the complex structures on both domains perturbed).

## Conventions and inline definitions

* A closed Riemann surface is a compact connected Hausdorff complex manifold `S` modelled on `ℂ`;
  its almost complex structure is `j = SmoothAlmostComplexStructure.ofComplexManifold ℂ S` on the
  underlying real surface, modelled on `𝓘(ℝ, ℂ)`. `M` is modelled on `𝓘(ℝ, E)`.
* A `J`-holomorphic curve is a smooth map `u : S → M` with `du ∘ j = J ∘ du`.
* The linearized operator `D_u` at a `J`-holomorphic curve is computed pointwise in the charts at
  `z₀` and `u z₀`, from Tau Ceti's local linearization `TauCeti.cauchyRiemannLinearization` of the
  defect `du ∘ j - J(u) ∘ du`. At a zero of the defect this is the vertical differential of the
  Cauchy–Riemann section, so it does not depend on the charts
  (`TauCeti.cauchyRiemannLinearization_comp_right` and the target covariance in
  `TauCeti.Geometry.Symplectic.JHolomorphic.Naturality`). In the charts at the base point the
  tangent identifications are the identity, so the value is a map `T_{z₀} S → T_{u z₀} M`. It is
  `-J` times Wendl's `D_u η = ∇η + J ∇η ∘ j + (∇_η J) du ∘ j`; kernels, ranges modulo `J`-invariant
  subspaces and cokernel dimensions are the same for both.
* The generalized normal bundle `N_u = u*TM / T_u` is not in Tau Ceti. Every statement below
  about `D_u^N = π_N ∘ D_u` is expressed through `D_u` and the generalized tangent bundle `T_u`:
  `D_u^N (π η) = π (D_u η)`, and every smooth section of `N_u`, or `N_u`-valued `(0,1)`-form,
  lifts to `u*TM`. At an immersed curve `T_u = im du` everywhere. At a general nonconstant curve
  `T_u = im du` at the regular points, which are dense, and a continuous section of `N_u` that
  vanishes there vanishes everywhere; so "valued in `T_u`" can be tested at regular points.
* Smooth sections are smooth maps into the total space (vector fields) or have smooth
  coordinate expressions in the standard trivializations (forms). Kernels and cokernels are
  taken on smooth sections; by elliptic regularity they are those of every `W^{k,p}`
  realization.
* `ind(u) = (n - 3) χ(S) + 2 c₁(u)` is written as `ind(D_u) - 3 χ(S)` (the virtual dimension of
  the moduli space of unparametrized curves), with `ind(D_u) = dim ker D_u - dim coker D_u`; by
  Riemann–Roch `ind(D_u) = n χ(S) + 2 c₁(u)`, so the two agree. Tau Ceti has no first Chern
  class of `(TM, J)`.
* Fredholm regularity is surjectivity of `D_u^N`, by Wendl's Proposition 2.2 (from
  *Automatic transversality and orbifolds of punctured holomorphic curves in dimension four*,
  Corollary 3.13).
-/

open Bundle Set Filter Topology Function
open scoped Manifold TauCeti.ComplexManifold

/- The scope `ContDiff` would provide `∞`, but also makes `ω` a token. -/
local notation "∞" => ((⊤ : ℕ∞) : WithTop ℕ∞)

noncomputable section

namespace SuperRigidity

open TauCeti

/-! ### The `C^∞` topology on smooth almost complex structures -/

section Topology

variable {E H : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [TopologicalSpace H]
  {I : ModelWithCorners ℝ E H} {M : Type} [TopologicalSpace M] [ChartedSpace H M]
  [IsManifold I ∞ M]

variable (I M) in
/-- The `C^∞` topology on smooth almost complex structures, in the standard trivializations of
`End(TM)` (`TauCeti.SmoothAlmostComplexStructure.frameTopology`; for a finite-dimensional model it
does not depend on the covering frames, `frameTopology_eq_of_covers`). -/
@[instance_reducible]
def cInftyTopology : TopologicalSpace (SmoothAlmostComplexStructure I M) :=
  SmoothAlmostComplexStructure.frameTopology (ι := M)
    (fun x ↦ trivializationAt (E →L[ℝ] E)
      (fun x : M ↦ TangentSpace I x →L[ℝ] TangentSpace I x) x)
    (fun x ↦ ⟨_, (trivializationAt (E →L[ℝ] E)
      (fun x : M ↦ TangentSpace I x →L[ℝ] TangentSpace I x) x).open_baseSet⟩)
    (fun _ ↦ subset_rfl)

end Topology

variable {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
  {M : Type} [TopologicalSpace M] [ChartedSpace E M] [IsManifold 𝓘(ℝ, E) ∞ M]

/-- The space `J(M, ω; 𝒰, J_fix)` of smooth `ω`-compatible almost complex structures on `M` that
agree with `J_fix` outside `𝒰`. -/
def CompatibleRel (ω : SmoothTwoForm 𝓘(ℝ, E) M) (Jfix : SmoothAlmostComplexStructure 𝓘(ℝ, E) M)
    (𝒰 : Set M) : Type :=
  {J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M //
    ω.Compatible J ∧ ∀ x ∉ 𝒰, J.toEndomorphism x = Jfix.toEndomorphism x}

/-- `J(M, ω; 𝒰, J_fix)` carries the subspace topology of the `C^∞` topology. -/
instance instTopologicalSpaceCompatibleRel (ω : SmoothTwoForm 𝓘(ℝ, E) M)
    (Jfix : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (𝒰 : Set M) :
    TopologicalSpace (CompatibleRel ω Jfix 𝒰) :=
  @instTopologicalSpaceSubtype _ _ (cInftyTopology 𝓘(ℝ, E) M)

/-! ### Curves, vector fields along curves and the linearized operator -/

section Curves

variable {S : Type} [TopologicalSpace S] [ChartedSpace ℂ S] [IsManifold 𝓘(ℂ) ∞ S]

variable (S) in
/-- The almost complex structure `j` of a Riemann surface. -/
abbrev jS : SmoothAlmostComplexStructure 𝓘(ℝ, ℂ) S :=
  SmoothAlmostComplexStructure.ofComplexManifold ℂ S

/-- A `J`-holomorphic curve: a smooth map `u : S → M` with `du ∘ j = J ∘ du`. -/
def IsJCurve (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) : Prop :=
  ContMDiff 𝓘(ℝ, ℂ) 𝓘(ℝ, E) ∞ u ∧ IsPseudoholomorphic (jS S) J u

/-- A curve is simple if it is nonconstant and is not of the form `v ∘ φ` for a `J`-holomorphic
curve `v` and a holomorphic map `φ` of degree at least two between closed Riemann surfaces. -/
def IsSimple (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) : Prop :=
  (∃ z z', u z ≠ u z') ∧
    ∀ (S' : Type) [TopologicalSpace S'] [ChartedSpace ℂ S'] [IsManifold 𝓘(ℂ) ∞ S']
      [CompactSpace S'] [ConnectedSpace S'] [T2Space S'] (v : S' → M) (φ : S → S'),
      IsJCurve J v → MDifferentiable 𝓘(ℂ) 𝓘(ℂ) φ → u = v ∘ φ → RiemannSurface.degree φ ≤ 1

/-- A vector field `η` along `u` (a section of `u*TM`) is smooth. -/
def IsSmoothAlong (u : S → M) (η : (z : S) → TangentSpace 𝓘(ℝ, E) (u z)) : Prop :=
  ContMDiff 𝓘(ℝ, ℂ) 𝓘(ℝ, E).tangent ∞ (fun z ↦ (⟨u z, η z⟩ : TangentBundle 𝓘(ℝ, E) M))

/-- A section `ζ` of `Hom(TS, u*TM)` is smooth: its coordinate expression in the standard
trivializations at each point is smooth there. -/
def IsSmoothFormAlong (u : S → M)
    (ζ : (z : S) → TangentSpace 𝓘(ℝ, ℂ) z →L[ℝ] TangentSpace 𝓘(ℝ, E) (u z)) : Prop :=
  ∀ z₀, ContMDiffAt 𝓘(ℝ, ℂ) 𝓘(ℝ, ℂ →L[ℝ] E) ∞
    (fun z ↦ ContinuousLinearMap.inCoordinates ℂ (TangentSpace 𝓘(ℝ, ℂ) : S → Type) E
      (TangentSpace 𝓘(ℝ, E) : M → Type) z₀ z (u z₀) (u z) (ζ z)) z₀

/-- A section `ζ` of `Hom(TS, u*TM)` is a `(0,1)`-form: `ζ ∘ j = -J ∘ ζ`. -/
def IsAntilinearAlong (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M)
    (ζ : (z : S) → TangentSpace 𝓘(ℝ, ℂ) z →L[ℝ] TangentSpace 𝓘(ℝ, E) (u z)) : Prop :=
  ∀ z v, ζ z (jS S z v) = -J (u z) (ζ z v)

/-- The linearized Cauchy–Riemann operator `D_u η` at `z₀`, computed in the charts at `z₀` and
`u z₀` as the linearization of the defect `du ∘ j - J(u) ∘ du` in the direction of `η`. In a
holomorphic chart `j` is multiplication by `i`. -/
def linearizedOperator (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M)
    (η : (z : S) → TangentSpace 𝓘(ℝ, E) (u z)) (z₀ : S) :
    TangentSpace 𝓘(ℝ, ℂ) z₀ →L[ℝ] TangentSpace 𝓘(ℝ, E) (u z₀) :=
  cauchyRiemannLinearization (ContinuousLinearMap.lsmul ℝ ℂ Complex.I) (J.inChart (u z₀))
    (writtenInExtChartAt 𝓘(ℝ, ℂ) 𝓘(ℝ, E) z₀ u)
    (fun w ↦ (trivializationAt E (TangentSpace 𝓘(ℝ, E)) (u z₀)
      ⟨u ((extChartAt 𝓘(ℝ, ℂ) z₀).symm w), η ((extChartAt 𝓘(ℝ, ℂ) z₀).symm w)⟩).2)
    (extChartAt 𝓘(ℝ, ℂ) z₀ z₀)

/-- The real dimension of the kernel of `D_u` on smooth vector fields along `u`. -/
def kernelDim (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) : ℕ :=
  Module.finrank ℝ (Submodule.span ℝ
    {η : (z : S) → TangentSpace 𝓘(ℝ, E) (u z) |
      IsSmoothAlong u η ∧ ∀ z, linearizedOperator J u η z = 0})

/-- The smooth `(0,1)`-forms along `u`, the target of `D_u`. -/
def formSpace (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) :
    Submodule ℝ ((z : S) → TangentSpace 𝓘(ℝ, ℂ) z →L[ℝ] TangentSpace 𝓘(ℝ, E) (u z)) :=
  Submodule.span ℝ {ζ | IsSmoothFormAlong u ζ ∧ IsAntilinearAlong J u ζ}

/-- The range of `D_u` on smooth vector fields along `u`. -/
def rangeSpace (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) :
    Submodule ℝ ((z : S) → TangentSpace 𝓘(ℝ, ℂ) z →L[ℝ] TangentSpace 𝓘(ℝ, E) (u z)) :=
  Submodule.span ℝ {ζ | ∃ η, IsSmoothAlong u η ∧ ζ = linearizedOperator J u η}

/-- The real dimension of the cokernel of `D_u`. -/
def cokernelDim (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) : ℕ :=
  Module.finrank ℝ (formSpace J u ⧸ (rangeSpace J u).comap (formSpace J u).subtype)

variable (S) in
/-- The Euler characteristic `χ(S) = 2 - 2g` of a closed Riemann surface. -/
def eulerChar : ℤ := 2 - 2 * (surfaceGenus S : ℤ)

/-- The index `ind(u) = (n - 3) χ(S) + 2 c₁(u)` of a closed `J`-holomorphic curve in a manifold
of dimension `2n`, written as `ind(D_u) - 3 χ(S)`, where `ind(D_u) = dim ker D_u - dim coker D_u`.

Wendl defines `ind(u)` through the first Chern number `c₁(u) = ⟨c₁(TM, J), u_*[S]⟩`, which is not
available here. By the Riemann–Roch theorem for real Cauchy–Riemann operators on the complex
vector bundle `u*TM` of rank `n` over the closed surface `S`,
`ind(D_u) = n χ(S) + 2 c₁(u)`, so `ind(D_u) - 3 χ(S) = (n - 3) χ(S) + 2 c₁(u)`. The definition used
here is the virtual dimension of the moduli space of unparametrized curves, `ind(D_u)` minus
`3 χ(S) = dim Aut(S) - dim T(S)` (automorphisms of `S` minus Teichmüller space); it agrees with the
paper's index by Riemann–Roch, which is a theorem rather than the paper's definition. -/
def index (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) : ℤ :=
  (kernelDim J u : ℤ) - cokernelDim J u - 3 * eulerChar S

/-- A closed, connected, simple `J`-holomorphic curve `u` is super-rigid (Wendl, Definition 2.3)
if `ind(u) = 0`, `u` is an immersion, and for every holomorphic map `φ : S' → S` of positive
degree from a closed connected Riemann surface, `D^N_{u ∘ φ}` is injective. Since `u` is
immersed, `T_{u ∘ φ} = φ*(im du)`, so a section `η` of `(u ∘ φ)*TM` with `D_{u ∘ φ} η` valued in
`T_{u ∘ φ}` must itself be valued in `T_{u ∘ φ}`. -/
structure IsSuperRigid (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (u : S → M) : Prop where
  index_eq_zero : index J u = 0
  injective_mfderiv : ∀ z, Injective (mfderiv 𝓘(ℝ, ℂ) 𝓘(ℝ, E) u z)
  normal_injective :
    ∀ (S' : Type) [TopologicalSpace S'] [ChartedSpace ℂ S'] [IsManifold 𝓘(ℂ) ∞ S']
      [CompactSpace S'] [ConnectedSpace S'] [T2Space S'] (φ : S' → S),
      MDifferentiable 𝓘(ℂ) 𝓘(ℂ) φ → 0 < RiemannSurface.degree φ →
      ∀ η : (z : S') → TangentSpace 𝓘(ℝ, E) (u (φ z)), IsSmoothAlong (u ∘ φ) η →
        (∀ z, LinearMap.range (linearizedOperator J (u ∘ φ) η z).toLinearMap ≤
          LinearMap.range (mfderiv 𝓘(ℝ, ℂ) 𝓘(ℝ, E) u (φ z)).toLinearMap) →
        ∀ z, η z ∈ LinearMap.range (mfderiv 𝓘(ℝ, ℂ) 𝓘(ℝ, E) u (φ z)).toLinearMap

/-- A closed `J`-holomorphic curve `w` is Fredholm regular, in the form of Wendl's
Proposition 2.2: `D^N_w` is surjective. Every smooth `(0,1)`-form `ζ` along `w` is `D_w η`
modulo `T_w`-valued forms, tested at the regular points of `w`. -/
def IsFredholmRegular (J : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (w : S → M) : Prop :=
  ∀ ζ : (z : S) → TangentSpace 𝓘(ℝ, ℂ) z →L[ℝ] TangentSpace 𝓘(ℝ, E) (w z),
    IsSmoothFormAlong w ζ → IsAntilinearAlong J w ζ →
    ∃ η, IsSmoothAlong w η ∧ ∀ z, Injective (mfderiv 𝓘(ℝ, ℂ) 𝓘(ℝ, E) w z) →
      LinearMap.range (linearizedOperator J w η z - ζ z).toLinearMap ≤
        LinearMap.range (mfderiv 𝓘(ℝ, ℂ) 𝓘(ℝ, E) w z).toLinearMap

end Curves

/-! ### The main theorems -/

variable [T2Space M] [SecondCountableTopology M]

/-- **Theorem A (super-rigidity), dimension at least six.** For generic
`J ∈ J(M, ω; 𝒰, J_fix)`, every simple `J`-holomorphic curve of index `0` that meets `𝒰` is
super-rigid. -/
@[eval_problem]
theorem super_rigidity (ω : SmoothTwoForm 𝓘(ℝ, E) M) (hω : ω.IsSymplectic)
    (Jfix : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (hJfix : ω.Compatible Jfix)
    (𝒰 : Set M) (h𝒰 : IsOpen 𝒰) (h𝒰c : IsCompact (closure 𝒰))
    (hdim : 6 ≤ Module.finrank ℝ E) :
    ∀ᶠ J in residual (CompatibleRel ω Jfix 𝒰),
      ∀ (S : Type) [TopologicalSpace S] [ChartedSpace ℂ S] [IsManifold 𝓘(ℂ) ∞ S]
        [CompactSpace S] [ConnectedSpace S] [T2Space S] (u : S → M),
        IsJCurve J.1 u → IsSimple J.1 u → index J.1 u = 0 → (∃ z, u z ∈ 𝒰) →
          IsSuperRigid J.1 u := by
  sorry

/-- **Theorem A (super-rigidity), dimension four.** For generic `J ∈ J(M, ω; 𝒰, J_fix)`,
every simple `J`-holomorphic curve of index `0` and genus `0` or `1` that meets `𝒰` is
super-rigid. -/
@[eval_problem]
theorem super_rigidity_four (ω : SmoothTwoForm 𝓘(ℝ, E) M) (hω : ω.IsSymplectic)
    (Jfix : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (hJfix : ω.Compatible Jfix)
    (𝒰 : Set M) (h𝒰 : IsOpen 𝒰) (h𝒰c : IsCompact (closure 𝒰))
    (hdim : Module.finrank ℝ E = 4) :
    ∀ᶠ J in residual (CompatibleRel ω Jfix 𝒰),
      ∀ (S : Type) [TopologicalSpace S] [ChartedSpace ℂ S] [IsManifold 𝓘(ℂ) ∞ S]
        [CompactSpace S] [ConnectedSpace S] [T2Space S] (u : S → M),
        surfaceGenus S ≤ 1 →
        IsJCurve J.1 u → IsSimple J.1 u → index J.1 u = 0 → (∃ z, u z ∈ 𝒰) →
          IsSuperRigid J.1 u := by
  sorry

/-- **Theorem B (transversality, unbranched).** For generic `J ∈ J(M, ω; 𝒰, J_fix)`, every
unbranched holomorphic cover `u ∘ φ` of a simple `J`-holomorphic curve `u` that meets `𝒰` is
Fredholm regular. An unbranched cover is a holomorphic map with local multiplicity one
everywhere. -/
@[eval_problem]
theorem transversality_unbranched (ω : SmoothTwoForm 𝓘(ℝ, E) M) (hω : ω.IsSymplectic)
    (Jfix : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (hJfix : ω.Compatible Jfix)
    (𝒰 : Set M) (h𝒰 : IsOpen 𝒰) (h𝒰c : IsCompact (closure 𝒰))
    (hdim : 4 ≤ Module.finrank ℝ E) :
    ∀ᶠ J in residual (CompatibleRel ω Jfix 𝒰),
      ∀ (S : Type) [TopologicalSpace S] [ChartedSpace ℂ S] [IsManifold 𝓘(ℂ) ∞ S]
        [CompactSpace S] [ConnectedSpace S] [T2Space S] (u : S → M),
        IsJCurve J.1 u → IsSimple J.1 u → (∃ z, u z ∈ 𝒰) →
        ∀ (S' : Type) [TopologicalSpace S'] [ChartedSpace ℂ S'] [IsManifold 𝓘(ℂ) ∞ S']
          [CompactSpace S'] [ConnectedSpace S'] [T2Space S'] (φ : S' → S),
          MDifferentiable 𝓘(ℂ) 𝓘(ℂ) φ → (∀ z, RiemannSurface.localMultiplicity φ z = 1) →
            IsFredholmRegular J.1 (u ∘ φ) := by
  sorry

/-- **Theorem C (transversality, branched).** For generic `J ∈ J(M, ω; 𝒰, J_fix)`: let `u` be a
simple `J`-holomorphic curve meeting `𝒰` with `ind(u) ≥ (n - 1) r` (here `2n = dim M`, and the
inequality is doubled), and `φ : S' → S` a holomorphic branched cover with `r` distinct critical
values. Then there are `J`-holomorphic `u_ε : (S, j_ε) → M` and holomorphic
`φ_ε : (S', j'_ε) → (S, j_ε)` with `j_ε, j'_ε, u_ε, φ_ε` arbitrarily `C^∞`-close to
`j, j', u, φ`, such that `u_ε ∘ φ_ε` is Fredholm regular.

A complex structure `j_ε` on the smooth surface underlying `S` is a Riemann surface `S_ε` with a
diffeomorphism `h : S ≃ S_ε`; then `j_ε = h^* j_{S_ε}`, and `u_ε`, `φ_ε` are read on `S` and `S'`
through `h` and `h'`. -/
@[eval_problem]
theorem transversality_branched (ω : SmoothTwoForm 𝓘(ℝ, E) M) (hω : ω.IsSymplectic)
    (Jfix : SmoothAlmostComplexStructure 𝓘(ℝ, E) M) (hJfix : ω.Compatible Jfix)
    (𝒰 : Set M) (h𝒰 : IsOpen 𝒰) (h𝒰c : IsCompact (closure 𝒰))
    (hdim : 4 ≤ Module.finrank ℝ E) :
    ∀ᶠ J in residual (CompatibleRel ω Jfix 𝒰),
      ∀ (S : Type) [TopologicalSpace S] [ChartedSpace ℂ S] [IsManifold 𝓘(ℂ) ∞ S]
        [CompactSpace S] [ConnectedSpace S] [T2Space S]
        (u : ContMDiffMap 𝓘(ℝ, ℂ) 𝓘(ℝ, E) S M ∞),
        IsJCurve J.1 u → IsSimple J.1 u → (∃ z, u z ∈ 𝒰) →
        ∀ r : ℕ, ((Module.finrank ℝ E : ℤ) - 2) * r ≤ 2 * index J.1 u →
        ∀ (S' : Type) [TopologicalSpace S'] [ChartedSpace ℂ S'] [IsManifold 𝓘(ℂ) ∞ S']
          [CompactSpace S'] [ConnectedSpace S'] [T2Space S']
          (φ : ContMDiffMap 𝓘(ℝ, ℂ) 𝓘(ℝ, ℂ) S' S ∞),
          MDifferentiable 𝓘(ℂ) 𝓘(ℂ) φ → (∃ z z', φ z ≠ φ z') →
          (φ '' {z | 2 ≤ RiemannSurface.localMultiplicity φ z}).ncard = r →
          ∀ Wj ∈ @nhds _ (cInftyTopology 𝓘(ℝ, ℂ) S) (jS S),
          ∀ Wj' ∈ @nhds _ (cInftyTopology 𝓘(ℝ, ℂ) S') (jS S'),
          ∀ Wu ∈ @nhds _ ContMDiffMap.manifoldWeakWhitneyTopology u,
          ∀ Wφ ∈ @nhds _ ContMDiffMap.manifoldWeakWhitneyTopology φ,
          ∃ (Sε : Type) (_ : TopologicalSpace Sε) (_ : ChartedSpace ℂ Sε)
            (_ : IsManifold 𝓘(ℂ) ∞ Sε)
            (S'ε : Type) (_ : TopologicalSpace S'ε) (_ : ChartedSpace ℂ S'ε)
            (_ : IsManifold 𝓘(ℂ) ∞ S'ε)
            (h : Diffeomorph 𝓘(ℝ, ℂ) 𝓘(ℝ, ℂ) S Sε ∞)
            (h' : Diffeomorph 𝓘(ℝ, ℂ) 𝓘(ℝ, ℂ) S' S'ε ∞)
            (uε : ContMDiffMap 𝓘(ℝ, ℂ) 𝓘(ℝ, E) Sε M ∞)
            (φε : ContMDiffMap 𝓘(ℝ, ℂ) 𝓘(ℝ, ℂ) S'ε Sε ∞),
            IsJCurve J.1 uε ∧ MDifferentiable 𝓘(ℂ) 𝓘(ℂ) φε ∧
            (jS Sε).pullback h ∈ Wj ∧ (jS S'ε).pullback h' ∈ Wj' ∧
            uε.comp h.toContMDiffMap ∈ Wu ∧
            (h.symm.toContMDiffMap.comp (φε.comp h'.toContMDiffMap)) ∈ Wφ ∧
            IsFredholmRegular J.1 (uε ∘ φε) := by
  sorry

end SuperRigidity
