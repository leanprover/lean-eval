import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Differentiability of the Newton potential

`newtonPotential_differentiable` is the basic gain-of-one-derivative result in
elliptic regularity for the Poisson equation `−Δu = f`: for `n ≥ 2`,
`f ∈ Lᵖ(ℝⁿ)` with `p > n`, and any harmonic `h`, the Poisson solution
`K_f = G ⋆ f + h` (with `G` the Newton kernel) is everywhere differentiable.

The trusted helper definitions (`newtonKernel`, `newtonPotential`,
`poissonSolution`) are non-holes. Mathlib has `MemLp`, `HarmonicOnNhd`, and
`convolution`, but no Newton kernel / Newton potential and none of the
Calderón–Zygmund `Lᵖ → W^{2,p}` or Morrey `W^{2,p} ↪ C^{1,α}` (for `p > n`)
machinery the standard proof goes through.

This is a category-(b) candidate from §75 of the Knill survey
(`sections/075-poisson-equation.md`). (The higher-regularity and
finite-dimensional Fredholm-determinant statements of §75 are not included
here.)
-/

/-- The **Newton kernel** on `ℝⁿ` (`n ≥ 2`): the logarithmic kernel
`−log‖z‖/(2π)` for `n = 2`, and `‖z‖^{2−n}/((n−2)·ωₙ₋₁)` for `n ≥ 3`
(`ωₙ₋₁ = n·vol(B₁)`). The value at `0` is irrelevant (non-integrable there). -/
noncomputable def newtonKernel (n : ℕ) (z : EuclideanSpace ℝ (Fin n)) : ℝ :=
  if n = 2 then
    -Real.log ‖z‖ / (2 * Real.pi)
  else
    ‖z‖ ^ ((2 : ℝ) - n) /
      ((n - 2) * (n * (MeasureTheory.volume
        (Metric.ball (0 : EuclideanSpace ℝ (Fin n)) 1)).toReal))

/-- The **Newton potential** `(G ⋆ f)(x) = ∫ G(x − y) f(y) dy` on `ℝⁿ`. -/
noncomputable def newtonPotential (n : ℕ) (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (x : EuclideanSpace ℝ (Fin n)) : ℝ :=
  ∫ y, newtonKernel n (x - y) * f y

/-- The Poisson solution `K_f = G ⋆ f + h` for a harmonic `h`; a distributional
solution of `−Δ K_f = f`. -/
noncomputable def poissonSolution (n : ℕ) (f h : EuclideanSpace ℝ (Fin n) → ℝ)
    (x : EuclideanSpace ℝ (Fin n)) : ℝ :=
  newtonPotential n f x + h x

/-- **Differentiability of the Newton potential / Poisson solution.** For
`n ≥ 2`, `f ∈ Lᵖ(ℝⁿ)` with `p > n`, and any harmonic `h`, the function
`K_f = G ⋆ f + h` is everywhere `ℝ`-differentiable. -/
@[eval_problem]
theorem newtonPotential_differentiable {n : ℕ} (hn : 2 ≤ n)
    (f h : EuclideanSpace ℝ (Fin n) → ℝ) (p : ENNReal)
    (hp : (n : ENNReal) < p)
    (hf : MeasureTheory.MemLp f p MeasureTheory.volume)
    (hh : InnerProductSpace.HarmonicOnNhd h Set.univ) :
    Differentiable ℝ (poissonSolution n f h) := by
  sorry

end Analysis
end LeanEval
