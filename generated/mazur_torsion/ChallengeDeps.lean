import Mathlib

namespace LeanEval.NumberTheory.MazurTorsion

/-!
# Mazur's torsion theorem

`mazur_torsion` (Mazur 1977): the torsion subgroup of `E(ℚ)` for an elliptic
curve over `ℚ` is one of the fifteen groups `ℤ/n` (`n ∈ {1,…,10,12}`) or
`ℤ/2 × ℤ/2m` (`m ∈ {1,2,3,4}`). Trusted helper `IsInMazurClass` (non-hole).
Mathlib has Weierstrass curves and their point groups but not Mazur's theorem
(which rests on the geometry of the modular curves `X₁(N)`).
Category-(b) candidate from §139 of the Knill survey.
-/

open scoped WeierstrassCurve

/-- The **Mazur class**: isomorphic to `ℤ/n` (`n ∈ {1,…,10,12}`) or
`ℤ/2 × ℤ/2m` (`m ∈ {1,2,3,4}`). -/
def IsInMazurClass (T : Type*) [AddCommGroup T] : Prop :=
  (∃ n ∈ ({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12} : Finset ℕ),
      Nonempty (T ≃+ ZMod n)) ∨
  (∃ m ∈ ({2, 4, 6, 8} : Finset ℕ),
      Nonempty (T ≃+ (ZMod 2 × ZMod m)))



end LeanEval.NumberTheory.MazurTorsion
