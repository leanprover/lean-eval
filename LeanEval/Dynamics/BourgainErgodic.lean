import Mathlib
import EvalTools.Markers

namespace LeanEval.Dynamics.BourgainErgodic

/-!
# Bourgain's polynomial ergodic theorem

`bourgain_polynomial_ergodic`: for every integer-polynomial iterate sequence and
every `L^p` (`p > 1`) function, the polynomial ergodic averages
`(1/n) ∑_{k<n} f(T^[a k] x)` converge pointwise almost everywhere. Trusted
helpers (`IsIntegerPolynomialSequence`, `polynomialErgodicAverage`) are
non-holes. Mathlib has Birkhoff's ergodic theorem but not Bourgain's polynomial
extension. Category-(b) candidate from §173 of the Knill survey.
-/

open Filter Finset Function MeasureTheory
open scoped BigOperators ENNReal Topology

variable {X : Type*} [MeasurableSpace X] {μ : Measure X}

/-- A sequence of natural iterate exponents coming from an integer polynomial
which is nonnegative on `ℕ`.  This avoids baking a particular coefficient
representation into the ergodic theorem statements. -/
def IsIntegerPolynomialSequence (a : ℕ → ℕ) : Prop :=
  ∃ P : Polynomial ℤ,
    ∀ n : ℕ, 0 ≤ P.eval (n : ℤ) ∧ a n = Int.toNat (P.eval (n : ℤ))

/-- Bourgain's polynomial ergodic averages
`(1 / n) * ∑_{k < n} f (T^[a k] x)`. -/
noncomputable def polynomialErgodicAverage (a : ℕ → ℕ) (T : X → X) (f : X → ℝ)
    (n : ℕ) (x : X) : ℝ :=
  (n : ℝ)⁻¹ * ∑ k ∈ range n, f (T^[a k] x)

/-- Bourgain's polynomial ergodic theorem: for every integer-polynomial
iterate sequence and every `L^p`, `p > 1`, function, the polynomial ergodic
averages converge pointwise almost everywhere. -/
@[eval_problem]
theorem bourgain_polynomial_ergodic
    [IsProbabilityMeasure μ] {p : ℝ≥0∞} (hp : 1 < p) (hp_ne_top : p ≠ ∞)
    {T : X → X} (hT : MeasurePreserving T μ μ)
    {a : ℕ → ℕ} (ha : IsIntegerPolynomialSequence a)
    {f : X → ℝ} (hf : MemLp f p μ) :
    ∃ F : X → ℝ,
      ∀ᵐ x ∂μ,
        Tendsto (fun n : ℕ => polynomialErgodicAverage a T f (n + 1) x) atTop (𝓝 (F x)) := by
  sorry

end LeanEval.Dynamics.BourgainErgodic
