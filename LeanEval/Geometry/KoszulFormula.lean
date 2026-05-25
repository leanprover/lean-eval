import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace KoszulFormula

/-!
# Koszul formula

§38 of Oliver Knill's *Some Fundamental Theorems in Mathematics* (an
additional statement of the section on Riemannian geometry; the boxed
main theorem is the Levi-Civita fundamental theorem). For any smooth
torsion-free metric-compatible covariant derivative `cov` on the tangent
bundle of a Riemannian manifold, the inner product `⟨∇_X Y, Z⟩` is
determined by the metric and Lie brackets via

`2 ⟨∇_X Y, Z⟩ = X·⟨Y, Z⟩ + Y·⟨X, Z⟩ − Z·⟨X, Y⟩`
`               − ⟨X, [Y, Z]⟩ − ⟨Y, [X, Z]⟩ + ⟨Z, [X, Y]⟩`.

This is the **Koszul formula** — the explicit identity that *forces*
uniqueness of the Levi-Civita connection.

mathlib has the covariant-derivative / Riemannian-bundle / Lie-bracket
machinery but no metric-compatibility predicate and no Koszul formula
(`grep -ri Koszul`: no relevant hits). One helper definition
(`IsMetricCompatible`, ~½ page) is added here.
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

/-- **Koszul formula.** For any smooth torsion-free metric-compatible
covariant derivative `cov` on `TM`, `2 ⟨∇_X Y, Z⟩` equals the cyclic sum
of directional derivatives `X·⟨Y, Z⟩ + Y·⟨X, Z⟩ − Z·⟨X, Y⟩` minus the
Lie-bracket cyclic sum `⟨X, [Y, Z]⟩ + ⟨Y, [X, Z]⟩ − ⟨Z, [X, Y]⟩`. -/
@[eval_problem]
theorem koszul_formula
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
      [FiniteDimensional ℝ E] [CompleteSpace E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
    {M : Type*} [TopologicalSpace M] [ChartedSpace H M]
      [IsManifold I ∞ M]
    [RiemannianBundle (fun (x : M) ↦ TangentSpace I x)]
    [IsContMDiffRiemannianBundle I ∞ E (fun (x : M) ↦ TangentSpace I x)]
    (cov : CovariantDerivative I E (TangentSpace I (M := M)))
    [ContMDiffCovariantDerivative cov ∞]
    (_htor : cov.torsion = 0) (_hmet : IsMetricCompatible cov)
    (X Y Z : Π x : M, TangentSpace I x)
    (_hX : CMDiff ∞ (T% X)) (_hY : CMDiff ∞ (T% Y)) (_hZ : CMDiff ∞ (T% Z))
    (x : M) :
    2 * inner ℝ (cov Y x (X x)) (Z x) =
      extDerivFun (fun y : M => inner ℝ (Y y) (Z y)) x (X x)
      + extDerivFun (fun y : M => inner ℝ (X y) (Z y)) x (Y x)
      - extDerivFun (fun y : M => inner ℝ (X y) (Y y)) x (Z x)
      - inner ℝ (X x) (mlieBracket I Y Z x)
      - inner ℝ (Y x) (mlieBracket I X Z x)
      + inner ℝ (Z x) (mlieBracket I X Y x) := by
  sorry

end KoszulFormula
end Geometry
end LeanEval
