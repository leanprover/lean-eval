import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory
namespace ConwaySchneebergerFifteenProblem

/-!
# Conway–Schneeberger fifteen theorem

A positive-definite integer-matrix quadratic form `Q : ℤⁿ → ℤ` is
**universal** (represents every positive integer) iff it represents
every integer in `{1, 2, …, 15}`. Conway–Schneeberger 1993; full
published proof Bhargava 2000 (*New Directions in Quadratic Forms*,
Contemp. Math. **272**). §95 in Knill's *Some Fundamental Theorems in
Mathematics*.

Definitions are kept matrix-explicit (rather than going through
mathlib's bundled `QuadraticMap`) because Knill's statement makes the
integer entries of `Q` central — the integer-matrix versus
integer-valued distinction is precisely the difference between the 15
theorem here and Bhargava–Hanke's 290 theorem.
-/

/-- Evaluate a quadratic form `Q(x) = ∑_{i,j} Q_{ij} x_i x_j` given by
the symmetric integer matrix `Q` at an integer vector `x`. -/
def evalQ {n : ℕ} (Q : Matrix (Fin n) (Fin n) ℤ) (x : Fin n → ℤ) : ℤ :=
  ∑ i, ∑ j, Q i j * x i * x j

/-- `Q` is **positive (definite)**: `Q(x) > 0` for every nonzero
integer vector `x`. -/
def IsPositiveQ {n : ℕ} (Q : Matrix (Fin n) (Fin n) ℤ) : Prop :=
  ∀ x : Fin n → ℤ, x ≠ 0 → 0 < evalQ Q x

/-- `Q` **represents** the integer `m` if `m = Q(x)` for some integer
vector `x`. -/
def Represents {n : ℕ} (Q : Matrix (Fin n) (Fin n) ℤ) (m : ℤ) : Prop :=
  ∃ x : Fin n → ℤ, evalQ Q x = m

/-- `Q` is **universal**: every positive integer is represented. -/
def IsUniversal {n : ℕ} (Q : Matrix (Fin n) (Fin n) ℤ) : Prop :=
  ∀ m : ℕ, 0 < m → Represents Q (m : ℤ)

/-- **Conway–Schneeberger fifteen theorem** (Conway–Schneeberger 1993,
proof Bhargava 2000). A positive-definite integer-matrix quadratic form
is universal iff it represents every integer in `{1, 2, …, 15}`.

The forward direction is immediate; the content is the converse — 15 is
the smallest `N` such that representing `{1, …, N}` implies representing
every positive integer. Bhargava's refinement reduces the critical set
to `{1, 2, 3, 5, 6, 7, 10, 14, 15}` (9 elements). -/
@[eval_problem]
theorem conway_schneeberger_fifteen {n : ℕ}
    (Q : Matrix (Fin n) (Fin n) ℤ)
    (_hsymm : Q.IsSymm) (_hpos : IsPositiveQ Q) :
    IsUniversal Q ↔ ∀ k ∈ Finset.Icc (1 : ℤ) 15, Represents Q k := by
  sorry

end ConwaySchneebergerFifteenProblem
end NumberTheory
end LeanEval
