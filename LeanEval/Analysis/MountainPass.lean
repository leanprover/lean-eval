import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis
namespace MountainPassProblem

/-!
# Mountain Pass Theorem (Ambrosetti–Rabinowitz 1973)

A `C¹` functional `f` on a real Banach space `E` satisfying the
Palais–Smale compactness condition and having a *mountain range*
geometry separating two points `a, b` admits a critical point at the
mini-max level `c = inf_γ sup_t f(γ t)`, and `c ≥ ε > 0`.
Ambrosetti–Rabinowitz 1973. The statement is listed as §119 in Knill's
*Some Fundamental Theorems in Mathematics*.

Knill writes the far point condition as "`f(b) ≤ 0` for some `|b| > ε`".
The radius of the sphere is `r`, not `ε`, so `|b| > ε` is a
transcription slip for `r < ‖b − a‖`. The faithful condition encoded
here is the translated Ambrosetti–Rabinowitz geometry: `f a = 0`,
`f ≥ ε` on `Metric.sphere a r`, and `r < ‖b − a‖`.
-/

open scoped unitInterval

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- `x` is a **critical point** of `f` when `f'(x) = 0`. -/
def IsCriticalPoint (f : E → ℝ) (x : E) : Prop :=
  fderiv ℝ f x = 0

/-- `f` satisfies **Palais–Smale**: every sequence along which `f` is
bounded and `f'` tends to `0` admits a convergent subsequence. -/
def PalaisSmale (f : E → ℝ) : Prop :=
  ∀ u : ℕ → E, (∃ M : ℝ, ∀ k, |f (u k)| ≤ M) →
      Filter.Tendsto (fun k => fderiv ℝ f (u k)) Filter.atTop (nhds 0) →
      ∃ (x : E) (φ : ℕ → ℕ), StrictMono φ ∧
        Filter.Tendsto (u ∘ φ) Filter.atTop (nhds x)

/-- `a, b` are separated by a **mountain range** at height `ε`, radius
`r`: `f a = 0`, `f ≥ ε > 0` on the sphere `S_r(a)`, and `f b ≤ 0` for
some `b` strictly outside that sphere. -/
def MountainRange (f : E → ℝ) (a b : E) (ε r : ℝ) : Prop :=
  f a = 0 ∧ 0 < ε ∧ 0 < r ∧
    (∀ y ∈ Metric.sphere a r, ε ≤ f y) ∧ r < ‖b - a‖ ∧ f b ≤ 0

/-- The **mini-max value** over continuous paths from `a` to `b`:
`c = inf_γ sup_t f(γ t)`. -/
noncomputable def mountainPassLevel (f : E → ℝ) (a b : E) : ℝ :=
  ⨅ γ : Path a b, ⨆ t : I, f (γ t)

/-- **Mountain Pass Theorem** (Ambrosetti–Rabinowitz 1973). A `C¹`
functional on a real Banach space satisfying Palais–Smale with mountain
range geometry has a critical point at the mini-max level
`c ≥ ε > 0`. -/
@[eval_problem]
theorem mountain_pass (f : E → ℝ) (_hf : ContDiff ℝ 1 f) (_hps : PalaisSmale f)
    {a b : E} {ε r : ℝ} (_hmr : MountainRange f a b ε r) :
    ∃ x : E, IsCriticalPoint f x ∧
      f x = mountainPassLevel f a b ∧ ε ≤ mountainPassLevel f a b := by
  sorry

end MountainPassProblem
end Analysis
end LeanEval
