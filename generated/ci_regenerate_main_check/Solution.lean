import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem ci_regenerate_main_check : True := by
  exact Submission.ci_regenerate_main_check
