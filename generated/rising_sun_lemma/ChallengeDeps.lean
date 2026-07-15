import Mathlib

namespace LeanEval.Analysis.RisingSun

/-!
# Riesz's rising sun lemma

`rising_sun_lemma`: every continuous real function on a compact interval has the
rising-sun property (the shadow set is open, empty iff the function is
antitone, and otherwise decomposes into disjoint open intervals with endpoint
inequality `f(c) ≤ f(d)`). Trusted helpers (`risingSunSet`,
`HasRisingSunDecomposition`, `HasRisingSunProperty`) are non-holes. Mathlib has
the monotone-a.e.-differentiable consequence but not the rising-sun lemma.
Category-(b) candidate from §163 of the Knill survey.
-/

open Set MeasureTheory
open scoped Topology

/-- Points of `(a,b)` lower than some later point. -/
def risingSunSet (a b : ℝ) (f : ℝ → ℝ) : Set ℝ :=
  {x | x ∈ Ioo a b ∧ ∃ t ∈ Icc x b, x < t ∧ f x < f t}

/-- A countable disjoint open-interval decomposition with the endpoint
inequality `f(c_n) ≤ f(d_n)`. -/
def HasRisingSunDecomposition (E : Set ℝ) (f : ℝ → ℝ) : Prop :=
  ∃ c d : ℕ → ℝ,
    E = ⋃ n : ℕ, Ioo (c n) (d n) ∧
    (Set.PairwiseDisjoint (Set.univ : Set ℕ) fun n => Ioo (c n) (d n)) ∧
    ∀ n : ℕ, f (c n) ≤ f (d n)

/-- The rising-sun property on `[a,b]`. -/
def HasRisingSunProperty (a b : ℝ) (f : ℝ → ℝ) : Prop :=
  IsOpen (risingSunSet a b f) ∧
  (risingSunSet a b f = ∅ ↔ AntitoneOn f (Icc a b)) ∧
  ((risingSunSet a b f).Nonempty → HasRisingSunDecomposition (risingSunSet a b f) f)



end LeanEval.Analysis.RisingSun
