import Mathlib.MeasureTheory.Integral.Bochner.Basic
import TauCeti.Geometry.Manifold.Riemannian.Distance
import TauCeti.Geometry.Manifold.Riemannian.Isometry.Basic
import TauCeti.Geometry.Manifold.Riemannian.Sphere.Radius
import TauCeti.Geometry.Manifold.Riemannian.VolumeDensity.Total
import TauCeti.Geometry.Manifold.VectorBundle.CovariantDerivative.Curvature.Scalar
import EvalTools.Markers

open Bundle CovariantDerivative Filter MeasureTheory Metric Set Topology
open scoped ContDiff Manifold RealInnerProductSpace

namespace LeanEval
namespace Geometry

/-!
# The Schoen–Yau Positive Mass Theorem

Richard Schoen and Shing-Tung Yau (1979, *On the proof of the positive mass
conjecture in general relativity*, *Comm. Math. Phys.* 65, 45–76; 1981, *Proof
of the positive mass theorem. II*, *Comm. Math. Phys.* 79, 231–260; extended up
to dimension $7$ via area-minimizing hypersurface regularity, see Eichmair–Huang–Lee–Schoen
2016 and Lee, *Geometric Relativity*, AMS GSM 201, 2019, Theorem 3.18; see also
Edward Witten 1981, *Comm. Math. Phys.* 80, 381–402 for spin manifolds) proved
that every complete connected smooth Riemannian manifold $(M^{n+1}, g)$ of
dimension $3 \le n + 1 \le 7$ with nonnegative scalar curvature $R_g \ge 0$ and
an asymptotically flat end of decay order $\tau > (n - 1) / 2$ (Bartnik 1986,
*Comm. Pure Appl. Math.* 39, 661–693) has nonnegative Arnowitt–Deser–Misner
(ADM) mass $m \ge 0$, and for a single-end manifold $m = 0$ if and only if
$(M, g)$ is globally isometric to Euclidean space $\mathbb{R}^{n+1}$.
-/

namespace SchoenYauPositiveMass

/-- Coordinate component $g_{ij}(x) = \langle d\Psi_x e_i, d\Psi_x e_j \rangle_g$
of the Riemannian metric pulled back along a chart at infinity
$\Psi : \mathbb{R}^{n+1} \to M$. -/
noncomputable def pulledBackMetricCoeff
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    {n : ℕ} (Ψ : EuclideanSpace ℝ (Fin (n + 1)) → M)
    (x : EuclideanSpace ℝ (Fin (n + 1))) (i j : Fin (n + 1)) : ℝ :=
  ⟪mfderiv 𝓘(ℝ, EuclideanSpace ℝ (Fin (n + 1))) I Ψ x (EuclideanSpace.single i 1),
    mfderiv 𝓘(ℝ, EuclideanSpace ℝ (Fin (n + 1))) I Ψ x (EuclideanSpace.single j 1)⟫

/-- Pointwise ADM flux integrand
$\sum_{i,j} (\partial_j g_{ij} - \partial_i g_{jj}) \frac{x_i}{\|x\|}$. -/
noncomputable def admFluxIntegrand
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    {n : ℕ} (Ψ : EuclideanSpace ℝ (Fin (n + 1)) → M)
    (x : EuclideanSpace ℝ (Fin (n + 1))) : ℝ :=
  ∑ i : Fin (n + 1), ∑ j : Fin (n + 1),
    (fderiv ℝ (fun y ↦ pulledBackMetricCoeff I Ψ y i j) x (EuclideanSpace.single j 1) -
      fderiv ℝ (fun y ↦ pulledBackMetricCoeff I Ψ y j j) x (EuclideanSpace.single i 1)) *
      (x i / ‖x‖)

/-- Coordinate-sphere ADM mass flux at radius $r$:
$\frac{1}{2 n \,\mathrm{Vol}(S^n)} \int_{S^n} r^n \mathcal{F}_\Psi(r u)\,dV_{S^n}(u)$
(with normalizing factor $\frac{1}{16\pi}$ in dimension $n + 1 = 3$). -/
noncomputable def admSphereFlux
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    {n : ℕ} (Ψ : EuclideanSpace ℝ (Fin (n + 1)) → M) (r : ℝ) : ℝ :=
  letI : Fact (Module.finrank ℝ (EuclideanSpace ℝ (Fin (n + 1))) = n + 1) :=
    ⟨finrank_euclideanSpace_fin⟩
  (1 / (2 * (n : ℝ) *
    TauCeti.riemannianTotalVolume (𝓡 n)
      (sphere (0 : EuclideanSpace ℝ (Fin (n + 1))) 1))) *
    ∫ u : sphere (0 : EuclideanSpace ℝ (Fin (n + 1))) 1,
      r ^ n * admFluxIntegrand I Ψ (r • (u : EuclideanSpace ℝ (Fin (n + 1))))
      ∂TauCeti.riemannianVolume (I := 𝓡 n)
        (M := sphere (0 : EuclideanSpace ℝ (Fin (n + 1))) 1)

