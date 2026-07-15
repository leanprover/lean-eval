import ChallengeDeps
import Submission

open LeanEval.NumberTheory.LandsbergSchaar
open Complex Finset

theorem landsberg_schaar (p q : ℕ) (hp : Odd p) (hq : Odd q) :
    gaussS (2 * q : ℕ) p
      = Complex.exp ((Real.pi : ℂ) * Complex.I / 4) * gaussS (-(p : ℤ)) (2 * q) := by
  exact Submission.landsberg_schaar p q hp hq
