import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.WeinsteinConjecture3DProblem
open Set
open scoped Manifold ContDiff

variable {E H M : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  [FiniteDimensional ℝ E] [TopologicalSpace H] [TopologicalSpace M]
  [ChartedSpace H M]
variable (I : ModelWithCorners ℝ E H)
variable [IsManifold I ∞ M]

namespace Submission

theorem weinstein_conjecture_dim_three (E' : Type*) [NormedAddCommGroup E'] [NormedSpace ℝ E']
    [FiniteDimensional ℝ E']
    (H' : Type*) [TopologicalSpace H']
    (I' : ModelWithCorners ℝ E' H')
    (M' : Type*) [TopologicalSpace M'] [ChartedSpace H' M'] [IsManifold I' ∞ M']
    [T2Space M'] [CompactSpace M'] [Nonempty M'] [Fact (Module.finrank ℝ E' = 3)]
    [I'.Boundaryless]
    (α : OneForm I' (M := M')) (dα : TwoForm I' (M := M'))
    (R : ∀ x : M', TangentSpace I' x)
    (_hcontact : IsContactForm3 I' α dα)
    (_hReeb : IsReebVectorField I' α dα R) :
    HasClosedReebOrbit I' R := by
  sorry

end Submission
