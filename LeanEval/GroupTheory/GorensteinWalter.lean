import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

open scoped MatrixGroups

/-!
# Gorenstein–Walter theorem (dihedral Sylow 2-subgroup)

Let `G` be a finite nonabelian simple group whose Sylow 2-subgroups are
dihedral. Then `G` is isomorphic to either:

* `PSL₂(q)` for some odd prime power `q ≥ 5`, or
* the alternating group `A₇`.

D. Gorenstein and J. H. Walter, "The characterization of finite groups
with dihedral Sylow 2-subgroups", J. Algebra 2 (1965); a famously long
paper, the first major application of the Bender method in CFSG.

The conclusion is captured in two clauses:
* `Nonempty (G ≃* alternatingGroup (Fin 7))`, or
* an existential over a prime `p`, an exponent `k`, and an isomorphism
  `G ≃* PSL(2, GaloisField p k)` with `p` odd and `p^k ≥ 5`.

Since `GaloisField p k` requires the typeclass `Fact p.Prime`, we
existentially bind a `Fact p.Prime` term and use it (via `letI`) to
reach the `GaloisField`.
-/

/-- **Gorenstein–Walter theorem.** -/
@[eval_problem]
theorem gorenstein_walter
    (G : Type) [Group G] [Finite G] [IsSimpleGroup G]
    (hnonab : ∃ a b : G, a * b ≠ b * a)
    (P : Sylow 2 G)
    (_hdih : ∃ n : ℕ, Nonempty ((P : Subgroup G) ≃* DihedralGroup n)) :
    Nonempty (G ≃* alternatingGroup (Fin 7)) ∨
    ∃ p k : ℕ, ∃ _hp : Fact p.Prime, Odd p ∧ 5 ≤ p ^ k ∧
      Nonempty (G ≃* PSL(2, GaloisField p k)) := by
  sorry

end GroupTheory
end LeanEval
