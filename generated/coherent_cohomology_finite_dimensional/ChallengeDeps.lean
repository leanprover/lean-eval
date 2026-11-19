import Mathlib

/-!
# Finite-dimensionality of coherent cohomology

Author: Brian Nugent.


Brian Nugent's formalization of the statement that a coherent sheaf on a scheme
proper over `ℚ` has finite-dimensional cohomology in every degree (Grothendieck's
coherent finiteness theorem). Posted to the leanprover Zulip:
<https://leanprover.zulipchat.com/#narrow/channel/583341-Model-comparisons-for-Lean/topic/LeanEval/near/603798763>.

`M.sheaf.H n` is the degree-`n` sheaf cohomology of the underlying sheaf of
abelian groups of the `𝒪_X`-module `M`, which for a quasi-coherent sheaf computes
coherent cohomology. Since `X` is a scheme over `ℚ`, this cohomology is a
`ℚ`-vector space, but Mathlib only exposes its underlying abelian group; tensoring
with `ℚ` over `ℤ` recovers the `ℚ`-vector space (the natural map `V → ℚ ⊗[ℤ] V` is
an isomorphism for any `ℚ`-vector space `V`), so `Module.Finite ℚ (ℚ ⊗[ℤ] M.sheaf.H n)`
faithfully expresses "`Hⁿ(X, M)` is finite-dimensional over `ℚ`".
-/

open CategoryTheory AlgebraicGeometry TensorProduct

namespace LeanEval
namespace AlgebraicGeometry

-- `X` and `M` are implicit at the variable level so that the eval pipeline's
-- generated `Solution.lean` can delegate to `Submission` without threading `X`
-- and `M` through every call: they are inferred from `f` and the conclusion.
variable {X : Scheme.{0}} {M : X.Modules}

/-- The category of abelian sheaves on `X` has enough injectives, hence
`Ext`-groups, hence the sheaf cohomology `Sheaf.H` used below is available. -/
instance instHasExtOpens :
    HasExt.{0} (CategoryTheory.Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{0}) :=
  hasExt_of_enoughInjectives _

/-- The underlying sheaf of abelian groups of an `𝒪_X`-module `M`. -/
noncomputable abbrev _root_.AlgebraicGeometry.Scheme.Modules.sheaf :
    TopCat.Sheaf AddCommGrpCat.{0} X :=
  (SheafOfModules.toSheaf X.ringCatSheaf).obj M



end AlgebraicGeometry
end LeanEval
