import ChallengeDeps
import Submission

open LeanEval.Analysis
open MeasureTheory Set

theorem monge_kantorovich_exists {X Y : Type*}
    [TopologicalSpace X] [PolishSpace X] [MeasurableSpace X] [BorelSpace X]
    [TopologicalSpace Y] [PolishSpace Y] [MeasurableSpace Y] [BorelSpace Y]
    (P : Measure X) (Q : Measure Y)
    [IsProbabilityMeasure P] [IsProbabilityMeasure Q]
    (c : X × Y → ENNReal) (_hc : Continuous c) :
    ∃ π ∈ Couplings P Q,
      ∀ π' ∈ Couplings P Q, kantorovichCost c π ≤ kantorovichCost c π' := by
  exact Submission.monge_kantorovich_exists P Q c _hc
