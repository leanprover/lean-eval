import Mathlib.Algebra.Category.Grp.Abelian
import Mathlib.AlgebraicTopology.SingularHomology.Basic

namespace LeanEval.Topology

open AlgebraicTopology

/-!
First singular homology group of the Hawaiian earring.

Theorem 3.1 of K. Eda and K. Kawamura's paper "The singular homology of the Hawaiian earring"
computes the first singular homology group of the Hawaiian earring.
This is isomorphic to the version given below using the isomorphism given in S. Balcerzyk
"On factor groups of some subgroups of a complete direct sum of infinite cyclic groups".
-/

/-- The Hawaiian earring as a subset of `ℝ²`. -/
def HawaiianEarring : Set (ℝ × ℝ) :=
  ⋃ n : ℕ, {p | (p.1 - 1 / (n + 1 : ℝ)) ^ 2 + p.2 ^ 2 = (1 / (n + 1 : ℝ)) ^ 2}

/-- The direct sum `⊕ i : ℕ, ℤ` embedded in the product `∏ i : ℕ, ℤ`. -/
noncomputable abbrev directSum : AddSubgroup (ℕ → ℤ) :=
  (Finsupp.coeFnAddHom (ι := ℕ) (M := ℤ)).range

/-- The first singular homology group of the Hawaiian earring is isomorphic to
`(∏ i : ℕ, ℤ) × (∏ i : ℕ, ℤ / ⊕ i : ℕ, ℤ)` -/
@[eval_problem]
theorem hawaiian_earring_first_singularHomology_isomorphism :
  Nonempty ((singularHomologyFunctor Ab 1 |>.obj (.of ℤ) |>.obj <| .of HawaiianEarring) ≃+
    (ℕ → ℤ) × ((ℕ → ℤ) ⧸ directSum)) := by
  sorry

end LeanEval.Topology
