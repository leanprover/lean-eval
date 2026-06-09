import Mathlib
import EvalTools.Markers

namespace LeanEval.NumberTheory.LandsbergSchaar

/-!
# The Landsberg–Schaar relation

`landsberg_schaar`: for positive odd integers `p, q`,
`S(2q, p) = e^{iπ/4} · S(−p, 2q)`, where `S(q,p) = (1/√p) ∑_{x<p} e^{iπ x² q/p}`
is the normalized quadratic Gauss sum (the trusted helper `gaussS`, a non-hole).
Mathlib has the character-theoretic `gaussSum` (giving `|g|² = p`) and the
Jacobi-theta machinery, but neither the quadratic Gauss-sum value nor the
Landsberg–Schaar relation.

Category-(b) candidate from §120 of the Knill survey.
-/

open Complex Finset

/-- Knill's normalized finite quadratic exponential sum
`S(q, p) = (1/√p) ∑_{x=0}^{p−1} exp(i π x² q / p)`. -/
noncomputable def gaussS (q : ℤ) (p : ℕ) : ℂ :=
  (Real.sqrt p : ℂ)⁻¹ *
    ∑ x ∈ Finset.range p,
      Complex.exp ((Real.pi : ℂ) * Complex.I * ((x : ℂ) ^ 2 * (q : ℂ) / (p : ℂ)))

/-- **Landsberg–Schaar relation.** For positive odd integers `p, q`,
`S(2q, p) = e^{iπ/4} · S(−p, 2q)`. -/
@[eval_problem]
theorem landsberg_schaar (p q : ℕ) (hp : Odd p) (hq : Odd q) :
    gaussS (2 * q : ℕ) p
      = Complex.exp ((Real.pi : ℂ) * Complex.I / 4) * gaussS (-(p : ℤ)) (2 * q) := by
  sorry

end LeanEval.NumberTheory.LandsbergSchaar
