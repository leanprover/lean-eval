import LeanEval.Topology.Prelude

/-!
# Basic facts about 3-dimensional handlebodies
-/

namespace LeanEval.Topology

/-- The boundary of a 3D handlebody is homeomorphic to the corresponding representative surface. -/
@[eval_problem]
def frontierHandlebody₃HomeomorphOrientableRepr (g : ℕ) (hg : g ≠ 0) :
    frontier (handlebody₃ g) ≃ₜ Surface.OrientableRepr g 0 := by
  sorry

/-- The boundary of a genus 0 3D handlebody is homeomorphic to the sphere. -/
@[eval_problem]
def frontierHandlebody₃HomeomorphSphere :
    frontier (handlebody₃ 0) ≃ₜ Metric.sphere (0 : EuclideanSpace ℝ (Fin 3)) 1 := by
  sorry

/-- The boundary of a genus 1 3D handlebody is homeomorphic to a torus
(the product of two circles). -/
@[eval_problem]
def frontierHandlebody₃HomeomorphAddCircleProd :
    frontier (handlebody₃ 1) ≃ₜ AddCircle (1 : ℝ) × AddCircle (1 : ℝ) := by
  sorry

/-- The complement of our handlebody in ℝ³ is homeomorphic to the interior of the handlebody
with a point removed. -/
@[eval_problem]
def complHandlebody₃Homeomorph (g : ℕ) :
    ↥(handlebody₃ g)ᶜ ≃ₜ ↥(interior (handlebody₃ g) \ {(0.5, 0.5, 1.5)}) := by
  sorry

end LeanEval.Topology
