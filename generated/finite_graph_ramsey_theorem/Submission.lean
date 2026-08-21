import Mathlib.Combinatorics.SimpleGraph.Clique
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

open SimpleGraph

namespace Submission

theorem finite_graph_ramsey_theorem :
    ∀ r s : ℕ, 2 ≤ r → 2 ≤ s → ∃ n : ℕ, ∀ G : SimpleGraph (Fin n), ¬ G.CliqueFree r ∨ ¬ Gᶜ.CliqueFree s := by
  sorry

end Submission
