import Mathlib
import Submission

open scoped TensorProduct

theorem brauer_splitting_field (G : Type) [Group G] [Fintype G]
    (V : Type) [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]
    (ρ : Representation ℂ G V) :
    ∃ (φ : CyclotomicField (Monoid.exponent G) ℚ →+* ℂ)
      (W : Type) (_ : AddCommGroup W)
      (_ : Module (CyclotomicField (Monoid.exponent G) ℚ) W)
      (σ : Representation (CyclotomicField (Monoid.exponent G) ℚ) G W),
      letI : Algebra (CyclotomicField (Monoid.exponent G) ℚ) ℂ := φ.toAlgebra
      ∃ (f : (ℂ ⊗[CyclotomicField (Monoid.exponent G) ℚ] W) ≃ₗ[ℂ] V),
        ∀ (g : G) (x : ℂ ⊗[CyclotomicField (Monoid.exponent G) ℚ] W),
          f ((σ g).baseChange ℂ x) = ρ g (f x) := by
  exact Submission.brauer_splitting_field G V ρ
