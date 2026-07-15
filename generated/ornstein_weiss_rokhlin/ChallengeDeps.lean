import Mathlib

namespace LeanEval
namespace Dynamics

/-!
# Ornstein–Weiss `ℤᵈ` Rokhlin lemma (Ornstein–Weiss, 1987)

§109 of Knill's *Some Fundamental Theorems in Mathematics* (additional
statement). The multidimensional Rokhlin lemma: for every free
measure-preserving `ℤᵈ`-action `T` on a standard Borel probability
space, every box size `N ≥ 1`, and every `ε > 0`, there is a measurable
base `B` such that the translates `T v '' B` for `v ∈ [0, N)ᵈ` are
pairwise disjoint and their union has measure at least `1 − ε`.

Mathlib has `MeasurePreserving`, `IsProbabilityMeasure`,
`Set.PairwiseDisjoint`, `Fintype.piFinset`, `Finset.Ico`, and
`StandardBorelSpace`, but **no Ornstein–Weiss lemma**, no free
measure-preserving `ℤᵈ`-actions, no multidimensional Rokhlin towers.
The Challenge ships two small helper definitions (`IsFreeAction` and
`boxShape`).

Three hypotheses beyond the classical Rokhlin lemma:

* `1 ≤ d` rules out the degenerate `d = 0` case.
* The identity axiom `T 0 = id` is imposed explicitly; the homomorphism
  axiom alone only forces `T 0` to be idempotent. Together with the
  homomorphism axiom this also gives bijectivity of each `T v` via
  `T (-v) ∘ T v = T 0 = id`.
* `[StandardBorelSpace Ω]` rules out the countable-cocountable
  σ-algebra defect (see the §109 Rokhlin lemma PR for the
  one-dimensional version of this counterexample).
-/

open MeasureTheory Set

/-- A `ℤᵈ`-action by measure-preserving maps is **free** (in the
Ornstein–Weiss sense) if, for every nonzero translation `v`, the set
of points fixed by `T v` has measure zero. -/
def IsFreeAction {Ω : Type*} [MeasurableSpace Ω] {d : ℕ}
    (μ : Measure Ω) (T : (Fin d → ℤ) → Ω → Ω) : Prop :=
  ∀ v : Fin d → ℤ, v ≠ 0 → μ {x | T v x = x} = 0

/-- The integer box `[0, N)ᵈ` as a `Finset` of `ℤᵈ` translations. -/
noncomputable def boxShape (d N : ℕ) : Finset (Fin d → ℤ) :=
  Fintype.piFinset (fun _ : Fin d => Finset.Ico (0 : ℤ) (N : ℤ))



end Dynamics
end LeanEval
