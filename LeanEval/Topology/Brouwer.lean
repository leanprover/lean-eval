import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Brouwer fixed-point theorem

§33 of Oliver Knill's *Some Fundamental Theorems in Mathematics* (an
additional statement in the section on game theory; Brouwer's theorem
underlies Nash's 1950 proof of equilibrium existence). Every continuous
self-map of a nonempty compact convex subset of `ℝᵈ` has a fixed point.

mathlib has the Banach fixed-point theorem (`ContractingWith.exists_fixedPoint`)
but it is strictly weaker — it requires a Lipschitz constant `< 1`.
`grep -ri brouwer` in mathlib returns only Brouwerian lattices/logics, not
the fixed-point theorem. It is theorem #36 on Freek Wiedijk's *Formalizing
100 Theorems* list and is formalized in Lean **outside mathlib** (per
mathlib's `docs/100.yaml` `links` entry), in Isabelle/AFP, HOL Light, and
Coq.
-/

open Set

/-- **Brouwer fixed-point theorem.** Every continuous self-map of a
nonempty compact convex subset of `ℝᵈ` has a fixed point. -/
@[eval_problem]
theorem brouwer_fixed_point {d : ℕ}
    {K : Set (EuclideanSpace ℝ (Fin d))}
    (_hK_compact : IsCompact K) (_hK_convex : Convex ℝ K)
    (_hK_nonempty : K.Nonempty)
    (f : EuclideanSpace ℝ (Fin d) → EuclideanSpace ℝ (Fin d))
    (_hf_cont : ContinuousOn f K) (_hf_maps : MapsTo f K K) :
    ∃ x ∈ K, f x = x := by
  sorry

end Topology
end LeanEval
