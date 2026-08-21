import Mathlib.Analysis.Complex.Circle
import Mathlib.Data.ZMod.Basic
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Topology.Homotopy.HomotopyGroup
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

namespace Submission

theorem pi3_sphere_two_mulEquiv_int (x : Metric.sphere (0 : EuclideanSpace ℝ (Fin 3)) 1) :
    Nonempty
      (HomotopyGroup.Pi 3 (Metric.sphere (0 : EuclideanSpace ℝ (Fin 3)) 1) x ≃*
        Multiplicative ℤ) := by
  sorry

end Submission
