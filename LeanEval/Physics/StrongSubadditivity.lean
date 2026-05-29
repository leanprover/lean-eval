import EvalTools.Markers
import Mathlib.Analysis.Matrix.HermitianFunctionalCalculus
import Mathlib.LinearAlgebra.Matrix.PosDef

/-! # Strong additivity of quantum entropy

States that `S(ρ_ABC) + S(ρ_B) ≤ S(ρ_AB) + S(ρ_C)` where S is the von Neumman entropy.

[Wikipedia article](https://en.wikipedia.org/wiki/Strong_subadditivity_of_quantum_entropy) on
the significance of this inequality.

-/

variable {A B C : Type*}
variable [Fintype A] [Fintype B] [Fintype C]
variable [DecidableEq A] [DecidableEq B] [DecidableEq C]
variable [Nonempty A] [Nonempty B] [Nonempty C]

noncomputable section

/-- Partial trace on the left of a matrix -/
def Matrix.traceLeft (M : Matrix (A × B) (A × B) ℂ) : Matrix B B ℂ :=
  Matrix.of fun i j ↦ ∑ k, ∑ l, M (k, i) (l, j)

/-- Partial trace on the right of a matrix -/
def Matrix.traceRight (M : Matrix (A × B) (A × B) ℂ) : Matrix A A ℂ :=
  Matrix.of fun i j ↦ ∑ k, ∑ l, M (i, k) (j, l)

/-- Von Neumann entropy of a quantum state -/
def entropy (M : Matrix A A ℂ) : ℝ :=
  -Complex.re (Matrix.trace (M * cfc Real.log M))

open ComplexOrder

/-- Strong subadditivity of quantum entropy. We relax the common assumption that M is a normalized
 density matrix to the simpler statement that it's PSD, which holds since normalization just produces
 a positive affine transformation on the entropy. -/
@[eval_problem]
theorem StrongSubadditivity (M_ABC : Matrix (A × B × C) (A × B × C) ℂ) (h : M_ABC.PosSemidef) :
    let M_AB : Matrix (A × B) (A × B) ℂ :=
      .traceRight <| M_ABC.reindex (.symm <| .prodAssoc ..) (.symm <| .prodAssoc ..)
    let M_BC : Matrix (B × C) (B × C) ℂ := M_ABC.traceLeft
    let M_B : Matrix B B ℂ := M_BC.traceRight
    entropy M_ABC + entropy M_B ≤ entropy M_AB + entropy M_BC := by
  sorry
