import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace RepresentationTheory

open scoped TensorProduct

/-!
Existential tensor-square problem for the Mathieu group `M₂₃`.

We assert the existence of a finite group `G` of order `|M₂₃| = 10 200 960`,
together with a `22`-dimensional irreducible complex representation `V`,
such that the tensor square `V ⊗ V` (with the diagonal `G`-action) decomposes
into exactly `4` isotypic components.

Mathematical witness. Take `G = M₂₃` acting on the deleted permutation
representation of its 4-transitive action on 23 points. Let `V` be the
corresponding 22-dimensional irreducible. Then
* `Sym² V` is the permutation representation on the `(23 choose 2) = 253`
  unordered pairs, decomposing as `1 ⊕ V ⊕ W` where `W` is a 230-dimensional
  irreducible.
* `Λ² V` is irreducible of dimension `231` (one of the three 231-dim irreps).

So `V ⊗ V = 1 ⊕ V ⊕ W ⊕ Λ²V` has exactly four pairwise non-isomorphic
irreducible summands.

Mathlib does not yet construct `M₂₃` directly, so any solution must build the
group from scratch (e.g. as a subgroup of `S₂₃` via generators of the Steiner
system `S(4,7,23)`, or from the automorphism group of an extended ternary Golay
code, etc.). The statement does not pin down `M₂₃` uniquely (other groups of
the same order with a 22-dim irrep of the right tensor-square structure would
also satisfy the existential), but while this does not technically require
constructing `M₂₃` and studying its representation theory, we suspect that in
practice it does.

The `G`-action is carried by a `Representation ℂ G V`. The diagonal action on
the tensor square is `ρ.tprod ρ` (`(ρ.tprod ρ) g = TensorProduct.map (ρ g) (ρ g)`),
which is pinned directly rather than relying on a constraint typeclass
resolution would not respect. (An earlier version bound a bare
`Module (MonoidAlgebra ℂ G) (V ⊗[ℂ] V)` witness and tried to pin it to the
diagonal action via the equation `g • (v ⊗ w) = (g • v) ⊗ (g • w)`; but the `•`
on `V ⊗[ℂ] V` resolves to `TensorProduct.leftModule`, the left-factor action,
not the bound witness, so that conjunct forces a trivial action and the whole
statement is vacuously false.)

The tensor-square module instance is supplied explicitly via `Module.compHom`
from `ρ.tprod ρ` on the carrier `V ⊗[ℂ] V`. This avoids both the
`TensorProduct.leftModule` ambiguity above and the `AddCommMonoid`/`AddCommGroup`
diamond in `Representation.asModule` (which would otherwise force a
`set_option backward.isDefEq.respectTransparency false`, a modifier the workspace
extractor does not carry onto the generated `Challenge.lean`).
-/

@[eval_problem]
theorem m23_irrep_tensor_square_decomp :
    ∃ (G : Type) (_ : Group G) (_ : Fintype G),
      Fintype.card G = 10200960 ∧
      ∃ (V : Type) (_ : AddCommGroup V) (_ : Module ℂ V) (ρ : Representation ℂ G V),
        Module.finrank ℂ V = 22 ∧
        ρ.IsIrreducible ∧
        (@isotypicComponents (MonoidAlgebra ℂ G) (V ⊗[ℂ] V) _ _
          (Module.compHom (V ⊗[ℂ] V)
            (Representation.asAlgebraHom (ρ.tprod ρ)).toRingHom)).ncard = 4 := by
  sorry

end RepresentationTheory
end LeanEval
