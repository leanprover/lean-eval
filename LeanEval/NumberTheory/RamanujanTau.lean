import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory
namespace RamanujanTauProblem

/-!
# The Ramanujan–Petersson conjecture for the τ-function (Deligne's theorem)

The modular discriminant
`Δ = q ∏_{n ≥ 1} (1 - qⁿ)²⁴ = ∑_{n ≥ 1} τ(n) qⁿ`
is the unique normalised cusp form of weight `12` for `SL₂(ℤ)`, and its
Fourier coefficients define the Ramanujan τ-function.

Ramanujan conjectured in 1916 that `|τ(p)| ≤ 2 p^(11/2)` for every prime
`p`; Petersson generalised the conjecture to all cusp forms. Deligne
proved it in 1974 as a consequence of his proof of the Weil conjectures,
so the "conjecture" is a theorem.

The statement is taken verbatim from `FormalConjectures/Wikipedia/RamanujanTau.lean`
in the DeepMind `formal-conjectures` repository (Apache 2.0); see the `source`
field of the manifest entry for the URL.
-/

open PowerSeries

open scoped PowerSeries.WithPiTopology

/-- The modular discriminant `Δ = q ∏_{n ≥ 1} (1 - qⁿ)²⁴` as a formal power
series over `ℤ`, with `X` playing the role of `q`. -/
noncomputable def Δ : PowerSeries ℤ := X * ∏' (n : ℕ+), (1 - X ^ (n : ℕ)) ^ 24

/-- The defining product of `Δ` converges in the coefficientwise topology on
`PowerSeries ℤ`: it is mathlib's convergent product `∏' n, (1 - X ^ (n + 1))`
raised to the `24`th power termwise and reindexed along `ℕ+ ≃ ℕ`. Consequently
the `∏'` in `Δ` is a genuine infinite product rather than the junk value
`tprod` takes on a non-multipliable family. -/
theorem multipliable_one_sub_X_pow_pow :
    Multipliable fun n : ℕ+ ↦ ((1 - X ^ (n : ℕ)) ^ 24 : PowerSeries ℤ) :=
  (Equiv.pnatEquivNat.multipliable_iff.mpr
    ((WithPiTopology.multipliable_one_sub_X_pow ℤ).pow 24)).congr fun n ↦ by simp

/-- The Ramanujan τ-function: the `n`-th Fourier coefficient of the modular
discriminant `Δ`. -/
noncomputable def τ (n : ℕ) : ℤ := PowerSeries.coeff n Δ

/-- **The Ramanujan–Petersson conjecture for `τ`** (Ramanujan 1916; proved by
Deligne in 1974). For every prime `p`, `|τ(p)| ≤ 2 p^(11/2)`. -/
@[eval_problem]
theorem ramanujan_petersson :
    ∀ p : ℕ, Prime p → |τ p| ≤ 2 * (p : ℝ) ^ ((11 : ℝ) / 2) := by
  sorry

end RamanujanTauProblem
end NumberTheory
end LeanEval
