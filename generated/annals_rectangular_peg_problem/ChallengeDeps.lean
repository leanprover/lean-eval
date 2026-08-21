import Mathlib.Analysis.SpecialFunctions.Complex.Circle
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Geometry.Manifold.SmoothEmbedding
import Mathlib.Topology.MetricSpace.Similarity
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from The rectangular peg problem

We formalise the statement of the main result from J. E. Greene and A. Lobb,
`The rectangular peg problem`, Annals of Math, 194 (2) 2021.
-/

set_option autoImplicit false

namespace RectangularPegProblem

open Manifold Complex Real

open scoped ContDiff

/-- A rectangle `R` in the complex plane with opposite corners `z` and `w` and rotated by an angle
`θ`. -/
noncomputable def R (z w : ℂ) (θ : Angle) : Fin 4 → ℂ :=
  ![z * θ.toCircle, (w.re + z.im * I) * θ.toCircle, w * θ.toCircle, (z.re + w.im * I) * θ.toCircle]



end RectangularPegProblem
