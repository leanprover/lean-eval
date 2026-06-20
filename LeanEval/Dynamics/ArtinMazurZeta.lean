import Mathlib
import EvalTools.Markers

namespace LeanEval.Dynamics.ArtinMazurZeta

/-!
# Artin–Mazur / Bowen–Lanford zeta identity

`artin_mazur_zeta`: for a complex `k × k` matrix `A`, the Artin–Mazur zeta
series `ζ(t) = exp(∑_{n ≥ 1} tr(Aⁿ) tⁿ / n)` equals `1 / det(1 − tA)` as a
formal power series, where `det(1 − tA)` is the reversed characteristic
polynomial `A.charpolyRev`. Trusted helper `traceSeries` (non-hole). This is the
companion identity to the Parry–Sullivan invariant; category-(b) candidate from
§263 of the Knill survey.
-/

open Matrix PowerSeries

/-- The exponent of the Artin–Mazur zeta series: the power series
`∑_{n ≥ 1} tr(Aⁿ) tⁿ / n`. The `n = 0` coefficient is `tr(A⁰)/0 = 0` (division
by zero is zero in a field), so the sum effectively starts at `n = 1`. -/
noncomputable def traceSeries {k : ℕ} (A : Matrix (Fin k) (Fin k) ℂ) : PowerSeries ℂ :=
  PowerSeries.mk fun n => Matrix.trace (A ^ n) / (n : ℂ)

/-- **Artin–Mazur / Bowen–Lanford identity** (§263).
For a complex `k × k` matrix `A`, the Artin–Mazur zeta series
`ζ(t) = exp(∑_{n ≥ 1} tr(Aⁿ) tⁿ / n)` equals `1 / det(1 − tA)` as a formal
power series, where `det(1 − tA)` is the reversed characteristic polynomial
`A.charpolyRev`. -/
@[eval_problem]
theorem artin_mazur_zeta {k : ℕ} (A : Matrix (Fin k) (Fin k) ℂ) :
    (PowerSeries.exp ℂ).subst (traceSeries A) = ((A.charpolyRev : PowerSeries ℂ))⁻¹ := by
  sorry

end LeanEval.Dynamics.ArtinMazurZeta
