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
`PowerSeries ℤ`: the factor `(1 - Xⁿ)²⁴` is congruent to `1` modulo `Xⁿ`, so the
orders of `(1 - Xⁿ)²⁴ - 1` tend to infinity. Consequently the `∏'` in `Δ` is a
genuine infinite product rather than the junk value `tprod` takes on a
non-multipliable family. -/
theorem multipliable_one_sub_X_pow_pow :
    Multipliable fun n : ℕ+ ↦ ((1 - X ^ (n : ℕ)) ^ 24 : PowerSeries ℤ) := by
  have key : ∀ n : ℕ+,
      (n : ℕ∞) ≤ order (((1 - X ^ (n : ℕ)) ^ 24 - 1 : PowerSeries ℤ)) := by
    intro n
    have hdvd : (X : PowerSeries ℤ) ^ (n : ℕ) ∣ ((1 - X ^ (n : ℕ)) ^ 24 - 1) := by
      have h := sub_dvd_pow_sub_pow (1 - X ^ (n : ℕ) : PowerSeries ℤ) 1 24
      simpa using h
    refine le_order _ _ fun i hi => ?_
    exact X_pow_dvd_iff.mp hdvd i (by exact_mod_cast hi)
  have hfun : (fun n : ℕ+ ↦ ((1 - X ^ (n : ℕ)) ^ 24 : PowerSeries ℤ))
      = fun n : ℕ+ ↦ 1 + (((1 - X ^ (n : ℕ)) ^ 24 - 1 : PowerSeries ℤ)) := by
    funext n; ring
  rw [hfun]
  apply WithPiTopology.multipliable_one_add_of_tendsto_order_atTop_nhds_top
  refine ENat.tendsto_nhds_top_iff_natCast_lt.mpr fun m => Filter.eventually_atTop.mpr
    ⟨(⟨m + 1, m.succ_pos⟩ : ℕ+), fun k hk => lt_of_lt_of_le ?_ (key k)⟩
  have : m + 1 ≤ (k : ℕ) := hk
  exact_mod_cast this

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
