import Mathlib
import EvalTools.Markers

/-!
Minimal example exercising multi-hole problems with **trusted helper
declarations**. `magicNumber` is not a `@[eval_problem]` hole; both
holes depend on it. The multi-hole generator factors it into
`ChallengeDeps.lean` so `Submission` and `Solution` reference the same
canonical declaration (rather than each carrying its own copy as
`Submission.MultiHoleHelpersExample.magicNumber` vs
`MultiHoleHelpersExample.magicNumber` — distinct types that wouldn't
unify).
-/

namespace MultiHoleHelpersExample

/-- Trusted helper: a fixed natural number both holes refer to. -/
def magicNumber : Nat := 42

@[eval_problem]
def step : Nat := sorry

@[eval_problem]
theorem step_eq : step = magicNumber := sorry

end MultiHoleHelpersExample
