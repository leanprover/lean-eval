import Mathlib.Analysis.InnerProductSpace.Projection.Submodule
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import TauCeti.Geometry.Manifold.Riemannian.Distance
import TauCeti.Geometry.Manifold.Riemannian.Geodesic.Trajectory
import TauCeti.Geometry.Manifold.Riemannian.Sphere.Radius
import TauCeti.Geometry.Manifold.Riemannian.VolumeDensity.Total
import TauCeti.Geometry.Manifold.VectorBundle.CovariantDerivative.AlongCurve.Acceleration
import TauCeti.Geometry.Manifold.VectorBundle.CovariantDerivative.Curvature.Scalar
import EvalTools.Markers

open Bundle CovariantDerivative Filter MeasureTheory Metric Set Topology
open scoped ContDiff Manifold RealInnerProductSpace

namespace LeanEval
namespace Geometry

/-!
# Bray's Riemannian Penrose Inequality

Roger Penrose (1973, *Ann. New York Acad. Sci.* 224, 125–134) argued from cosmic
censorship that the total ADM mass $m$ of an asymptotically flat initial data
set containing an apparent black-hole horizon of area $A$ must satisfy
$m \ge \sqrt{A / (16\pi)}$, with equality attained on the spatial Schwarzschild
slice of mass $m$. In the time-symmetric (Riemannian) case — a complete smooth
asymptotically flat Riemannian $3$-manifold $(M^3, g)$ of nonnegative scalar
curvature $R_g \ge 0$ with an outermost closed minimal surface $\Sigma$ (not
assumed connected) — Hubert L. Bray (2001, *Proof of the Riemannian Penrose
inequality using the positive mass theorem*, *J. Differential Geom.* 59,
177–267, Theorem 1; following Gerhard Huisken and Tom Ilmanen 2001, *J.
Differential Geom.* 59, 353–477 for a single connected component via weak
inverse mean curvature flow) proved the full inequality
$$
  m \ge \sqrt{\frac{\mathrm{Area}(\Sigma)}{16\pi}}
$$
via a continuous conformal flow of metrics preserving $R \ge 0$ and horizon
area while monotonically nonincreasing ADM mass.
-/

namespace BrayRiemannianPenrose

/-- Coordinate component $g_{ij}(x) = \langle d\Psi_x e_i, d\Psi_x e_j \rangle_g$
of the metric pulled back along $\Psi : \mathbb{R}^3 \to M$. -/
noncomputable def pulledBackMetricCoeff
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    (Ψ : EuclideanSpace ℝ (Fin 3) → M)
    (x : EuclideanSpace ℝ (Fin 3)) (i j : Fin 3) : ℝ :=
  ⟪mfderiv 𝓘(ℝ, EuclideanSpace ℝ (Fin 3)) I Ψ x (EuclideanSpace.single i 1),
    mfderiv 𝓘(ℝ, EuclideanSpace ℝ (Fin 3)) I Ψ x (EuclideanSpace.single j 1)⟫

/-- Pointwise ADM flux integrand
$\sum_{i,j=1}^3 (\partial_j g_{ij} - \partial_i g_{jj}) \frac{x_i}{\|x\|}$. -/
noncomputable def admFluxIntegrand
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    (Ψ : EuclideanSpace ℝ (Fin 3) → M) (x : EuclideanSpace ℝ (Fin 3)) : ℝ :=
  ∑ i : Fin 3, ∑ j : Fin 3,
    (fderiv ℝ (fun y ↦ pulledBackMetricCoeff I Ψ y i j) x (EuclideanSpace.single j 1) -
      fderiv ℝ (fun y ↦ pulledBackMetricCoeff I Ψ y j j) x (EuclideanSpace.single i 1)) *
      (x i / ‖x‖)

/-- Coordinate-sphere ADM mass flux at radius $r$:
$\frac{1}{16\pi} \int_{S^2} r^2 \mathcal{F}_\Psi(r u)\,dA_{S^2}(u)$. -/
noncomputable def admSphereFlux
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    (Ψ : EuclideanSpace ℝ (Fin 3) → M) (r : ℝ) : ℝ :=
  letI : Fact (Module.finrank ℝ (EuclideanSpace ℝ (Fin 3)) = 3) :=
    ⟨finrank_euclideanSpace_fin⟩
  (1 / (16 * Real.pi)) *
    ∫ u : sphere (0 : EuclideanSpace ℝ (Fin 3)) 1,
      r ^ 2 * admFluxIntegrand I Ψ (r • (u : EuclideanSpace ℝ (Fin 3)))
      ∂TauCeti.riemannianVolume (I := 𝓡 2)
        (M := sphere (0 : EuclideanSpace ℝ (Fin 3)) 1)

/-- The end chart $\Psi : \mathbb{R}^3 \to M$ has ADM mass $m$ if
`admSphereFlux I Ψ r → m` as $r \to +\infty$. -/
def HasADMMass
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    (Ψ : EuclideanSpace ℝ (Fin 3) → M) (m : ℝ) : Prop :=
  Tendsto (admSphereFlux I Ψ) atTop (𝓝 m)

