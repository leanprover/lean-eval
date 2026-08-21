import Mathlib.Algebra.Lie.SerreConstruction
import Mathlib.Algebra.Lie.TensorProduct
import Mathlib.Algebra.Lie.UniversalEnveloping
import Mathlib.Algebra.Lie.Semisimple.Defs
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.RingTheory.SimpleModule.Isotypic
import Lake.Toml
import Lake.Util.Message
import Lean

namespace LeanEval
namespace RepresentationTheory

open scoped TensorProduct

/-!
Existential tensor-square problems for irreducible representations of g₂ and e₈
defined by the Serre construction.

For each of the exceptional Lie algebras g₂ and e₈ over ℂ, we ask only for the
existence of an irreducible representation `V` of a specified dimension whose
tensor square has a specified number of isotypic components (counted as
distinct isomorphism classes of irreducible Lie submodules):

* g₂: dim V = 64,     `V ⊗ V` has 14 isotypic components
* e₈: dim V = 779247, `V ⊗ V` has 40 isotypic components

In the intended solution, one exhibits `V` as the highest-weight
representation `ω₁ + ω_n` (the sum of the first and last fundamental weights,
in Bourbaki labelling):

* g₂: highest weight `ω₁ + ω₂`
* e₈: highest weight `ω₁ + ω₈`

Mathlib does not yet package the highest-weight classification needed to state
those descriptions directly, so they serve here as mathematical guidance for
constructing a witness rather than as part of the formal theorem statement.

Mathlib's `isotypicComponents` is defined for modules over a ring. To use it on
a Lie module `M`, we transport the action through the universal enveloping
algebra: a `LieModule R L M` extends to a
`Module (UniversalEnvelopingAlgebra R L) M` via the universal property.
-/

noncomputable instance lieModuleToEnvelopingModule
    (R L M : Type*) [CommRing R] [LieRing L] [LieAlgebra R L]
    [AddCommGroup M] [Module R M] [LieRingModule L M] [LieModule R L M] :
    Module (UniversalEnvelopingAlgebra R L) M :=
  Module.compHom M
    (UniversalEnvelopingAlgebra.lift R (LieModule.toEnd R L M)).toRingHom





end RepresentationTheory
end LeanEval
