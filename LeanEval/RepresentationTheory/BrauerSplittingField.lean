import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace RepresentationTheory

open scoped TensorProduct

/-!
Brauer's splitting field theorem.

For a finite group `G` of exponent `n`, every finite-dimensional complex
representation of `G` descends to `ℚ(ζₙ)`. Concretely: there is a ring
embedding `φ : CyclotomicField n ℚ →+* ℂ`, a `ℚ(ζₙ)`-representation
`(W, σ)` of `G`, and a `ℂ`-linear, `G`-equivariant isomorphism
`ℂ ⊗[ℚ(ζₙ)] W ≃ V`, where ℂ is regarded as a `ℚ(ζₙ)`-algebra via `φ`.

Brauer (1945) proved this using his induction theorem.

The weaker "character values lie in `φ.range`" statement
(`brauer_character_in_cyclotomic`) is a corollary, and is in fact
elementary: `ρ g ^ n = 1` makes `ρ g` diagonalisable with `n`-th-root-of-
unity eigenvalues, so its trace is already a sum of `n`-th roots of unity.
The descent statement here is the deep content (Schur index 1 over
`ℚ(ζₙ)` for every irreducible complex representation of `G`).
-/

@[eval_problem]
theorem brauer_splitting_field
    (G : Type) [Group G] [Fintype G]
    (V : Type) [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]
    (ρ : Representation ℂ G V) :
    ∃ (φ : CyclotomicField (Monoid.exponent G) ℚ →+* ℂ)
      (W : Type) (_ : AddCommGroup W)
      (_ : Module (CyclotomicField (Monoid.exponent G) ℚ) W)
      (_ : FiniteDimensional (CyclotomicField (Monoid.exponent G) ℚ) W)
      (σ : Representation (CyclotomicField (Monoid.exponent G) ℚ) G W),
      letI : Algebra (CyclotomicField (Monoid.exponent G) ℚ) ℂ := φ.toAlgebra
      ∃ (f : (ℂ ⊗[CyclotomicField (Monoid.exponent G) ℚ] W) ≃ₗ[ℂ] V),
        ∀ (g : G) (x : ℂ ⊗[CyclotomicField (Monoid.exponent G) ℚ] W),
          f ((σ g).baseChange ℂ x) = ρ g (f x) := by
  sorry

end RepresentationTheory
end LeanEval
