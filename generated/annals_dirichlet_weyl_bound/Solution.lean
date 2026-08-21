import ChallengeDeps
import Submission

open DirichletWeylBound
open Complex

theorem corollary_1_3 (ε : ℝ) (hε : 0 < ε) : ∃ C : ℝ,
    ∀ q (_hq : q.IsCubeFree) [NeZero q] (χ : DirichletCharacter ℂ q) (_hχ : χ.IsPrimitive) (t : ℝ),
      ‖χ.LFunction (1 / 2 + I * t)‖ ≤ C * q ^ (1 / 6 + ε) * (1 + |t|) ^ (1 / 6 + ε) := by
  exact Submission.corollary_1_3 ε hε
