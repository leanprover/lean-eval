import Mathlib
import EvalTools.Markers

namespace LeanEval.Geometry.SphereTheorem

/-!
# The sphere theorems (Berger–Klingenberg–Rauch; Brendle–Schoen)

`sphere_theorem`: a closed, simply-connected, strictly quarter-pinched Riemannian
manifold is homeomorphic to the standard sphere (Berger–Klingenberg–Rauch 1960).
`differentiable_sphere_theorem`: under the same hypotheses it is diffeomorphic to
the sphere (Brendle–Schoen 2007, via Ricci flow). The trusted helpers
(`IsMetricCompatible`, `curv`, `QuarterPinched`) are non-holes; following §38,
the Levi-Civita connection is hypothesized as a smooth torsion-free
metric-compatible covariant derivative (Mathlib has the covariant-derivative
interface but does not yet construct Levi-Civita). Mathlib has no Riemann
curvature tensor, sectional curvature, pinching, or Ricci flow.

Category-(b) candidates from §121 of the Knill survey.
-/

open scoped Manifold ContDiff Bundle Topology
open Bundle ContDiff Set VectorField CovariantDerivative Metric

variable
  {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E] [CompleteSpace E]
  {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
  {M : Type*} [TopologicalSpace M] [ChartedSpace H M]
    [IsManifold I ∞ M]
  [RiemannianBundle (fun (x : M) ↦ TangentSpace I x)]
  [IsContMDiffRiemannianBundle I ∞ E (fun (x : M) ↦ TangentSpace I x)]

/-- A covariant derivative `cov` is **compatible with the Riemannian metric**:
`v · ⟨Y, Z⟩ = ⟨∇_v Y, Z⟩ + ⟨Y, ∇_v Z⟩`. -/
def IsMetricCompatible
    (cov : CovariantDerivative I E (TangentSpace I (M := M))) : Prop :=
  ∀ (Y Z : Π x : M, TangentSpace I x),
    CMDiff ∞ (T% Y) → CMDiff ∞ (T% Z) →
    ∀ (x : M) (v : TangentSpace I x),
      mvfderiv I (fun y : M => inner ℝ (Y y) (Z y)) x v =
        inner ℝ (cov Y x v) (Z x) + inner ℝ (Y x) (cov Z x v)

/-- The **Riemann curvature tensor** of `cov` on smooth vector fields:
`R(X,Y)Z = ∇_X ∇_Y Z − ∇_Y ∇_X Z − ∇_{[X,Y]} Z`. -/
noncomputable def curv (cov : CovariantDerivative I E (TangentSpace I (M := M)))
    (X Y Z : Π x : M, TangentSpace I x) : Π x : M, TangentSpace I x :=
  fun x =>
    cov (fun y => cov Z y (Y y)) x (X x)
      - cov (fun y => cov Z y (X y)) x (Y x)
      - cov Z x (mlieBracket I X Y x)

/-- The manifold is **strictly quarter-pinched**: every sectional curvature
`K = ⟨R(X,Y)Y, X⟩` at an orthonormal pair lies in Knill's interval `(1, 4]`. -/
def QuarterPinched
    (cov : CovariantDerivative I E (TangentSpace I (M := M))) : Prop :=
  ∀ (X Y : Π x : M, TangentSpace I x),
    CMDiff ∞ (T% X) → CMDiff ∞ (T% Y) →
    ∀ x : M,
      inner ℝ (X x) (X x) = (1 : ℝ) → inner ℝ (Y x) (Y x) = (1 : ℝ) →
      inner ℝ (X x) (Y x) = (0 : ℝ) →
      (1 : ℝ) < inner ℝ (curv cov X Y Y x) (X x) ∧
        inner ℝ (curv cov X Y Y x) (X x) ≤ (4 : ℝ)

/-- **Topological sphere theorem** (Berger–Klingenberg–Rauch 1960). A closed,
simply-connected, smooth `d`-manifold (`d ≥ 2`) whose Levi-Civita connection is
strictly quarter-pinched is homeomorphic to the standard `d`-sphere. -/
@[eval_problem]
theorem sphere_theorem
    [I.Boundaryless] [T2Space M] [CompactSpace M] [SimplyConnectedSpace M]
    (hdim : 2 ≤ Module.finrank ℝ E)
    (cov : CovariantDerivative I E (TangentSpace I (M := M)))
    [ContMDiffCovariantDerivative cov ∞]
    (_htor : cov.torsion = 0) (_hmet : IsMetricCompatible cov)
    (_hpinch : QuarterPinched cov) :
    Nonempty
      (M ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin (Module.finrank ℝ E + 1))) 1) := by
  sorry

/-- **Differentiable sphere theorem** (Brendle–Schoen 2007). Under the same
hypotheses, `M` is diffeomorphic to the standard `d`-sphere. -/
@[eval_problem]
theorem differentiable_sphere_theorem
    [I.Boundaryless] [T2Space M] [CompactSpace M] [SimplyConnectedSpace M]
    (hdim : 2 ≤ Module.finrank ℝ E)
    (cov : CovariantDerivative I E (TangentSpace I (M := M)))
    [ContMDiffCovariantDerivative cov ∞]
    (_htor : cov.torsion = 0) (_hmet : IsMetricCompatible cov)
    (_hpinch : QuarterPinched cov) :
    Nonempty
      (M ≃ₘ⟮I, 𝓡 (Module.finrank ℝ E)⟯
        (sphere (0 : EuclideanSpace ℝ (Fin (Module.finrank ℝ E + 1))) 1)) := by
  sorry

end LeanEval.Geometry.SphereTheorem
