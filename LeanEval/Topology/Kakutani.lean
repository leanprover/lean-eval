import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Kakutani fixed-point theorem

§33 of Oliver Knill's *Some Fundamental Theorems in Mathematics* (an
additional statement in the section on game theory; Nash's 1951 proof of
equilibrium existence uses Kakutani directly). The set-valued
generalization of Brouwer: every upper-hemicontinuous correspondence from
a nonempty compact convex `K ⊆ ℝᵈ` to itself with nonempty convex closed
values has a fixed point `x ∈ F x`.

mathlib has Brouwer-related lattices/logics under `grep -ri kakutani` only
the Riesz–Markov–Kakutani representation theorem for positive functionals
— a different theorem entirely. The fixed-point theorem itself is not in
mathlib.
-/

/-- A correspondence `F : α → Set β` is **upper hemicontinuous** in the
closed-graph sense if its graph `{(x, y) | y ∈ F x}` is closed in `α × β`.
For closed-valued maps into a compact space this coincides with the
sequential/topological definition. -/
def IsUpperHemicontinuous {α β : Type*}
    [TopologicalSpace α] [TopologicalSpace β] (F : α → Set β) : Prop :=
  IsClosed {p : α × β | p.2 ∈ F p.1}

/-- **Kakutani fixed-point theorem.** Every upper-hemicontinuous
correspondence `F` from a nonempty compact convex `K ⊆ ℝᵈ` to itself, with
nonempty convex closed values, has a fixed point `x ∈ F x`. -/
@[eval_problem]
theorem kakutani_fixed_point {d : ℕ}
    {K : Set (EuclideanSpace ℝ (Fin d))}
    (_hK_compact : IsCompact K) (_hK_convex : Convex ℝ K)
    (_hK_nonempty : K.Nonempty)
    (F : EuclideanSpace ℝ (Fin d) → Set (EuclideanSpace ℝ (Fin d)))
    (_hF_uhc : IsUpperHemicontinuous F)
    (_hF_nonempty : ∀ x ∈ K, (F x).Nonempty)
    (_hF_convex : ∀ x ∈ K, Convex ℝ (F x))
    (_hF_closed : ∀ x ∈ K, IsClosed (F x))
    (_hF_maps : ∀ x ∈ K, F x ⊆ K) :
    ∃ x ∈ K, x ∈ F x := by
  sorry

end Topology
end LeanEval
