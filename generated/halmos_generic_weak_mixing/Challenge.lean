import ChallengeDeps

open LeanEval.Dynamics.HalmosGenericWeakMixingProblem
open MeasureTheory Filter Topology
open scoped symmDiff

variable {X : Type*} [MeasurableSpace X]

theorem generic_weakly_mixing [StandardBorelSpace X]
    (m : Measure X) [IsProbabilityMeasure m] [NoAtoms m] :
    (∃ G : Set (Automorphism m), IsGδ G ∧ Dense G ∧
      ∀ T ∈ G, IsWeaklyMixing m T) ∧
    (∀ T : Automorphism m, IsWeaklyMixing m T →
      Ergodic (T.toEquiv : X → X) m) := by
  sorry
