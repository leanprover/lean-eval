import Mathlib
import EvalTools.Markers

/-!
Regression for https://github.com/leanprover/lean-eval/issues/276.

The theorem below relies on `n` from a preceding `variable` declaration.
Before the fix, the extractor sliced the theorem source verbatim, dropping
the `variable {n : Type*} [Fintype n] [DecidableEq n]` line, and the
generated `Challenge.lean` failed to compile with "Unknown identifier `n`".

A few negative cases are also exercised:
- a `variable` declared inside a closed `section` must NOT be emitted; if
  the scanner is buggy it might leak `[DecidableEq m]` into the workspace,
  which would refer to an out-of-scope `m`;
- the word `variable` appearing inside this docstring must NOT be picked up
  by the line scanner.
-/

namespace LeanEval.Sandbox

section ClosedSection
variable {m : Type*} [DecidableEq m]
end ClosedSection

variable {n : Type*} [Fintype n] [DecidableEq n]

@[eval_problem]
theorem variable_binder_example
    (A : Matrix n n ℚ) (hA : A.IsHermitian) :
    A.trace = ∑ i, A i i := by
  sorry

end LeanEval.Sandbox
