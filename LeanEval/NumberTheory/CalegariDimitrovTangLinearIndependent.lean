import Mathlib
import EvalTools.Markers

/-!
# Linear independence results of Calegari–Dimitrov–Tang

Theorem A in the 218-page paper "The linear independence of 1, ζ(2), and L(2,χ₋₃)"
(https://arxiv.org/abs/2408.15403) by Frank Calegari, Vesselin Dimitrov, and Yunqing Tang
states that 1, ζ(2), and L(2,χ₋₃) are linear independent over ℚ.

Theorem C states that if m, n ∈ ℤ \ {-1, 0} and |m/n - 1| < 10⁻⁶, then
log(1 + 1/m) * log(1 + 1/n) is irrational, and 1, log(1 + 1/m), log(1 + 1/n) and
log(1 + 1/m) * log(1 + 1/n) are linearly independent over ℚ if m ≠ n.
-/

namespace LeanEval.NumberTheory.CalegariDimitrovTangLinearIndependent

/--
Theorem A and C in arXiv:2408.15403.
-/
@[eval_problem]
theorem cdt_linearIndependent :
    letI χ : ZMod 3 → ℂ := ![0, 1, -1]
    LinearIndependent ℚ ![1, riemannZeta 2, ZMod.LFunction χ 2] ∧
    ∀ m n : ℤ, m ≠ -1 → m ≠ 0 → n ≠ -1 → n ≠ 0 → 10 ^ 6 * |m - n| < |n| →
      letI lm := Real.log (1 + 1 / m)
      letI ln := Real.log (1 + 1 / n)
      Irrational (lm * ln) ∧
      (m ≠ n → LinearIndependent ℚ ![1, lm, ln, lm * ln]) := by
  sorry

end LeanEval.NumberTheory.CalegariDimitrovTangLinearIndependent
