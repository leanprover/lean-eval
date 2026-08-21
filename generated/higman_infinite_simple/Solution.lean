import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem higman_infinite_simple :
    ∃ (n : ℕ) (rels : Set (FreeGroup (Fin n))),
      rels.Finite ∧ IsSimpleGroup (PresentedGroup rels) ∧
        Infinite (PresentedGroup rels) := by
  exact Submission.higman_infinite_simple
