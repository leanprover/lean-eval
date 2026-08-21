import ChallengeDeps

/-
Copyright (c) 2026 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Algebra.Module.ZLattice.Basic
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







/--
Statement of Theorem 1.4 (Counterexample to Conjecture 1.2, I):

There exists a finite abelian group `G₀` and a finite non-empty `F ⊆ ℤ² × G₀` such that
`F` forms an aperiodic tiling equation.
-/
theorem theorem_1_4 : ∃ (G₀ : Type) (_ : AddCommGroup G₀) (_ : Finite G₀),
    ∃ F : Set (ℤ × ℤ × G₀), F.Finite ∧ F.Nonempty ∧ IsAperiodicTilingEquation F := by
  sorry

/--
Statement of Corollary 1.6 (Counterexample to Conjecture 1.2, II):

For all sufficiently large `d`, there exists a finite non-empty `F ⊆ ℤᵈ` such that
`F` forms an aperiodic tiling equation.
-/
theorem corollary_1_6 : ∀ᶠ d in atTop, ∃ (F : Set (Fin d → ℤ)),
    F.Finite ∧ F.Nonempty ∧ IsAperiodicTilingEquation F := by
  sorry

variable {d : ℕ}







/--
Statement of Corollary 1.7 (Counterexample to Conjecture 1.3):

For all sufficiently large `d`, there exists a bounded measurable set `σ ⊆ ℝᵈ` of positive
measure such that `σ` forms an aperiodic continuous tiling equation.
-/
theorem corollary_1_7 : ∀ᶠ d in atTop, ∃ σ : Set (Fin d → ℝ), IsBounded σ ∧ MeasurableSet σ ∧
    0 < volume σ ∧ IsAperiodicContinuousTilingEquation σ := by
  sorry

end PeriodicTilingConjecture