/-- An asymptotically flat end of order $\tau > 1 / 2$ outside radius $R > 0$
on a Riemannian $3$-manifold $(M, g)$. -/
def IsAsymptoticallyFlatEnd3
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    (M : Type) [TopologicalSpace M] [ChartedSpace H M] [T2Space M]
    [IsManifold I ∞ M] [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun x : M ↦ TangentSpace I x)]
    (R τ : ℝ) (Ψ : EuclideanSpace ℝ (Fin 3) → M) : Prop :=
  let ext : Set (EuclideanSpace ℝ (Fin 3)) := {x | R < ‖x‖}
  0 < R ∧ (1 : ℝ) / 2 < τ ∧
  IsOpen (Ψ '' ext) ∧ InjOn Ψ ext ∧
  ContMDiffOn 𝓘(ℝ, EuclideanSpace ℝ (Fin 3)) I ∞ Ψ ext ∧
  (∀ x ∈ ext, Function.Injective (mfderiv 𝓘(ℝ, EuclideanSpace ℝ (Fin 3)) I Ψ x)) ∧
  (∃ C ≥ (0 : ℝ), ∀ x ∈ ext, ∀ i j : Fin 3,
    |pulledBackMetricCoeff I Ψ x i j - (if i = j then 1 else 0)| ≤ C * ‖x‖ ^ (-τ) ∧
    ‖fderiv ℝ (fun y ↦ pulledBackMetricCoeff I Ψ y i j) x‖ ≤ C * ‖x‖ ^ (-(τ + 1)) ∧
    ‖fderiv ℝ (fun y ↦ fderiv ℝ (fun z ↦ pulledBackMetricCoeff I Ψ z i j) y) x‖ ≤
      C * ‖x‖ ^ (-(τ + 2))) ∧
  IntegrableOn
    (fun x : EuclideanSpace ℝ (Fin 3) ↦ (leviCivitaConnection I M).scalarCurvature (Ψ x))
    ext volume

/-- A map $f : \Sigma \to M$ is a $C^\infty$ Riemannian isometric embedding. -/
def IsSmoothIsometricEmbedding
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {S : Type} [TopologicalSpace S] [ChartedSpace (EuclideanSpace ℝ (Fin 2)) S]
    [RiemannianBundle (fun x : S ↦ TangentSpace (𝓡 2) x)]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    [RiemannianBundle (fun y : M ↦ TangentSpace I y)]
    (f : S → M) : Prop :=
  ContMDiff (𝓡 2) I ∞ f ∧ _root_.Topology.IsEmbedding f ∧
    ∀ (x : S) (u v : TangentSpace (𝓡 2) x),
      ⟪mfderiv (𝓡 2) I f x u, mfderiv (𝓡 2) I f x v⟫ = ⟪u, v⟫

/-- Ambient mean curvature vector $H_f(x) \in (df_x(T_x \Sigma))^\perp$ of an
isometrically embedded surface $f : \Sigma \to M$, defined as the trace over an
orthonormal basis of $T_x \Sigma$ of the normal projection of the ambient
Levi-Civita acceleration of $f \circ \gamma_{x, e_i}$ at $t = 0$. -/
noncomputable def surfaceMeanCurvature
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    {S : Type} [TopologicalSpace S] [T2Space S] [ChartedSpace (EuclideanSpace ℝ (Fin 2)) S]
    [IsManifold (𝓡 2) ∞ S] [RiemannianBundle (fun x : S ↦ TangentSpace (𝓡 2) x)]
    [IsContMDiffRiemannianBundle (𝓡 2) ∞ (EuclideanSpace ℝ (Fin 2))
      (fun x : S ↦ TangentSpace (𝓡 2) x)]
    {M : Type} [TopologicalSpace M] [T2Space M] [ChartedSpace H M] [IsManifold I ∞ M]
    [RiemannianBundle (fun y : M ↦ TangentSpace I y)]
    [IsContMDiffRiemannianBundle I ∞ E (fun y : M ↦ TangentSpace I y)]
    (f : S → M) (x : S) : TangentSpace I (f x) :=
  let b := stdOrthonormalBasis ℝ (TangentSpace (𝓡 2) x)
  ∑ i, (Submodule.orthogonal (LinearMap.range (mfderiv (𝓡 2) I f x).toLinearMap)).starProjection
    ((leviCivitaConnection I M).acceleration
      (f ∘ TauCeti.Manifold.maximalGeodesic (𝓡 2) S x (b i)) 0)

