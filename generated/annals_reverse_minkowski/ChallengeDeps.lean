import Mathlib.Algebra.Module.ZLattice.Basic
import Lake.Toml
import Lake.Util.Message
import Lean

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



end ReverseMinkowski
