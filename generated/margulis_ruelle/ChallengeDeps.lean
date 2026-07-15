import Mathlib

namespace LeanEval
namespace Dynamics

/-!
# The Lai-Sang Young entropy–dimension–Lyapunov theorem and relatives

This module contributes three category-(b) eval problems from §103 of the Knill
survey (`sections/103-diffeomorphisms.md`):

* `entropy_dimension_lyapunov` — Lai-Sang Young (1982): for a `C²`-diffeomorphism
  `T` of a compact surface and an ergodic invariant measure `μ`,
  `h_μ(T) = dim(μ) · λ(T,μ) / 2`.
* `pesin_formula` — Pesin (1977): the symplectic specialisation `h_μ = λ₁`.
* `margulis_ruelle` — Margulis (1968) / Ruelle (1978): `h_μ ≤ λ₁⁺ + λ₂⁺`.

The shared trusted helper definitions (`EucPlane`, `dimMeasure`,
`IsMeasurablePartition`, `partitionEntropy`, `iteratedJoin`, `entropyW`,
`kolmogorovSinaiEntropy`, `lyapunovUpperAt`, `lyapunovLowerAt`,
`harmonicMeanLyapunov`) are non-holes. Mathlib has `dimH`, `Ergodic`,
`MeasurePreserving`, `Real.negMulLog`, and `fderiv`, but no Kolmogorov–Sinai
entropy, no Lyapunov exponents / Oseledec theorem, and none of these
theorems. The surface is modelled on `EuclideanSpace ℝ (Fin 2)` with a compact
invariant `K` (chart-level statement, equivalent to the manifold one since all
quantities are `C²`-chart-invariant).
-/

open scoped ENNReal
open MeasureTheory Filter Topology Real

/-- The Euclidean plane, used as the chart codomain for a compact surface. -/
abbrev EucPlane : Type := EuclideanSpace ℝ (Fin 2)

/-- A finite **measurable partition** (mod `μ`-null sets). -/
structure IsMeasurablePartition {M : Type*} [MeasurableSpace M]
    (μ : Measure M) (P : Finset (Set M)) : Prop where
  measurable : ∀ A ∈ P, MeasurableSet A
  cover : μ (⋃ A ∈ P, A)ᶜ = 0
  disjoint : ∀ A ∈ P, ∀ B ∈ P, A ≠ B → μ (A ∩ B) = 0

/-- Shannon entropy `H_μ(P) = -∑ μ(A) log μ(A)` of a finite partition
(`0 log 0 = 0` via `Real.negMulLog`). -/
noncomputable def partitionEntropy {M : Type*} [MeasurableSpace M]
    (μ : Measure M) (P : Finset (Set M)) : ℝ :=
  ∑ A ∈ P, Real.negMulLog (μ A).toReal

/-- The join `∨_{k=0}^{n-1} T^{-k} P` of pullback partitions. -/
noncomputable def iteratedJoin {M : Type*} (T : M → M)
    (P : Finset (Set M)) (n : ℕ) : Finset (Set M) :=
  (Fintype.piFinset (fun _ : Fin n => P)).image
    (fun f : Fin n → Set M => ⋂ k : Fin n, T^[(k : ℕ)] ⁻¹' f k)

/-- The **entropy of `T` w.r.t. a partition `P`**:
`limsup (1/n) H_μ(∨_{k<n} T^{-k} P)`. -/
noncomputable def entropyW {M : Type*} [MeasurableSpace M]
    (μ : Measure M) (T : M → M) (P : Finset (Set M)) : ℝ :=
  Filter.limsup
    (fun n : ℕ => partitionEntropy μ (iteratedJoin T P n) / n) atTop

/-- **Kolmogorov–Sinai entropy** of `(M, T, μ)`: the supremum of `entropyW`
over finite measurable partitions. -/
noncomputable def kolmogorovSinaiEntropy {M : Type*} [MeasurableSpace M]
    (μ : Measure M) (T : M → M) : ℝ :=
  sSup {h | ∃ P : Finset (Set M), IsMeasurablePartition μ P ∧ entropyW μ T P = h}

/-- **Upper Lyapunov exponent** at `x`: growth rate of `‖DT^n_x‖`. -/
noncomputable def lyapunovUpperAt
    (T : EucPlane → EucPlane) (x : EucPlane) : ℝ :=
  Filter.limsup
    (fun n : ℕ => Real.log ‖fderiv ℝ (T^[n]) x‖ / n) atTop

/-- **Lower Lyapunov exponent** at `x`: `-limsup (1/n) log ‖(DT^n_x)⁻¹‖`. -/
noncomputable def lyapunovLowerAt
    (T : EucPlane → EucPlane) (x : EucPlane) : ℝ :=
  -Filter.limsup
    (fun n : ℕ => Real.log ‖(fderiv ℝ (T^[n]) x).inverse‖ / n) atTop



end Dynamics
end LeanEval
