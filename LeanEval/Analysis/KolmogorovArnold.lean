import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Kolmogorov–Arnold superposition theorem (non-universal existence form)

For every continuous `f` on the unit cube `[0, 1]ⁿ` (with `n ≥ 1`),
there exist continuous one-variable inner functions `φ_{k,l} : ℝ → ℝ`
and a single continuous outer function `g : ℝ → ℝ` such that

  `f(x₁, …, xₙ) = ∑_{k=0}^{2n} g(∑_{l=1}^{n} φ_{k,l}(x_l))`.

This is the Lorentz (1962) single-outer-function form. Both `g` and the
`φ_{k,l}` are allowed to depend on `f` — weaker than the universal-
inner-functions formulation, since here the inner functions may depend
on `f`. The two-variable function used to combine the layers is just
addition, resolving the continuous form of Hilbert's 13th problem.

The inner and outer functions are stated as globally continuous maps
`ℝ → ℝ`. This is a harmless strengthening of versions stated on
compact subsets: the inner functions are only evaluated on `[0, 1]`,
and the outer function is only evaluated on the compact set of inner
sums, so Tietze extension gives global continuous representatives.
-/

open scoped BigOperators

/-- **Kolmogorov–Arnold superposition theorem (non-universal Lorentz
form).** For `n ≥ 1`, every continuous `f` on the unit cube `[0, 1]ⁿ`
admits a representation
`f(x) = ∑_{k=0}^{2n} g(∑_{l=1}^{n} φ_{k,l}(x_l))` with a single
continuous outer function `g : ℝ → ℝ` and continuous inner functions
`φ_{k,l} : ℝ → ℝ`. -/
@[eval_problem]
theorem kolmogorov_arnold (n : ℕ) (_hn : 1 ≤ n)
    (f : (Fin n → ℝ) → ℝ) (_hf : ContinuousOn f (Set.Icc 0 1)) :
    ∃ (g : ℝ → ℝ) (φ : Fin (2 * n + 1) → Fin n → ℝ → ℝ),
      Continuous g ∧ (∀ k l, Continuous (φ k l)) ∧
      ∀ x ∈ Set.Icc (0 : Fin n → ℝ) 1,
        f x = ∑ k, g (∑ l, φ k l (x l)) := by
  sorry

end Analysis
end LeanEval
