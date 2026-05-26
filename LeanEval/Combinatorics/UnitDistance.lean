import Mathlib

namespace LeanEval
namespace Combinatorics

/-!
# The Erdős unit-distance problem in the plane

For a finite set `P ⊆ ℝ²` write
`ν(P) := #{ {x, y} ⊆ P : ‖x − y‖ = 1 }` for the number of unordered
unit-distance pairs in `P`, and put `ν(n) := max_{|P| = n} ν(P)`.
Erdős's 1946 paper introduced this quantity along with the dual
distinct-distances problem.

This module sets up `unitDist P = ν(P)`. The two theorems live in
companion files:

* [`UnitDistanceUpperBound`](UnitDistanceUpperBound.lean) — the best
  known upper bound, Spencer–Szemerédi–Trotter (1984), `ν(n) = O(n^{4/3})`.

* [`UnitDistanceConjectureFalse`](UnitDistanceConjectureFalse.lean) —
  OpenAI's 2026 refutation of Erdős's conjectured upper bound
  `ν(n) ≤ n^{1 + C / log log n}`.

Neither result is in mathlib; the unit-distance problem is one of the
oldest open problems in combinatorial geometry, with the elementary
incidence bound `O(n^{4/3})` having stood since 1984 with only
constant-factor improvements.
-/

open scoped Classical

/-- The model space `ℝ²` with its Euclidean norm. We use
`EuclideanSpace ℝ (Fin 2)` rather than `ℝ × ℝ` so that `dist x y`
denotes the Euclidean distance `√((x₀ - y₀)² + (x₁ - y₁)²)`, not the
sup-norm distance carried by the product space. -/
abbrev E2 : Type := EuclideanSpace ℝ (Fin 2)

/-- For a finite planar set `P ⊆ ℝ²`, `unitDist P` is the number of
unordered pairs `{x, y} ⊆ P` at Euclidean distance exactly `1`. -/
noncomputable def unitDist (P : Finset E2) : ℕ :=
  (P.offDiag.filter (fun pq : E2 × E2 => dist pq.1 pq.2 = 1)).card / 2

end Combinatorics
end LeanEval
