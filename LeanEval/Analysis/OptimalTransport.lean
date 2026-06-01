import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Monge–Kantorovich existence theorem

§73 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. Given Polish
probability spaces `(X, P)` and `(Y, Q)` and a continuous cost
`c : X × Y → [0, ∞]`, the Kantorovich functional `I(π) = ∫ c dπ` attains its
infimum on the set of couplings `Π(P, Q)` — the probability measures on `X × Y`
with marginals `P` and `Q` (Kantorovich 1942, after Monge 1781).

mathlib has Polish spaces, marginals (`Measure.fst`, `Measure.snd`), the
weak-convergence topology, Prokhorov's theorem, lower semicontinuity, and the
extreme-value theorem, but no optimal-transport content: no couplings, no
Kantorovich functional, and no existence of an optimal coupling
(`grep -ri "kantorovich\|monge\|wasserstein\|coupling"` in mathlib returns no
algorithmic content). The couplings and the functional are supplied as helper
definitions here.
-/

open MeasureTheory Set

/-- `Couplings P Q`: the probability measures on `X × Y` whose marginals are `P`
on `X` and `Q` on `Y`. -/
def Couplings {X Y : Type*} [MeasurableSpace X] [MeasurableSpace Y]
    (P : Measure X) (Q : Measure Y) : Set (Measure (X × Y)) :=
  {π | IsProbabilityMeasure π ∧ π.fst = P ∧ π.snd = Q}

/-- The Kantorovich functional `I(π) = ∫ c dπ` on measures over `X × Y`. -/
noncomputable def kantorovichCost {X Y : Type*}
    [MeasurableSpace X] [MeasurableSpace Y]
    (c : X × Y → ENNReal) (π : Measure (X × Y)) : ENNReal :=
  ∫⁻ p, c p ∂π

/-- **Monge–Kantorovich existence theorem** (§73). For Polish probability spaces
`(X, P)` and `(Y, Q)` and a continuous cost `c : X × Y → [0, ∞]`, the Kantorovich
functional `I(π) = ∫ c dπ` attains its infimum on the set of couplings `Π(P, Q)`
of `P` and `Q`. -/
@[eval_problem]
theorem monge_kantorovich_exists
    {X Y : Type*}
    [TopologicalSpace X] [PolishSpace X] [MeasurableSpace X] [BorelSpace X]
    [TopologicalSpace Y] [PolishSpace Y] [MeasurableSpace Y] [BorelSpace Y]
    (P : Measure X) (Q : Measure Y)
    [IsProbabilityMeasure P] [IsProbabilityMeasure Q]
    (c : X × Y → ENNReal) (_hc : Continuous c) :
    ∃ π ∈ Couplings P Q,
      ∀ π' ∈ Couplings P Q, kantorovichCost c π ≤ kantorovichCost c π' := by
  sorry

end Analysis
end LeanEval
