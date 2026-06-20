import Mathlib
import EvalTools.Markers

namespace LeanEval.Combinatorics.ErdosSzekeres

/-!
# Erdős–Szekeres theorem (finite form)

`erdos_szekeres`: any sequence of `n² + 1` distinct real numbers contains a
strictly increasing subsequence of length `n + 1` or a strictly decreasing
subsequence of length `n + 1`, encoded by a strictly monotone index map
`g : Fin (n + 1) → Fin (n² + 1)`. Mathlib has only the infinitary
Erdős–Szekeres theorem (`exists_increasing_or_nonincreasing_subseq`); the finite
quantitative bound is not present. Category-(b) candidate from §16 of the Knill
survey.
-/

open Function

/-- **Erdős–Szekeres (finite form).** Any injective sequence
`f : Fin (n² + 1) → ℝ` admits a strictly monotone index map
`g : Fin (n + 1) → Fin (n² + 1)` along which `f` is either strictly increasing or
strictly decreasing. -/
@[eval_problem]
theorem erdos_szekeres {n : ℕ} (f : Fin (n ^ 2 + 1) → ℝ) (hf : Function.Injective f) :
    (∃ g : Fin (n + 1) → Fin (n ^ 2 + 1), StrictMono g ∧ StrictMono (f ∘ g)) ∨
    (∃ g : Fin (n + 1) → Fin (n ^ 2 + 1), StrictMono g ∧ StrictAnti (f ∘ g)) := by
  sorry

end LeanEval.Combinatorics.ErdosSzekeres
