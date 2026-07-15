import Mathlib
import Submission

theorem commProb_closed : IsClosed ({p : ℝ | ∃ (G : Type) (hG : Group G), commProb G = p}) := by
  exact Submission.commProb_closed
