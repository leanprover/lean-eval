import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ConvexGeometry

/-!
# Linear programming: maximum principle and vertex optimality

§101 of Oliver Knill's *Some Fundamental Theorems in Mathematics*.

* **Maximum principle** (main): a local maximiser of a linear program's
  objective on the feasible region is automatically a global maximiser, and
  whenever the objective is non-constant (`c ≠ 0`) the maximiser lies on the
  topological frontier of the feasible region.
* **Vertex optimality** (additional, the existence content of Dantzig's simplex
  algorithm): every linear program with a nonempty bounded feasible region
  attains its optimum at an extreme point (vertex) of that region.

The program is the standard inequality form `maximise c · x` subject to
`A x ≤ b` and `0 ≤ x`. mathlib has the convex-geometry primitives used here
(`IsLocalMaxOn`, `IsMaxOn`, `frontier`, `Set.extremePoints`, Krein–Milman) but
neither the LP maximum principle nor the existence of an optimal vertex as named
results.
-/

open Matrix

/-- A **linear program** in standard inequality form on `ℝ^m` with `n`
constraints: maximise `c · x` subject to `A x ≤ b` and `0 ≤ x`. -/
structure LinearProgram (m n : ℕ) where
  /-- Coefficient vector of the objective `c · x`. -/
  c : Fin m → ℝ
  /-- Right-hand side of the inequality constraints `A x ≤ b`. -/
  b : Fin n → ℝ
  /-- Constraint matrix. -/
  A : Matrix (Fin n) (Fin m) ℝ

namespace LinearProgram

variable {m n : ℕ}

/-- The **feasible region** of `lp`: the vectors `x ∈ ℝ^m` with `A x ≤ b` and
`0 ≤ x`, a convex polyhedron in `ℝ^m`. -/
def feasible (lp : LinearProgram m n) : Set (Fin m → ℝ) :=
  {x | lp.A *ᵥ x ≤ lp.b ∧ 0 ≤ x}

/-- The **objective** `f(x) = c · x`. -/
def objective (lp : LinearProgram m n) (x : Fin m → ℝ) : ℝ :=
  lp.c ⬝ᵥ x

end LinearProgram

/-- **Maximum principle for linear programming** (§101). A local maximiser of
the LP objective on the feasible region is automatically a global maximiser; and
whenever the objective is non-constant (`c ≠ 0`), the maximiser lies on the
topological frontier of the feasible region. -/
@[eval_problem]
theorem lp_maximum_principle {m n : ℕ} (lp : LinearProgram m n)
    (x : Fin m → ℝ) (_hx : x ∈ lp.feasible)
    (_hlocal : IsLocalMaxOn lp.objective lp.feasible x) :
    IsMaxOn lp.objective lp.feasible x ∧
      (lp.c ≠ 0 → x ∈ frontier lp.feasible) := by
  sorry

/-- **Vertex optimality** (§101; the existence content of Dantzig's 1947 simplex
algorithm). Every linear program with a nonempty bounded feasible region admits a
global maximiser that is an extreme point (vertex) of the feasible region. -/
@[eval_problem]
theorem simplex_algorithm {m n : ℕ} (lp : LinearProgram m n)
    (_hfeas : lp.feasible.Nonempty) (_hbdd : Bornology.IsBounded lp.feasible) :
    ∃ x ∈ lp.feasible, IsMaxOn lp.objective lp.feasible x ∧
      x ∈ Set.extremePoints ℝ lp.feasible := by
  sorry

end ConvexGeometry
end LeanEval
