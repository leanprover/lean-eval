import Mathlib.Algebra.Module.ZLattice.Basic
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statements from A counterexample to the periodic tiling conjecture

We formalise the statements of the main results from R. Greenfeld and T. Tao,
`A counterexample to the periodic tiling conjecture`, Annals of Math, 200 (1) 2024.
-/

set_option autoImplicit false

namespace PeriodicTilingConjecture

open Filter Bornology MeasureTheory

open scoped Pointwise

variable {G : Type*} [AddCommGroup G]

/-- Given an abelian group `G`, we say that `F ⊆ G` is a tiling of `G` with tiling set `A ⊆ G` if
the translates of `F` by elements `a ∈ A` form a partition of `G`. In other words the map
`A × F → G` defined by `fun (a,f) ↦ a + f` is a bijection. -/
abbrev IsTiling (F A : Set G) : Prop := AddSubgroup.IsComplement A F

/-- We say that a tiling set `A ⊆ G` is periodic if there exists a finite index subgroup `H` of
`G` such that `A` can be written as the union of finitely many cosets of `H`. -/
def IsPeriodicTilingSet (A : Set G) : Prop :=
  ∃ H : AddSubgroup G, H.FiniteIndex ∧ ∃ s : Finset G, A = s + H

/-- Given an abelian group `G`, and a set `F ⊆ G` we say that `F` forms an aperiodic tiling equation
if there exists `A ⊆ G` such that `F` tiles `G` with tiling set `A` but all such `A` are not
periodic. -/
structure IsAperiodicTilingEquation (F : Set G) where
  solvable : ∃ A, IsTiling F A
  aperiodic : ∀ A, IsTiling F A → ¬ IsPeriodicTilingSet A





variable {d : ℕ}

/-- We say that `σ ⊆ ℝᵈ` is a continuous tiling of `ℝᵈ` with tiling set `Λ` if the translates of
`σ` by elements `v ∈ Λ` partition `ℝᵈ` up to null sets. In other words for almost all `x ∈ ℝᵈ`,
there exists a unique `v ∈ Λ` such that `x ∈ (v + σ)`. -/
def IsContinuousTiling (σ Λ : Set (Fin d → ℝ)) : Prop := ∀ᵐ x, ∃! v ∈ Λ, x ∈ (v +ᵥ σ)

/-- We say that a (continuous) tiling set `Λ ⊆ ℝᵈ` is periodic if there exists a lattice `L`
of `ℝᵈ` such that `Λ` can be written as the union of finitely many cosets of `L`. -/
def IsPeriodicContinuousTilingSet (Λ : Set (Fin d → ℝ)) : Prop :=
    ∃ (L : Submodule ℤ (Fin d → ℝ)) (_ : DiscreteTopology L) (_ : IsZLattice ℝ L),
      ∃ s : Finset (Fin d → ℝ), Λ = s + L

/-- We say that a set `σ ⊆ ℝᵈ` forms an aperiodic continuous tiling equation if there exists
`Λ ⊆ ℝᵈ` such that `σ` (continuously) tiles `ℝᵈ` with tiling set `Λ` but all such `Λ` are not
periodic. -/
structure IsAperiodicContinuousTilingEquation (σ : Set (Fin d → ℝ)) where
  solvable : ∃ Λ, IsContinuousTiling σ Λ
  aperiodic : ∀ Λ, IsContinuousTiling σ Λ → ¬ IsPeriodicContinuousTilingSet Λ



end PeriodicTilingConjecture
