import ChallengeDeps
import Submission

open LeanEval.RepresentationTheory.AdoIwasawa

universe u v

variable {K L : Type u} [Field K] [LieRing L] [LieAlgebra K L]

theorem adoIwasawa [FiniteDimensional K L] :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V), Function.Injective ρ := by
  exact Submission.adoIwasawa
