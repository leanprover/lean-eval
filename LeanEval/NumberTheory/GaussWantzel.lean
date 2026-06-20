import Mathlib
import EvalTools.Markers

namespace LeanEval.NumberTheory.GaussWantzel

/-!
# Gauss-Wantzel constructible polygon theorem

`gauss_wantzel_constructible_polygon`: a regular `n`-gon is
straightedge-and-compass constructible exactly when `n` is a Gauss-Wantzel
integer. Constructibility is encoded by `IsConstructible`, the smallest
subfield of `ℝ` closed under square roots, applied to `cos (2π/n)`; the
arithmetic side `GaussWantzelNumber` requires every odd prime factor to be a
distinct Fermat prime. Mathlib has the algebraic ingredients but no
constructibility theory and no Gauss-Wantzel theorem. Category-(b) candidate
from §174 of the Knill survey.
-/

/-- The real values constructible from rational data by straightedge and
compass: the smallest subfield of `ℝ` closed under square roots. -/
inductive IsConstructible : ℝ → Prop
  | base (q : ℚ) : IsConstructible (q : ℝ)
  | add {x y : ℝ} : IsConstructible x → IsConstructible y → IsConstructible (x + y)
  | neg {x : ℝ} : IsConstructible x → IsConstructible (-x)
  | mul {x y : ℝ} : IsConstructible x → IsConstructible y → IsConstructible (x * y)
  | inv {x : ℝ} : IsConstructible x → IsConstructible x⁻¹
  | sqrt {x : ℝ} : IsConstructible x → IsConstructible (Real.sqrt x)

/-- Fermat primes, in the form appearing in the Gauss-Wantzel criterion. -/
def FermatPrime (p : ℕ) : Prop :=
  p.Prime ∧ ∃ m : ℕ, p = 2 ^ (2 ^ m) + 1

/-- The number-theoretic side of the Gauss-Wantzel regular-polygon theorem:
only a power of two may occur with repeated exponent; every odd prime factor
must be a distinct Fermat prime. -/
def GaussWantzelNumber (n : ℕ) : Prop :=
  0 < n ∧
    ∀ p : ℕ, p.Prime → p ∣ n →
      (p = 2 ∨ FermatPrime p) ∧ (p ≠ 2 → ¬ p ^ 2 ∣ n)

/-- **Gauss-Wantzel constructible polygon theorem** (§174): a regular `n`-gon
is straightedge-and-compass constructible exactly for the Gauss-Wantzel
integers. -/
@[eval_problem]
theorem gauss_wantzel_constructible_polygon (n : ℕ) (hn : 3 ≤ n) :
    IsConstructible (Real.cos (2 * Real.pi / n)) ↔ GaussWantzelNumber n := by
  sorry

end LeanEval.NumberTheory.GaussWantzel
