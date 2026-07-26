import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory
namespace RamanujanTauProblem

/-!
# The Ramanujan–Petersson conjecture for the τ-function (Deligne's theorem)

The modular discriminant `Δ(z) = η(z)²⁴ = q ∏_{n ≥ 1} (1 - qⁿ)²⁴` (where `η`
is the Dedekind eta function and `q = e^{2πiz}`) is the normalised cusp form
of weight `12` and level `1`, and the Ramanujan τ-function is defined by its
Fourier expansion `Δ = ∑_{n ≥ 1} τ(n) qⁿ`.

Ramanujan conjectured in 1916 that `|τ(p)| ≤ 2 p^(11/2)` for every prime `p`;
Petersson generalised the conjecture to all cusp forms. Deligne proved it in
1974 as a consequence of his proof of the Weil conjectures, so the
"conjecture" is a theorem.

Here `τ n` is the `n`-th `q`-expansion coefficient of mathlib's modular
discriminant `ModularForm.discriminant`, which
`ModularForm.discriminant_eq_q_prod` identifies with the classical infinite
product. The coefficients are a priori complex numbers (their integrality is
classical but not needed to state the bound), so the statement bounds the
complex norm `‖τ p‖`. The statement shape follows
`FormalConjectures/Wikipedia/RamanujanTau.lean` in the DeepMind
`formal-conjectures` repository (Apache 2.0), which instead defines `τ`
through the formal power series `X * ∏' n, (1 - X ^ n)²⁴` over `ℤ`.
-/

open ModularForm UpperHalfPlane

/-- The Ramanujan τ-function: the `n`-th coefficient of the `q`-expansion of
the modular discriminant `Δ(z) = η(z)²⁴`, the normalised cusp form of weight
`12` and level `1` (`CuspForm.discriminant` in mathlib). -/
noncomputable def τ (n : ℕ) : ℂ := (qExpansion 1 discriminant).coeff n

/-- Normalisation check for the definition of `τ`: the discriminant is the
*normalised* cusp form, `τ 1 = 1`. -/
theorem τ_one : τ 1 = 1 := discriminant_qExpansion_coeff_one

/-- **The Ramanujan–Petersson conjecture for `τ`** (Ramanujan 1916; proved by
Deligne in 1974). For every prime `p`, `|τ(p)| ≤ 2 p^(11/2)`. -/
@[eval_problem]
theorem ramanujan_petersson :
    ∀ p : ℕ, Prime p → ‖τ p‖ ≤ 2 * (p : ℝ) ^ ((11 : ℝ) / 2) := by
  sorry

end RamanujanTauProblem
end NumberTheory
end LeanEval
