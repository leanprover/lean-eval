import Mathlib
import EvalTools.Markers

/-!
# The classification of root systems

The classification of reduced, crystallographic, irreducible, finite root systems states:
1. there are four infinite families `Aₙ`, `Bₙ`, `Cₙ`, `Dₙ`, and five exceptional systems:
   `E₆`, `E₇`, `E₈`, `F₄`, `G₂` with well-known Cartan matrices (for any choice of base),
2. apart from some low-rank coincidences, all of the root systems `Aₙ, …, G₂` are distinct
   up to isomorphism,
3. every root system is isomorphic to one of the root systems `Aₙ, …, G₂`.

The eval problem `LeanEval.Combinatorics.rootSystem_classification` below asks for a proof
of item 3 from this list. More precisely it asks for a proof that every base for such a
root system has a Cartan matrix from the standard lists. In view of
`RootPairing.Base.equivOfCartanMatrixEq` this does indeed correspond to item 3 above.

## Informal proof:

The proof is classical and appears in many texts on representation theory including those
of Bourbaki, Carter, Fulton & Harris, Humphreys, Steinberg.

-/

namespace LeanEval.Combinatorics

/-- Every reduced, crystallographic, irreducible, finite root system belongs to one of
the four classical families or one of the five exceptional cases. -/
@[eval_problem]
theorem rootSystem_classification
    (ι : Type*) [Finite ι]
    (K : Type*) [Field K] [CharZero K]
    (M : Type*) [AddCommGroup M] [Module K M]
    (N : Type*) [AddCommGroup N] [Module K N]
    (P : RootPairing ι K M N)
    [P.IsReduced] [P.IsCrystallographic] [P.IsIrreducible] [P.IsRootSystem]
    (b : P.Base) :
    (∃ n e, b.cartanMatrix.reindex e e = CartanMatrix.A n) ∨
    (∃ n e, b.cartanMatrix.reindex e e = CartanMatrix.B n) ∨
    (∃ n e, b.cartanMatrix.reindex e e = CartanMatrix.C n) ∨
    (∃ n e, b.cartanMatrix.reindex e e = CartanMatrix.D n) ∨
    (∃ e, b.cartanMatrix.reindex e e = CartanMatrix.E₆) ∨
    (∃ e, b.cartanMatrix.reindex e e = CartanMatrix.E₇) ∨
    (∃ e, b.cartanMatrix.reindex e e = CartanMatrix.E₈) ∨
    (∃ e, b.cartanMatrix.reindex e e = CartanMatrix.F₄) ∨
    (∃ e, b.cartanMatrix.reindex e e = CartanMatrix.G₂) := by
  sorry

end LeanEval.Combinatorics
