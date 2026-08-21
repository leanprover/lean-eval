import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

theorem cdt_linearIndependent :
    letI χ : ZMod 3 → ℂ := ![0, 1, -1]
    LinearIndependent ℚ ![1, riemannZeta 2, ZMod.LFunction χ 2] ∧
    ∀ m n : ℤ, m ≠ -1 → m ≠ 0 → n ≠ -1 → n ≠ 0 → 10 ^ 6 * |m - n| < |n| →
      letI lm := Real.log (1 + 1 / m)
      letI ln := Real.log (1 + 1 / n)
      Irrational (lm * ln) ∧
      (m ≠ n → LinearIndependent ℚ ![1, lm, ln, lm * ln]) := by
  sorry
