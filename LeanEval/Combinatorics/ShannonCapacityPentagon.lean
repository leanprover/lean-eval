import Mathlib
import EvalTools.Markers

namespace LeanEval.Combinatorics.ShannonCapacityPentagon

/-!
# Shannon capacity of the pentagon (Lovász)

`shannon_capacity_pentagon`: the Shannon capacity of the five-cycle `C₅` is
`√5`. Trusted helpers `IsIndependent`, `independenceNumber`, `strongPower`,
`HasShannonCapacity` (non-holes). Mathlib has simple graphs and cycle graphs but
no Shannon capacity, strong graph powers, or Lovász number. Category-(b)
candidate from §238 of the Knill survey.
-/

open Filter
open scoped Topology

/-- A finite set of vertices is independent if no two distinct members are adjacent. -/
def IsIndependent {V : Type*} (G : SimpleGraph V) (s : Finset V) : Prop :=
  ∀ ⦃v⦄, v ∈ s → ∀ ⦃w⦄, w ∈ s → v ≠ w → ¬ G.Adj v w

/-- The independence number of a finite simple graph. -/
noncomputable def independenceNumber (V : Type*) [Fintype V] (G : SimpleGraph V) : ℕ :=
  sSup {m : ℕ | ∃ s : Finset V, IsIndependent G s ∧ s.card = m}

/-- The strong graph power on length-`k` words.  Two words are confusable
when they are distinct and every coordinate is either equal or confusable in
the base graph. -/
def strongPower {V : Type*} (G : SimpleGraph V) (k : ℕ) : SimpleGraph (Fin k → V) where
  Adj x y := x ≠ y ∧ ∀ i, x i = y i ∨ G.Adj (x i) (y i)
  symm x y := by
    rintro ⟨hxy, hcoord⟩
    exact ⟨hxy.symm, fun i => (hcoord i).imp Eq.symm SimpleGraph.Adj.symm⟩
  loopless := ⟨fun x h => h.1 rfl⟩

/-- The Shannon capacity of `G` is `θ` if the normalized independence
numbers of the strong powers tend to `θ`. -/
noncomputable def HasShannonCapacity {V : Type*} [Fintype V] (G : SimpleGraph V) (θ : ℝ) :
    Prop :=
  Tendsto
    (fun k : ℕ =>
      Real.rpow
        (independenceNumber (Fin (k + 1) → V) (strongPower G (k + 1)) : ℝ)
        ((k + 1 : ℝ)⁻¹))
    atTop (𝓝 θ)

/-- **Lovász's theorem on Shannon capacity of the pentagon** (§238).
The Shannon capacity of the five-cycle is `√5`. -/
@[eval_problem]
theorem shannon_capacity_pentagon :
    HasShannonCapacity (SimpleGraph.cycleGraph 5) (Real.sqrt 5) := by
  sorry

end LeanEval.Combinatorics.ShannonCapacityPentagon
