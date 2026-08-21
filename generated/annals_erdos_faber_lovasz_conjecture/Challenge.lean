import ChallengeDeps

open ErdosFaberLovaszConjecture
open Filter

variable {V : Type*}

theorem theorem_1_1 :
    ∀ᶠ n in atTop, ∀ 𝓗 : Hypergraph (Fin n), 𝓗.IsLinear → 𝓗.chromaticIndex ≤ n := by
  sorry
