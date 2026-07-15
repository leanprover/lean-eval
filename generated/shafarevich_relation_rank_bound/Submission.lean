import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory
open NumberField CategoryTheory

namespace Submission

theorem shafarevich_relation_rank_bound (F : Type) [Field F] [NumberField F] (p : ℕ) [Fact p.Prime] (_hpOdd : Odd p) :
    H2Finite p (MaxUnramifiedProPGaloisGroup F p) ∧
      (open Classical in
       relationRank p (MaxUnramifiedProPGaloisGroup F p) ≤
        generatorRank (MaxUnramifiedProPGaloisGroup F p) +
          (NumberField.InfinitePlace.nrRealPlaces F +
            NumberField.InfinitePlace.nrComplexPlaces F - 1) +
          (if ∃ ζ : F, IsPrimitiveRoot ζ p then 1 else 0)) := by
  sorry

end Submission
