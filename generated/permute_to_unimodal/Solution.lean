import ChallengeDeps
import Submission

open LeanEval.ProgramVerification

theorem minRearrange_correct {arr : Array Nat} :
    arr.Perm (1...=arr.size).toArray →
      (∃ (x : Array Nat) (hx : x.Perm (1...=arr.size).toArray), Unimodal x ∧ differences (Vector.mk x (by simpa using hx.size_eq)) arr.toVector = minRearrange arr) ∧
      (∀ (x : Array Nat) (hx : x.Perm (1...=arr.size).toArray), Unimodal x → minRearrange arr ≤ differences (Vector.mk x (by simpa using hx.size_eq)) arr.toVector) := by
  exact Submission.minRearrange_correct
