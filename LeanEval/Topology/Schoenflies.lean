import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Schoenflies theorem (Arthur Moritz Schoenflies, 1906)

§48 of Knill's *Some Fundamental Theorems in Mathematics*. The strong
form: for every Jordan curve in the plane there is a self-homeomorphism
of `ℝ²` carrying the curve to the standard unit circle.

This is the faithful encoding of Knill's prose statement that "each
complementary region is homeomorphic to the disk", which as
literally written is false for the unbounded region (homeomorphic to
`ℝ² ∖ closedBall 0 1`, fundamental group `ℤ`, vs. simply connected
disk). The strong form here implies that the bounded complementary
region is homeomorphic to the disk, recovering the correct half of
Knill's claim.

Mathlib has `Metric.sphere`, `EuclideanSpace`, and `Homeomorph`, but
**no Schoenflies theorem** (`grep -ri 'schoenflies' Mathlib/`: no
hits), no Jordan curve theorem, and no associated invariance-of-domain
machinery in a form that would discharge it. Stateable with no new
definitions.
-/

/-- **Schoenflies theorem (strong form).** For every Jordan curve in
the plane there is a self-homeomorphism of `ℝ²` carrying the curve to
the standard unit circle. -/
@[eval_problem]
theorem schoenflies
    (r : Metric.sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 → EuclideanSpace ℝ (Fin 2))
    (_hcont : Continuous r) (_hinj : Function.Injective r) :
    ∃ h : EuclideanSpace ℝ (Fin 2) ≃ₜ EuclideanSpace ℝ (Fin 2),
      h '' Set.range r = Metric.sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 := by
  sorry

end Topology
end LeanEval
