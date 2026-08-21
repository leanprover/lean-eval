/-
Copyright (c) 2026 Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Katerina Hristova
-/

import Mathlib.Algebra.Module.ZLattice.Basic
import EvalTools.Markers

/-!
# Main Statement from A reverse Minkowski theorem

We formalise the statement of the main result from O. Regev, N. Stephens-Davidowitz,
`A reverse Minkowski theorem`, Annals of Math, 199 (1) 2024.
-/

set_option autoImplicit false

namespace ReverseMinkowski

open Module Real Matrix

variable {n : ℕ}

local notation "ℝⁿ" => EuclideanSpace ℝ (Fin n)

/-- The Gaussian mass `ρ_s (ℒ)` is the function defined after the statement of Theorem 1.2. -/
noncomputable def ρ (s : ℝ) (ℒ : Submodule ℤ ℝⁿ) : ℝ := ∑' y : ℒ, rexp (- π * ‖y‖ ^ 2 / s ^ 2)

/-- For `ℤ`-lattice of rank `m`, define an `n × m` matrix whose columns are basis elements of `ℒ`.
-/
noncomputable def B (ℒ : Submodule ℤ ℝⁿ) [DiscreteTopology ℒ] :
    Matrix (Fin n) (Fin (finrank ℤ ℒ)) ℝ := (of fun i ↦ (finBasis ℤ ℒ) i).transpose

/-- The determinant of a `ℤ`-lattice of arbitrary rank is the square root of the determinant of
`B^T * B`, where `B`is the basis matrix defined above. -/
noncomputable def determinant (ℒ : Submodule ℤ ℝⁿ) [DiscreteTopology ℒ] : ℝ :=
  √ ((B ℒ).transpose * B ℒ).det

/--
Statement of Theorem 1.2 (Reverse Minkowski Theorem):

For any lattice `ℒ ⊆ ℝ^n` with determinant greater or equal to `1` for all sublattices `ℒ'` of `ℒ`,
`ρ_{1/t}(ℒ) ≤ 3/2` where `t = 10 (log n + 2)`.
-/
@[eval_problem]
theorem theorem_1_2 (ℒ : Submodule ℤ ℝⁿ) [DiscreteTopology ℒ] (hℒ : IsZLattice ℝ ℒ)
    (h : ∀ ℒ' (_hℒℒ' : ℒ' ≤ ℒ) [DiscreteTopology ℒ'], determinant ℒ' ≥ 1) :
    let t : ℝ := 10 * (log n + 2)
    ρ (1 / t) ℒ ≤ 3 / 2 := by
  sorry

end ReverseMinkowski