/-- A subset $K \subseteq M$ is a closed smooth embedded minimal surface if it
is the image of a nonempty compact Hausdorff smooth Riemannian $2$-manifold
under a smooth isometric embedding of identically vanishing mean curvature. -/
def IsClosedMinimalSurface
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    (M : Type) [TopologicalSpace M] [T2Space M] [ChartedSpace H M] [IsManifold I ∞ M]
    [RiemannianBundle (fun y : M ↦ TangentSpace I y)]
    [IsContMDiffRiemannianBundle I ∞ E (fun y : M ↦ TangentSpace I y)]
    (K : Set M) : Prop :=
  ∃ (S : Type) (_ : TopologicalSpace S) (_ : T2Space S) (_ : CompactSpace S)
    (_ : Nonempty S) (_ : ChartedSpace (EuclideanSpace ℝ (Fin 2)) S)
    (_ : IsManifold (𝓡 2) ∞ S)
    (_ : RiemannianBundle (fun x : S ↦ TangentSpace (𝓡 2) x))
    (_ : IsContMDiffRiemannianBundle (𝓡 2) ∞ (EuclideanSpace ℝ (Fin 2))
      (fun x : S ↦ TangentSpace (𝓡 2) x))
    (f : S → M),
    IsSmoothIsometricEmbedding I f ∧ range f = K ∧
      ∀ x : S, surfaceMeanCurvature I f x = 0

end BrayRiemannianPenrose

/-- **Bray's Riemannian Penrose inequality.** Let $(M^3, g)$ be a complete,
connected, boundaryless smooth Riemannian $3$-manifold with nonnegative scalar
curvature $R_g \ge 0$ and an asymptotically flat end $\Psi$ of order
$\tau > 1 / 2$ outside radius $R$ having ADM mass $m$. If $\Omega \subseteq M$
is an open connected exterior region containing $\Psi(\{\|x\| > R\})$ with
$\overline{\Omega} \setminus \Psi(\{\|x\| > R\})$ compact, containing no closed
smooth embedded minimal surface in $\Omega$, and whose topological boundary
$\partial \Omega$ is the image of a nonempty compact smooth Riemannian
$2$-manifold $\Sigma$ under a smooth isometric embedding $f : \Sigma \to M$ of
vanishing mean curvature, then
$\sqrt{\mathrm{Area}(\Sigma) / (16\pi)} \le m$. -/
@[eval_problem]
theorem bray_riemannian_penrose
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type} [TopologicalSpace H] (I : ModelWithCorners ℝ E H) [I.Boundaryless]
    (M : Type) [TopologicalSpace M] [ChartedSpace H M] [T3Space M] [ConnectedSpace M]
    [IsManifold I ∞ M]
    [RiemannianBundle (fun x : M ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun x : M ↦ TangentSpace I x)]
    [IsContinuousRiemannianBundle E (fun x : M ↦ TangentSpace I x)]
    (hdim : Module.finrank ℝ E = 3)
    (hcomp : @CompleteSpace M (TauCeti.MetricSpace.ofRiemannianMetric I M).toUniformSpace)
    (hR : ∀ x : M, 0 ≤ (leviCivitaConnection I M).scalarCurvature x)
    {R τ m : ℝ} {Ψ : EuclideanSpace ℝ (Fin 3) → M}
    (haf : BrayRiemannianPenrose.IsAsymptoticallyFlatEnd3 I M R τ Ψ)
    (hm : BrayRiemannianPenrose.HasADMMass I Ψ m)
    {S : Type} [TopologicalSpace S] [T2Space S] [CompactSpace S] [Nonempty S]
    [MeasurableSpace S] [BorelSpace S]
    [ChartedSpace (EuclideanSpace ℝ (Fin 2)) S] [IsManifold (𝓡 2) ∞ S]
    [RiemannianBundle (fun x : S ↦ TangentSpace (𝓡 2) x)]
    [IsContMDiffRiemannianBundle (𝓡 2) ∞ (EuclideanSpace ℝ (Fin 2))
      (fun x : S ↦ TangentSpace (𝓡 2) x)]
    [IsContinuousRiemannianBundle (EuclideanSpace ℝ (Fin 2))
      (fun x : S ↦ TangentSpace (𝓡 2) x)]
    {f : S → M} (hf : BrayRiemannianPenrose.IsSmoothIsometricEmbedding I f)
    (hmin : ∀ x : S, BrayRiemannianPenrose.surfaceMeanCurvature I f x = 0)
    {Ω : Set M} (hΩ_open : IsOpen Ω) (hΩ_conn : IsConnected Ω)
    (hΩ_end : Ψ '' {x : EuclideanSpace ℝ (Fin 3) | R < ‖x‖} ⊆ Ω)
    (hΩ_cpt : IsCompact (closure Ω \ (Ψ '' {x : EuclideanSpace ℝ (Fin 3) | R < ‖x‖})))
    (hΩ_bdry : frontier Ω = range f)
    (hΩ_outer : ∀ K ⊆ Ω, ¬ BrayRiemannianPenrose.IsClosedMinimalSurface I M K) :
    Real.sqrt (TauCeti.riemannianTotalVolume (𝓡 2) S / (16 * Real.pi)) ≤ m := by
  sorry

end Geometry
end LeanEval
