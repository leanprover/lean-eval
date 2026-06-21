import Mathlib
import EvalTools.Markers

namespace LeanEval.RepresentationTheory.FrobeniusDeterminant

/-!
# Frobenius determinant theorem (Dedekind's group determinant)

`frobenius_group_determinant`: the group determinant `Θ(G) = det(A)` of the
group matrix `A_{gh} = x_{gh}` factors into irreducible polynomials, each to the
power of its own total degree, with the factors pairwise non-associated and
their number equal to the number of conjugacy classes of `G`. Trusted helpers
`groupMatrix`, `groupDeterminant` (non-holes). Category-(b) candidate from §171
of the Knill survey.
-/

open MvPolynomial Matrix


/-- The **group matrix** of Dedekind/Frobenius: a `G × G` matrix over the
polynomial ring `ℂ[x_g : g ∈ G]`, with entry `(g, h)` the variable indexed by
the product `g * h`. -/
noncomputable def groupMatrix (G : Type*) [Group G] [Fintype G] [DecidableEq G] :
    Matrix G G (MvPolynomial G ℂ) :=
  fun g h => MvPolynomial.X (g * h)

/-- The **group determinant** `Θ(G) = det(A)`, a polynomial in the variables
`x_g`. -/
noncomputable def groupDeterminant (G : Type*) [Group G] [Fintype G] [DecidableEq G] :
    MvPolynomial G ℂ :=
  (groupMatrix G).det

/-- **Frobenius determinant theorem** (§171). The group determinant factors as
a product of irreducible polynomials, each appearing to the power of its own
(total) degree `d_j = deg p_j`, with the factors pairwise non-associated
(*distinct*) and their number equal to the number of conjugacy classes of `G`.
-/
@[eval_problem]
theorem frobenius_group_determinant
    (G : Type*) [Group G] [Fintype G] [DecidableEq G] :
    ∃ (r : ℕ) (p : Fin r → MvPolynomial G ℂ),
      r = Nat.card (ConjClasses G) ∧
      (∀ j, Irreducible (p j)) ∧
      (∀ i j, i ≠ j → ¬ Associated (p i) (p j)) ∧
      groupDeterminant G = ∏ j, (p j) ^ (p j).totalDegree := by
  sorry

end LeanEval.RepresentationTheory.FrobeniusDeterminant
