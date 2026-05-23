import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry

/-!
# Fundamental theorem of Riemannian geometry (Levi-Civita)

§38 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. On a `C^∞`
finite-dimensional Riemannian manifold `(M, g)`, there exists a unique
smooth torsion-free covariant derivative on `TM` that is compatible with
the metric — the **Levi-Civita connection**.

mathlib has `CovariantDerivative` on a tangent bundle,
`CovariantDerivative.torsion`, `ContMDiffCovariantDerivative`,
`RiemannianBundle`, `IsContMDiffRiemannianBundle`, and `extDerivFun` — but
no metric-compatibility predicate, no Levi-Civita existence/uniqueness, and
no Koszul formula (`grep -ri LeviCivita\|metric.compatible`: no relevant
hits). One helper definition (`IsMetricCompatible`, ~½ page) and an
"agreement on smooth sections" predicate (`SameOnSmooth`, mathlib's
`CovariantDerivative` is bundled over all sections including non-smooth
ones, so uniqueness is stated on the smooth-section subspace) are added
here.
-/

open scoped Manifold ContDiff Bundle Topology
open Bundle ContDiff Set VectorField CovariantDerivative

/-- A covariant derivative `cov` on `TM` is **compatible with the
Riemannian metric** if `v · ⟨Y, Z⟩ = ⟨∇_v Y, Z⟩ + ⟨Y, ∇_v Z⟩` for all
smooth vector fields `Y, Z` and every point/direction `(x, v)`. -/
def IsMetricCompatible
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
      [FiniteDimensional ℝ E] [CompleteSpace E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
    {M : Type*} [TopologicalSpace M] [ChartedSpace H M]
      [IsManifold I ∞ M]
    [RiemannianBundle (fun (x : M) ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun (x : M) ↦ TangentSpace I x)]
    (cov : CovariantDerivative I E (TangentSpace I (M := M))) : Prop :=
  ∀ (Y Z : Π x : M, TangentSpace I x),
    CMDiff ∞ (T% Y) → CMDiff ∞ (T% Z) →
    ∀ (x : M) (v : TangentSpace I x),
      extDerivFun (fun y : M => inner ℝ (Y y) (Z y)) x v =
        inner ℝ (cov Y x v) (Z x) + inner ℝ (Y x) (cov Z x v)

/-- Two covariant derivatives **agree on smooth sections** if they produce
the same image on every smooth vector field. mathlib's
`CovariantDerivative` is bundled over all sections; the textbook Levi-Civita
uniqueness statement is uniqueness on the smooth-section subspace, captured
by `SameOnSmooth`. -/
def SameOnSmooth
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
      [FiniteDimensional ℝ E] [CompleteSpace E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
    {M : Type*} [TopologicalSpace M] [ChartedSpace H M]
      [IsManifold I ∞ M]
    [RiemannianBundle (fun (x : M) ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun (x : M) ↦ TangentSpace I x)]
    (cov cov' : CovariantDerivative I E (TangentSpace I (M := M))) : Prop :=
  ∀ (Y : Π x : M, TangentSpace I x), CMDiff ∞ (T% Y) →
    ∀ (x : M) (v : TangentSpace I x), cov Y x v = cov' Y x v

/-- **Fundamental theorem of Riemannian geometry** (Levi-Civita). On a
`C^∞` finite-dimensional Riemannian manifold there exists a smooth
torsion-free metric-compatible covariant derivative on `TM`, and any other
such connection agrees with it on smooth vector fields. -/
@[eval_problem]
theorem levi_civita_exists_unique
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
      [FiniteDimensional ℝ E] [CompleteSpace E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
    {M : Type*} [TopologicalSpace M] [ChartedSpace H M]
      [IsManifold I ∞ M]
    [RiemannianBundle (fun (x : M) ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun (x : M) ↦ TangentSpace I x)] :
    ∃ cov : CovariantDerivative I E (TangentSpace I (M := M)),
      (ContMDiffCovariantDerivative cov ∞ ∧
        cov.torsion = 0 ∧ IsMetricCompatible cov) ∧
      ∀ cov' : CovariantDerivative I E (TangentSpace I (M := M)),
        (ContMDiffCovariantDerivative cov' ∞ ∧
          cov'.torsion = 0 ∧ IsMetricCompatible cov') →
        SameOnSmooth cov cov' := by
  sorry

end Geometry
end LeanEval
