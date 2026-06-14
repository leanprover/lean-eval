import ChallengeDeps
import Submission

open LeanEval.Geometry.KoszulFormula
open scoped Manifold ContDiff Bundle Topology
open Bundle ContDiff Set VectorField CovariantDerivative

theorem koszul_formula {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
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
      mvfderiv I (fun y : M => inner ℝ (Y y) (Z y)) x (X x)
      + mvfderiv I (fun y : M => inner ℝ (X y) (Z y)) x (Y x)
      - mvfderiv I (fun y : M => inner ℝ (X y) (Y y)) x (Z x)
      - inner ℝ (X x) (mlieBracket I Y Z x)
      - inner ℝ (Y x) (mlieBracket I X Z x)
      + inner ℝ (Z x) (mlieBracket I X Y x) := by
  exact Submission.koszul_formula cov _htor _hmet X Y Z _hX _hY _hZ x
