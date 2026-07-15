import Mathlib
import EvalTools.Markers

namespace LeanEval.Topology.Hurewicz

/-!
# Hurewicz theorem (degree 1): H₁ is the abelianization of π₁

`hurewicz_h1_abelianization`: for a path-connected space, the first integral
singular homology group is the abelianization of the fundamental group. Trusted
helper `IntegralHomology` (non-hole). Path-connectedness is essential. Mathlib
has singular homology and the fundamental group but not the degree-1 Hurewicz
isomorphism.
Category-(b) candidate from §153 of the Knill survey.
-/

open CategoryTheory AlgebraicTopology

/-- Integral singular homology in degree `n`, as an additive group. -/
noncomputable abbrev IntegralHomology (n : ℕ) (X : Type) [TopologicalSpace X] : AddCommGrpCat :=
  ((singularHomologyFunctor AddCommGrpCat n).obj (AddCommGrpCat.of ℤ)).obj (TopCat.of X)

/-- **Hurewicz (n = 1).** For a path-connected space `X`, `H₁(X;ℤ)` is the
abelianization of `π₁(X, x)`. -/
@[eval_problem]
theorem hurewicz_h1_abelianization
    (X : Type) [TopologicalSpace X] [PathConnectedSpace X] (x : X) :
    Nonempty (Additive (Abelianization (FundamentalGroup X x)) ≃+
      (IntegralHomology 1 X : Type)) := by
  sorry

end LeanEval.Topology.Hurewicz
