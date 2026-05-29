import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Algebra

/-!
# Solvable extensions ↔ solvable groups

For a characteristic-zero field `F` and a nonzero polynomial `p ∈ F[X]`,
every root of `p` in `AlgebraicClosure F` lies in
`solvableByRad F (AlgebraicClosure F)` if and only if its Galois group
`p.Gal` is solvable. §58 of Knill's *Some Fundamental Theorems in
Mathematics* (additional statement). The left-hand side quantifies over
the actual roots of `p`, so the statement does not depend on choosing a
sufficiently large ambient extension.

Mathlib has the `→` direction in `Mathlib/FieldTheory/AbelRuffini.lean`
via `isSolvable_gal_of_irreducible` / `isSolvable_gal_minpoly`: a root
in `solvableByRad F E` has solvable minimal-polynomial Galois group.
The header docstring of that file states it proves "one direction" of
Abel–Ruffini. The `←` direction is the Kummer-theory content (solvable
Galois group implies roots in `solvableByRad`) and is the missing piece.

This is the polynomial-level statement, not the irreducible/minpoly
form already in mathlib.
-/

open Polynomial IntermediateField

/-- **Solvable extensions ↔ solvable groups.** For a field `F` of
characteristic zero and a nonzero `p : F[X]`, every root of `p` in
`AlgebraicClosure F` lies in `solvableByRad F (AlgebraicClosure F)`
iff `p.Gal` is solvable. -/
@[eval_problem]
theorem solvable_iff_solvableByRad (F : Type*) [Field F] [CharZero F]
    (p : F[X]) (_hp : p ≠ 0) :
    (∀ x : AlgebraicClosure F, aeval x p = 0 →
        x ∈ solvableByRad F (AlgebraicClosure F)) ↔ IsSolvable p.Gal := by
  sorry

end Algebra
end LeanEval
