import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

open NumberField

/-- **Unconditional Odlyzko Bound**. 
There exists a constant `c > 0` such that for every number field `K`, 
the absolute value of its discriminant is bounded below by `(60.8)^{r_1} * (22.3)^{2 r_2} * e^{-c}`,
where `r_1` and `r_2` are the number of real and complex places of `K` respectively. -/
@[eval_problem]
theorem odlyzko_bound_unconditional :
    ∃ (c : ℝ), 0 < c ∧
    ∀ (K : Type*) [Field K] [NumberField K],
      let r1 := (InfinitePlace.nrRealPlaces K : ℝ)
      let r2 := (InfinitePlace.nrComplexPlaces K : ℝ)
      ((discr K).natAbs : ℝ) ≥ (60.8 : ℝ) ^ r1 * (22.3 : ℝ) ^ (2 * r2) * Real.exp (-c) := by
  sorry

end NumberTheory
end LeanEval
