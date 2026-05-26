import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Jordan curve theorem (Camille Jordan, 1887)

§48 of Knill's *Some Fundamental Theorems in Mathematics*. A simple
closed curve in the plane separates it into exactly two regions.
Formalized as: for every continuous injection
`r : S¹ → ℝ²`, the complement of its image has exactly two connected
components.

Mathlib has `Metric.sphere`, `EuclideanSpace`, `ConnectedComponents`,
`Nat.card`, but **no Jordan curve theorem** (`grep -ri 'jordan curve'
Mathlib/`: no hits), no Schoenflies theorem, no Jordan–Brouwer
separation theorem, no winding numbers / invariance of domain in a form
that would discharge it. Stateable with no new definitions.
-/

/-- **Jordan curve theorem** (Camille Jordan, 1887). For every
continuous injection `r : S¹ → ℝ²` from the unit circle to the plane,
the complement of its image has exactly two connected components. -/
@[eval_problem]
theorem jordan_curve
    (r : Metric.sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 → EuclideanSpace ℝ (Fin 2))
    (_hcont : Continuous r) (_hinj : Function.Injective r) :
    Nat.card
        (ConnectedComponents ((Set.range r)ᶜ : Set (EuclideanSpace ℝ (Fin 2)))) =
      2 := by
  sorry

end Topology
end LeanEval
