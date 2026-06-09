import Mathlib

namespace LeanEval
namespace Analysis

/-!
# The Hausdorff moment problem on the cube

`hausdorff_hildebrandt_schoenberg` is the Hausdorff–Hildebrandt–Schoenberg
theorem (1933): a multi-indexed real sequence is the moment sequence of a
signed bounded-variation Borel measure on the unit cube `Iᵈ = [0,1]ᵈ` iff it is
*Hausdorff bounded*. `hausdorff_positivity` is the Hausdorff positivity
criterion (1921): it comes from a *positive* finite measure iff it is completely
monotone (all iterated backward differences nonnegative).

A signed bounded-variation measure is encoded by its Jordan decomposition (a
difference of two finite positive measures); the moment integrals are taken over
the cube, so only the restriction to `Iᵈ` matters; the iterated backward
difference `Δᵏ` is given in closed form (the `ℕ`-subtraction `n − j` is genuine
in the `k ≤ n` regime the criteria use).

Mathlib has `SignedMeasure`, Jordan decomposition, finite measures, and set
integrals — enough to *state* the theorem — but no moment-problem machinery
(no Hausdorff/Hamburger/Stieltjes moment problem, no completely-monotone
sequences). The helper definitions below (`cube`, `monomial`, `momentOf`,
`IsMomentConfiguration`, `multiChoose`, `diff`, `HausdorffBounded`,
`IsPositiveMomentConfiguration`) are trusted (non-holes).

These are category-(b) candidates from §115 of the Knill survey
(`sections/115-moments.md`).
-/

open MeasureTheory
open scoped BigOperators NNReal

/-- The closed unit cube `Iᵈ = [0,1]ᵈ ⊆ ℝᵈ`. -/
def cube (d : ℕ) : Set (EuclideanSpace ℝ (Fin d)) := {x | ∀ i, x i ∈ Set.Icc (0 : ℝ) 1}

/-- The monomial `xⁿ = ∏ᵢ xᵢ^{nᵢ}` indexed by a multi-index `n ∈ ℕᵈ`. -/
def monomial {d : ℕ} (n : Fin d → ℕ) (x : EuclideanSpace ℝ (Fin d)) : ℝ := ∏ i, (x i) ^ (n i)

/-- The `n`-th moment `∫_{Iᵈ} xⁿ dμ` of a (positive) measure `μ`, integrated
over the cube. -/
noncomputable def momentOf {d : ℕ} (μ : Measure (EuclideanSpace ℝ (Fin d))) (n : Fin d → ℕ) : ℝ :=
  ∫ x in cube d, monomial n x ∂μ

/-- The multi-index binomial coefficient `C(n,k) = ∏ᵢ C(nᵢ, kᵢ)`. -/
def multiChoose {d : ℕ} (n k : Fin d → ℕ) : ℕ := ∏ i, (n i).choose (k i)

/-- The iterated **backward** partial difference `(Δᵏa)ₙ`, in closed form
`∑_{0 ≤ j ≤ k} (−1)^{|k−j|} C(k,j) a_{n−j}` — the iterate of
`(Δᵢa)ₙ = a_{n−eᵢ} − aₙ`. The `ℕ`-subtraction `n − j` is genuine whenever
`k ≤ n` (the regime used below). -/
noncomputable def diff {d : ℕ} (a : (Fin d → ℕ) → ℝ) (k n : Fin d → ℕ) : ℝ :=
  ∑ j ∈ Finset.Iic k,
    (-1 : ℝ) ^ (∑ i, (k i - j i)) * (multiChoose k j : ℝ) * a (n - j)

/-- `a` is a **positive** moment configuration: realized by a single finite
*positive* measure on the cube. -/
def IsPositiveMomentConfiguration {d : ℕ} (a : (Fin d → ℕ) → ℝ) : Prop :=
  ∃ μ : Measure (EuclideanSpace ℝ (Fin d)), IsFiniteMeasure μ ∧ ∀ n, a n = momentOf μ n



end Analysis
end LeanEval
