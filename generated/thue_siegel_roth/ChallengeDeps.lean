import Mathlib

namespace LeanEval
namespace NumberTheory
namespace ThueSiegelRothProblem

/-!
# Thue–Siegel–Roth theorem

Every irrational algebraic real has irrationality measure at most `2`:
for every `ε > 0` there exists `C > 0` such that for every integer `p`
and every positive integer `q`, `|x − p/q| > C / q^(2+ε)`. Klaus Roth
1955 (building on Thue 1909, Siegel 1921, Dyson 1947); §65 in Knill's
*Some Fundamental Theorems in Mathematics*.

The sharp `∀ ε > 0` form is the content of Roth's theorem. The weaker
`∃ ε > 0` form is equivalent to "x has finite irrationality measure"
(i.e. x is not Liouville), which is Liouville's 1844 theorem and is
already in mathlib as `Liouville.transcendental` /
`Liouville.exists_pos_real_of_irrational_root`.
-/

open Real

/-- A real `x` is **Diophantine** in the Thue–Siegel–Roth sense — i.e.
has *irrationality measure at most 2* — if for **every** `ε > 0` there
exists `C > 0` with `C / q^(2+ε) < |x − p/q|` for every integer `p` and
every positive integer `q`. -/
def IsDiophantine (x : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ C : ℝ, 0 < C ∧
    ∀ (p q : ℤ), 0 < q → C / (q : ℝ) ^ ((2 : ℝ) + ε) < |x - (p : ℝ) / (q : ℝ)|



end ThueSiegelRothProblem
end NumberTheory
end LeanEval
