import Mathlib

namespace LeanEval
namespace Dynamics

/-!
# Poincaré–Bendixson theorem

§63 of Knill's *Some Fundamental Theorems in Mathematics*. For a `C¹`
autonomous vector field `F : ℝ² → ℝ²` and a forward integral curve `γ`
on `[0, ∞)`, one of three alternatives holds: the forward orbit is
unbounded; the ω-limit set `⋂ s, closure (γ '' [s, ∞))` contains an
equilibrium of `F`; or the ω-limit set equals the range of a
non-constant periodic integral curve of `F`.

The bounded branch uses "ω-limit contains an equilibrium" rather than
"γ converges to an equilibrium": planar orbits in a bounded forward-
invariant region may accumulate on continua of equilibria or polycycles
without converging to any single point. The non-degeneracy `F (β 0) ≠ 0`
excludes a constant equilibrium curve from vacuously satisfying the
periodic branch. The periodic-branch conclusion is range-of-periodic-
orbit; "limit cycle" in the strict sense (isolated, attracting nearby
trajectories) is not asserted.
-/

open Filter Topology Set

/-- Ambient space: `ℝ²`. -/
abbrev Plane := EuclideanSpace ℝ (Fin 2)



end Dynamics
end LeanEval
