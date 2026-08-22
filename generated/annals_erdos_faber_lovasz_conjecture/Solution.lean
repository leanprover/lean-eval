import ChallengeDeps
import Submission

open ErdosFaberLovaszConjecture
open Filter

set_option autoImplicit false
variable {V : Type*}

theorem theorem_1_1 :
    ∀ᶠ n in atTop, ∀ 𝓗 : Hypergraph (Fin n), 𝓗.IsLinear → 𝓗.chromaticIndex ≤ n := by
  exact Submission.theorem_1_1
