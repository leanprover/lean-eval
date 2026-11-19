import Mathlib

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



end Analysis
end LeanEval
