import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Choquet's representation theorem and Bauer's uniqueness

`choquet` is Choquet's representation theorem (Choquet 1956): in a Banach space,
every point of a compact convex set `K` is the barycenter `x = ∫ y ∂μ` of a
probability measure `μ` supported on the extreme points of `K`. `bauer_unique`
is Bauer's uniqueness at extreme points: if `x` is an extreme point of `K` and
`μ` is a probability measure on `K` with barycenter `x`, then `μ` is the Dirac
mass at `x`.

A norm-compact set in a Banach space is metrizable, so the extreme points form
a Borel set and Choquet's theorem proper applies (no Choquet–Bishop–de Leeuw
boundary-measure refinement is needed) — the literal "supported on `ext K`"
rendering `μ (K.extremePoints ℝ)ᶜ = 0` is faithful in this setting.

Mathlib has the Krein–Milman theorem (`closure_convexHull_extremePoints`) and
the barycenter-in-convex-set lemma (`Convex.integral_mem`), but neither
Choquet's theorem nor Bauer's uniqueness, and no measure-theoretic barycenter
operator. Both statements use no new definitions beyond Mathlib's
`Set.extremePoints`, `IsProbabilityMeasure`, and the Bochner integral.

These are category-(b) candidates from §88 of the Knill survey
(`sections/088-choquet-theory.md`). (Krein–Milman, the section's other
statement, is category-(a) — already in Mathlib — and is not a candidate.)
-/

open MeasureTheory

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]

/-- **Choquet's representation theorem.** Every point `x` of a compact convex
set `K` in a Banach space is the barycenter of a probability measure supported
on the extreme points of `K`: there is a probability measure `μ` with
`μ (ext K)ᶜ = 0` whose barycenter `∫ y, y ∂μ` equals `x`. -/
@[eval_problem]
theorem choquet [MeasurableSpace X] [BorelSpace X]
    (K : Set X) (hK_cpt : IsCompact K) (hK_cvx : Convex ℝ K)
    {x : X} (hx : x ∈ K) :
    ∃ μ : Measure X, IsProbabilityMeasure μ ∧
      μ (K.extremePoints ℝ)ᶜ = 0 ∧
      x = ∫ y, y ∂μ := by
  sorry

/-- **Bauer's uniqueness at extreme points.** If `x` is an extreme point of a
compact convex set `K` and `μ` is a probability measure supported on `K`
(`μ Kᶜ = 0`) with barycenter `x = ∫ y, y ∂μ`, then `μ` is the Dirac mass at
`x`. (The support hypothesis is the weaker `μ Kᶜ = 0`, making this a
strengthening of the textbook statement: uniqueness among all ambient Borel
probability measures on `K`, not only those already supported on `ext K`.) -/
@[eval_problem]
theorem bauer_unique [MeasurableSpace X] [BorelSpace X]
    (K : Set X) (hK_cpt : IsCompact K) (hK_cvx : Convex ℝ K)
    {x : X} (hx : x ∈ K.extremePoints ℝ)
    (μ : Measure X) [IsProbabilityMeasure μ]
    (hμ : μ Kᶜ = 0) (hbar : x = ∫ y, y ∂μ) :
    μ = Measure.dirac x := by
  sorry

end Analysis
end LeanEval
