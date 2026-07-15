import Mathlib
import EvalTools.Markers

namespace LeanEval.Combinatorics.Tverberg

/-!
# Tverberg's theorem

`tverberg_theorem`: any `(r-1)(d+1)+1` points in `ℝ^d` can be partitioned into
`r` parts whose convex hulls share a common point. Trusted helper
`HasTverbergPartition` (non-hole). Mathlib has Radon's theorem (the `r = 2`
case) but not Tverberg.
Category-(b) candidate from §169 of the Knill survey.
-/

open scoped BigOperators

/-- Euclidean `ℝ^d`. -/
abbrev Space (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- An `r`-part Tverberg partition: disjoint parts covering all indices whose
image convex hulls share a common point. -/
def HasTverbergPartition {d r n : ℕ} (f : Fin n → Space d) : Prop :=
  ∃ parts : Fin r → Set (Fin n),
    (∀ i j : Fin r, i ≠ j → Disjoint (parts i) (parts j)) ∧
    (⋃ i : Fin r, parts i) = Set.univ ∧
    ∃ x : Space d, ∀ i : Fin r, x ∈ convexHull ℝ (f '' parts i)

/-- **Tverberg's theorem.** Any `(r-1)(d+1)+1` points in `ℝ^d` admit an
`r`-part Tverberg partition. -/
@[eval_problem]
theorem tverberg_theorem (d r : ℕ) (hr : 1 ≤ r)
    (f : Fin ((r - 1) * (d + 1) + 1) → Space d) :
    HasTverbergPartition (r := r) f := by
  sorry

end LeanEval.Combinatorics.Tverberg