/-- The end chart $\Psi$ has ADM mass $m$ if its coordinate-sphere flux converges
to $m$ as $r \to +\infty$. -/
def HasADMMass
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    {n : ℕ} (Ψ : EuclideanSpace ℝ (Fin (n + 1)) → M) (m : ℝ) : Prop :=
  Tendsto (admSphereFlux I Ψ) atTop (𝓝 m)

/-- $(M^{n+1}, g)$ is asymptotically flat with a single end of decay order
$\tau > (n - 1) / 2$ outside radius $R > 0$ via $\Psi : \mathbb{R}^{n+1} \to M$
if $\Psi$ maps $\{\|x\| > R\}$ diffeomorphically onto an open subset of $M$ with
compact complement, satisfies the $C^2$ decay bounds
$|g_{ij} - \delta_{ij}| = O(\|x\|^{-\tau})$,
$\|Dg_{ij}\| = O(\|x\|^{-\tau-1})$, $\|D^2 g_{ij}\| = O(\|x\|^{-\tau-2})$, and
has integrable scalar curvature $R_g \circ \Psi \in L^1(\{\|x\| > R\})$. -/
def IsAsymptoticallyFlatSingleEnd
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    (M : Type) [TopologicalSpace M] [ChartedSpace H M] [T2Space M]
    [IsManifold I ∞ M] [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun x : M ↦ TangentSpace I x)]
    (n : ℕ) (R τ : ℝ) (Ψ : EuclideanSpace ℝ (Fin (n + 1)) → M) : Prop :=
  let ext : Set (EuclideanSpace ℝ (Fin (n + 1))) := {x | R < ‖x‖}
  0 < R ∧ ((n : ℝ) - 1) / 2 < τ ∧
  IsOpen (Ψ '' ext) ∧ IsCompact (Ψ '' ext)ᶜ ∧
  InjOn Ψ ext ∧
  ContMDiffOn 𝓘(ℝ, EuclideanSpace ℝ (Fin (n + 1))) I ∞ Ψ ext ∧
  (∀ x ∈ ext, Function.Injective (mfderiv 𝓘(ℝ, EuclideanSpace ℝ (Fin (n + 1))) I Ψ x)) ∧
  (∃ C ≥ (0 : ℝ), ∀ x ∈ ext, ∀ i j : Fin (n + 1),
    |pulledBackMetricCoeff I Ψ x i j - (if i = j then 1 else 0)| ≤ C * ‖x‖ ^ (-τ) ∧
    ‖fderiv ℝ (fun y ↦ pulledBackMetricCoeff I Ψ y i j) x‖ ≤ C * ‖x‖ ^ (-(τ + 1)) ∧
    ‖fderiv ℝ (fun y ↦ fderiv ℝ (fun z ↦ pulledBackMetricCoeff I Ψ z i j) y) x‖ ≤
      C * ‖x‖ ^ (-(τ + 2))) ∧
  IntegrableOn
    (fun x : EuclideanSpace ℝ (Fin (n + 1)) ↦ (leviCivitaConnection I M).scalarCurvature (Ψ x))
    ext volume

end SchoenYauPositiveMass

/-- **Schoen–Yau positive mass theorem.** Let $(M^{n+1}, g)$ be a complete,
connected, boundaryless smooth Riemannian manifold of dimension
$3 \le n + 1 \le 7$ ($2 \le n \le 6$) with nonnegative scalar curvature
$R_g \ge 0$ and a single asymptotically flat end of order $\tau > (n - 1) / 2$
having ADM mass $m$. Then $m \ge 0$, and if $m = 0$ then $(M, g)$ is globally
Riemannian-isometric to Euclidean space $\mathbb{R}^{n+1}$. -/
@[eval_problem]
theorem schoen_yau_positive_mass
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H) [I.Boundaryless]
    (M : Type) [TopologicalSpace M] [ChartedSpace H M] [T3Space M] [ConnectedSpace M]
    [IsManifold I ∞ M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun x : M ↦ TangentSpace I x)]
    [IsContinuousRiemannianBundle E (fun x : M ↦ TangentSpace I x)]
    {n : ℕ} (hn2 : 2 ≤ n) (hn6 : n ≤ 6) (hdim : Module.finrank ℝ E = n + 1)
    (hcomp : @CompleteSpace M (TauCeti.MetricSpace.ofRiemannianMetric I M).toUniformSpace)
    (hR : ∀ x : M, 0 ≤ (leviCivitaConnection I M).scalarCurvature x)
    {R τ m : ℝ} {Ψ : EuclideanSpace ℝ (Fin (n + 1)) → M}
    (haf : SchoenYauPositiveMass.IsAsymptoticallyFlatSingleEnd I M n R τ Ψ)
    (hm : SchoenYauPositiveMass.HasADMMass I Ψ m) :
    0 ≤ m ∧
      (m = 0 → Nonempty (TauCeti.RiemannianIsometry I 𝓘(ℝ, EuclideanSpace ℝ (Fin (n + 1)))
        M (EuclideanSpace ℝ (Fin (n + 1))))) := by
  sorry

end Geometry
end LeanEval
