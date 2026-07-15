import Mathlib

/-! # Strong subadditivity of quantum entropy

States that `S(ρ_ABC) + S(ρ_B) ≤ S(ρ_AB) + S(ρ_BC)` where S is the von Neumann entropy.

[Wikipedia article](https://en.wikipedia.org/wiki/Strong_subadditivity_of_quantum_entropy) on
the significance of this inequality.

-/

namespace LeanEval
namespace Physics

variable {A B C : Type*}
variable [Fintype A] [Fintype B] [Fintype C]
variable [DecidableEq A] [DecidableEq B] [DecidableEq C]
variable [Nonempty A] [Nonempty B] [Nonempty C]

noncomputable section

/-- Partial trace on the left of a matrix -/
def _root_.Matrix.traceLeft (M : Matrix (A × B) (A × C) ℂ) : Matrix B C ℂ :=
  Matrix.of fun i j ↦ ∑ k, M (k, i) (k, j)

/-- Partial trace on the right of a matrix -/
def _root_.Matrix.traceRight (M : Matrix (A × B) (C × B) ℂ) : Matrix A C ℂ :=
  Matrix.of fun i j ↦ ∑ k, M (i, k) (j, k)

/-- Von Neumann entropy of a quantum state -/
def entropy (M : Matrix A A ℂ) : ℝ :=
  -Complex.re (Matrix.trace (M * cfc Real.log M))

open ComplexOrder



end

end Physics
end LeanEval
