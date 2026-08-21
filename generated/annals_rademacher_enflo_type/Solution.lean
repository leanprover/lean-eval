import ChallengeDeps
import Submission

open RademacherEnfloType
open Function MeasureTheory ProbabilityTheory Measure NNReal
open scoped ENNReal

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]
variable (X : Type*) [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]

theorem theorem_1_1 (p : ℝ) (h1p : 1 ≤ p) (hp2 : p ≤ 2) :
    TR X p ≤ TE X p ∧ TE X p ≤ (pi / sqrt 2) * TR X p := by
  exact Submission.theorem_1_1 X p h1p hp2
