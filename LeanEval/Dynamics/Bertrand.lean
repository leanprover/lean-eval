import Mathlib
import EvalTools.Markers

namespace LeanEval.Dynamics.Bertrand

/-!
# Bertrand's theorem on central-force motion

`bertrand_central_force` (Bertrand 1873): among central potentials admitting a
non-circular bounded non-collision orbit, those for which *every* bounded
non-collision orbit is periodic are exactly the Hooke (harmonic) and Kepler
(inverse-radius) potentials. Trusted helpers (`velocity`, `acceleration`,
`centralAcceleration`, `IsCentralOrbit`, `IsBoundedOrbit`, `IsPeriodicOrbit`,
`AllBoundedOrbitsPeriodic`, `HasNonCircularBoundedOrbit`, `IsBertrandPotential`)
are non-holes; the non-degeneracy hypothesis is essential. Mathlib has no
central-force/Bertrand theory.
Category-(b) candidate from §156 of the Knill survey.
-/

/-- The physical plane. -/
abbrev Plane := EuclideanSpace ℝ (Fin 2)

/-- Velocity of a parametrized orbit. -/
noncomputable def velocity (q : ℝ → Plane) (t : ℝ) : Plane := fderiv ℝ q t 1

/-- Acceleration of a parametrized orbit. -/
noncomputable def acceleration (q : ℝ → Plane) (t : ℝ) : Plane :=
  fderiv ℝ (fun s => velocity q s) t 1

/-- The acceleration field of a radial potential `V`: `-V'(ρ) x / ρ`. -/
noncomputable def centralAcceleration (V : ℝ → ℝ) (x : Plane) : Plane :=
  -((deriv V ‖x‖) / ‖x‖) • x

/-- A global non-collision `C²` solution of the central-force equation. -/
def IsCentralOrbit (V : ℝ → ℝ) (q : ℝ → Plane) : Prop :=
  ContDiff ℝ 2 q ∧ (∀ t, q t ≠ 0) ∧
    ∀ t, acceleration q t = centralAcceleration V (q t)

/-- The orbit is bounded in phase space (position and velocity). -/
def IsBoundedOrbit (q : ℝ → Plane) : Prop :=
  Bornology.IsBounded (Set.range q) ∧
    Bornology.IsBounded (Set.range (velocity q))

/-- The orbit closes up after a positive time. -/
def IsPeriodicOrbit (q : ℝ → Plane) : Prop :=
  ∃ T : ℝ, 0 < T ∧ Function.Periodic q T

/-- Every bounded global non-collision orbit of `V` is periodic. -/
def AllBoundedOrbitsPeriodic (V : ℝ → ℝ) : Prop :=
  ∀ q : ℝ → Plane, IsCentralOrbit V q → IsBoundedOrbit q → IsPeriodicOrbit q

/-- `V` admits a non-circular bounded non-collision orbit (radius takes ≥ 2
values) — the non-degeneracy Bertrand actually classifies. -/
def HasNonCircularBoundedOrbit (V : ℝ → ℝ) : Prop :=
  ∃ q : ℝ → Plane, IsCentralOrbit V q ∧ IsBoundedOrbit q ∧
    ∃ t₁ t₂ : ℝ, ‖q t₁‖ ≠ ‖q t₂‖

/-- A Bertrand potential: Hooke `a ρ² + b` (`a > 0`) or Kepler `-a/ρ + b`
(`a > 0`), for positive radii. -/
def IsBertrandPotential (V : ℝ → ℝ) : Prop :=
  (∃ a b : ℝ, 0 < a ∧ ∀ ρ : ℝ, 0 < ρ → V ρ = a * ρ ^ 2 + b) ∨
  (∃ a b : ℝ, 0 < a ∧ ∀ ρ : ℝ, 0 < ρ → V ρ = -a / ρ + b)

/-- **Bertrand's theorem.** Among central potentials with a non-circular bounded
non-collision orbit, all-bounded-orbits-periodic holds iff `V` is a Hooke or
Kepler potential. -/
@[eval_problem]
theorem bertrand_central_force
    (V : ℝ → ℝ) (hV : ContDiffOn ℝ 2 V (Set.Ioi 0))
    (hne : HasNonCircularBoundedOrbit V) :
    AllBoundedOrbitsPeriodic V ↔ IsBertrandPotential V := by
  sorry

end LeanEval.Dynamics.Bertrand
