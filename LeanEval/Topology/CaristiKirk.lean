import Mathlib
import EvalTools.Markers

namespace LeanEval.Topology.CaristiKirk

/-!
# Caristi-Kirk fixed point theorem

`caristi_kirk`: every self-map of a complete metric space satisfying the
Caristi inward inequality for a nonnegative lower-semicontinuous potential has
a fixed point. The helper `HasCaristiInwardPotential` records the existence of
such a potential `φ` whose drop dominates the displacement `dist x (T x)`.
Category-(b) candidate from §228 of the Knill survey.
-/

open Function

variable {X : Type*} [MetricSpace X]

/-- A Caristi inward condition for a map `T`: there is a nonnegative
lower-semicontinuous potential `φ` whose drop dominates the displacement
`dist x (T x)`. -/
def HasCaristiInwardPotential (T : X → X) : Prop :=
  ∃ φ : X → ℝ,
    LowerSemicontinuous φ ∧
      (∀ x, 0 ≤ φ x) ∧
        ∀ x, dist x (T x) ≤ φ x - φ (T x)

/-- **Caristi-Kirk fixed-point theorem** (§228).  Every self-map of a complete
metric space satisfying the Caristi inward condition has a fixed point. -/
@[eval_problem]
theorem caristi_kirk [Nonempty X] [CompleteSpace X] (T : X → X)
    (hT : HasCaristiInwardPotential T) :
    ∃ x : X, IsFixedPt T x := by
  sorry

end LeanEval.Topology.CaristiKirk
