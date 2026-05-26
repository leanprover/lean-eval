import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Jordan–Brouwer separation theorem (L. E. J. Brouwer, 1912)

§48 of Knill's *Some Fundamental Theorems in Mathematics*. The
high-dimensional generalization of the Jordan curve theorem: for
`d ≥ 2`, the complement in `ℝᵈ` of any topological `(d−1)`-sphere —
the image of any continuous injection from the unit `(d−1)`-sphere
into `ℝᵈ` — has exactly two connected components.

The hypothesis `2 ≤ d` is essential: in dimension `d = 1` the
`(d−1)`-sphere is the two-point set `{−1, 1}`, whose complement in
`ℝ` has *three* connected components (left of −1, between −1 and 1,
right of 1).

Mathlib has `Metric.sphere`, `EuclideanSpace`, `ConnectedComponents`,
`Nat.card`, but **no Jordan–Brouwer separation theorem**, no Alexander
duality, no invariance of domain in a form that would discharge it.
Stateable with no new definitions.
-/

/-- **Jordan–Brouwer separation theorem.** For `d ≥ 2`, the
complement in `ℝᵈ` of a topological `(d−1)`-sphere (the image of any
continuous injection from the unit `(d−1)`-sphere into `ℝᵈ`) has
exactly two connected components. -/
@[eval_problem]
theorem jordan_brouwer (d : ℕ) (_hd : 2 ≤ d)
    (r : Metric.sphere (0 : EuclideanSpace ℝ (Fin d)) 1 → EuclideanSpace ℝ (Fin d))
    (_hcont : Continuous r) (_hinj : Function.Injective r) :
    Nat.card
        (ConnectedComponents ((Set.range r)ᶜ : Set (EuclideanSpace ℝ (Fin d)))) =
      2 := by
  sorry

end Topology
end LeanEval
