import Mathlib.Analysis.Complex.Circle
import Mathlib.Data.ZMod.Basic
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Topology.Homotopy.HomotopyGroup
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem pi1_circle_mulEquiv_int :
    Nonempty (HomotopyGroup.Pi 1 Circle (1 : Circle) ≃* Multiplicative ℤ) := by
  exact Submission.pi1_circle_mulEquiv_int
