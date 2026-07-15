import Mathlib

namespace LeanEval
namespace Dynamics

/-!
# Rokhlin lemma (Rokhlin 1947; independently Kakutani 1943)

§109 of Knill's *Some Fundamental Theorems in Mathematics*. Every
aperiodic measure-preserving automorphism of a standard Borel
probability space admits, for every height `n` and every `ε > 0`, a
measurable tower base `B` such that `B, T B, …, T^{n−1} B` are pairwise
disjoint and their union has measure at least `1 − ε`.

Mathlib has `MeasurePreserving`, `IsProbabilityMeasure`, periodic-point
infrastructure (`Function.periodicPts`), `Set.PairwiseDisjoint`, and
`StandardBorelSpace`, but no Rokhlin lemma (`grep -ri 'rokhlin'
Mathlib/Dynamics/` finds nothing; the only `tower` hits are
`IsScalarTower`). The Challenge ships four small helper definitions
(`IsAperiodic`, `towerFloor`, `towerUnion`, `IsRokhlinTower`).

The `[StandardBorelSpace Ω]` hypothesis is essential: the
countable-cocountable σ-algebra on `ℝ` with the integer-shift map
`x ↦ x + 1` is aperiodic and measure-preserving (for the 0/1 measure
that sends countable sets to 0 and cocountable sets to 1), but admits
no nontrivial Rokhlin towers — every cocountable base intersects its
own shift, and every countable base has zero-measure tower. The
countable-cocountable σ-algebra has `MeasurableSingletonClass` but is
strictly coarser than the Borel σ-algebra of any Polish topology on
`ℝ`, hence not standard Borel.
-/

open MeasureTheory Set

/-- `T : Ω → Ω` is **aperiodic** w.r.t. `μ` if the set of periodic
points has measure zero, i.e. for a.e. `x`, no positive iterate of `T`
fixes `x`. -/
def IsAperiodic {Ω : Type*} [MeasurableSpace Ω]
    (T : Ω → Ω) (μ : Measure Ω) : Prop :=
  μ (Function.periodicPts T) = 0

/-- The level-`k` floor of a Rokhlin tower of base `B`: the image
`T^[k] '' B`. -/
def towerFloor {Ω : Type*} (T : Ω → Ω) (B : Set Ω) (k : ℕ) : Set Ω :=
  T^[k] '' B

/-- The set-theoretic union of a Rokhlin tower of base `B` and height
`n`. -/
def towerUnion {Ω : Type*} (T : Ω → Ω) (B : Set Ω) (n : ℕ) : Set Ω :=
  ⋃ k ∈ Finset.range n, towerFloor T B k

/-- The base `B` is a **Rokhlin tower of height `n`** for `T` if the
floors `B, T B, …, T^{n−1} B` are measurable and pairwise disjoint. -/
def IsRokhlinTower {Ω : Type*} [MeasurableSpace Ω]
    (T : Ω → Ω) (B : Set Ω) (n : ℕ) : Prop :=
  MeasurableSet B ∧
    (Finset.range n : Set ℕ).PairwiseDisjoint (towerFloor T B)



end Dynamics
end LeanEval
