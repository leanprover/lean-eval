import Mathlib.Analysis.Complex.Circle
import Mathlib.Data.ZMod.Basic
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Topology.Homotopy.HomotopyGroup
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem pin_sphere_n_mulEquiv_int (n : ℕ)
    (x : Metric.sphere (0 : EuclideanSpace ℝ (Fin (n + 2))) 1) :
    Nonempty
      (HomotopyGroup.Pi (n + 1) (Metric.sphere (0 : EuclideanSpace ℝ (Fin (n + 2))) 1) x ≃*
        Multiplicative ℤ) := by
  exact Submission.pin_sphere_n_mulEquiv_int n x
