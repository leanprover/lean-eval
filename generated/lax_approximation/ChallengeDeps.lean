import Mathlib

namespace LeanEval.Dynamics.LaxApproximation

/-!
# Lax's approximation theorem for toral homeomorphisms

`lax_approximation` (Peter Lax 1971): every volume-preserving homeomorphism of
the `d`-torus (`d ≥ 1`) can be approximated arbitrarily well, in the
`L∞`-metric `δ`, by cyclic cube exchange transformations. The trusted helpers
(`Torus`, `VolumePreservingEquiv`, `deltaDist`, `ToralDynamicalSystem`, `cube`,
`cubeShift`, `IsCyclicCubeExchange`, …) are non-holes. Mathlib has the torus,
measure-preserving maps, and Hall's marriage theorem (the combinatorial
ingredient) but not Lax's theorem, cube exchanges, or the metric `δ`.

Category-(b) candidate from §110 of the Knill survey. "Cyclic" is encoded as a
single full `nᵈ`-cycle (`σ.IsCycle ∧ σ.support = univ`), and `0 < d` is required
(for `d = 0` no non-identity cycle exists).
-/

open MeasureTheory
open scoped ENNReal

instance : Fact (0 < (1 : ℝ)) := ⟨zero_lt_one⟩

/-- The standard `d`-dimensional torus `𝕋^d = (ℝ/ℤ)^d`. -/
abbrev Torus (d : ℕ) : Type := Fin d → AddCircle (1 : ℝ)

/-- The group of measurable, invertible, volume-preserving transformations of
the `d`-torus. -/
structure VolumePreservingEquiv (d : ℕ) where
  toMeasurableEquiv : Torus d ≃ᵐ Torus d
  measurePreserving :
    MeasurePreserving toMeasurableEquiv (volume : Measure (Torus d)) volume


/-- Knill's metric `δ`: the essential supremum of the pointwise torus-distance
`d(T x, S x)`. -/
noncomputable def deltaDist {d : ℕ} (T S : VolumePreservingEquiv d) : ℝ≥0∞ :=
  essSup (fun x => edist (T.toMeasurableEquiv x) (S.toMeasurableEquiv x)) (volume : Measure (Torus d))

/-- A **toral dynamical system**: a volume-preserving homeomorphism of `𝕋^d`. -/
structure ToralDynamicalSystem (d : ℕ) where
  toHomeomorph : Torus d ≃ₜ Torus d
  measurePreserving :
    MeasurePreserving toHomeomorph (volume : Measure (Torus d)) volume

/-- A toral dynamical system as an element of `𝒳`. -/
noncomputable def ToralDynamicalSystem.toVolumePreservingEquiv {d : ℕ}
    (T : ToralDynamicalSystem d) : VolumePreservingEquiv d where
  toMeasurableEquiv := T.toHomeomorph.toMeasurableEquiv
  measurePreserving := T.measurePreserving

/-- The half-open cube `cube n k ⊆ 𝕋^d` for `k : Fin d → Fin n`. -/
def cube (n : ℕ) {d : ℕ} (k : Fin d → Fin n) : Set (Torus d) :=
  { x | ∀ i, ∃ r : ℝ, (k i : ℝ) / n ≤ r ∧ r < ((k i : ℝ) + 1) / n ∧
        x i = ((r : ℝ) : AddCircle (1 : ℝ)) }

/-- The axis-`i` shift carrying cube `k` onto cube `σ k`. -/
noncomputable def cubeShift (n : ℕ) {d : ℕ}
    (σ : Equiv.Perm (Fin d → Fin n))
    (k : Fin d → Fin n) (i : Fin d) : AddCircle (1 : ℝ) :=
  ((((((σ k) i : ℤ) - (k i : ℤ) : ℝ) / (n : ℝ)) : ℝ) : AddCircle (1 : ℝ))

/-- A **cyclic cube exchange**: a single full `nᵈ`-cycle `σ` acting on each
cube `k` by the rigid translation carrying it to cube `σ k`. -/
def IsCyclicCubeExchange {d : ℕ} (T : VolumePreservingEquiv d) (n : ℕ) : Prop :=
  ∃ σ : Equiv.Perm (Fin d → Fin n),
    σ.IsCycle ∧ σ.support = Finset.univ ∧
    ∀ k : Fin d → Fin n, ∀ x ∈ cube n k, ∀ i,
      T.toMeasurableEquiv x i = x i + cubeShift n σ k i



end LeanEval.Dynamics.LaxApproximation
