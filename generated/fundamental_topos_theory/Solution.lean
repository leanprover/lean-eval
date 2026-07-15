import ChallengeDeps
import Submission

open LeanEval.ToposTheory
open _root_.CategoryTheory _root_.CategoryTheory.Limits

theorem fundamental_topos_theory {E : Type*} [Category E]
    (hE : IsTopos E) (X : E) : IsTopos (Over X) := by
  exact Submission.fundamental_topos_theory hE X
