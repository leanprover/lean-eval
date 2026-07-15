import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Schauder fixed-point theorem (Juliusz Schauder, 1930)

§60 of Knill's *Some Fundamental Theorems in Mathematics* (additional
statement). The Banach-space generalization of Brouwer: every continuous
self-map of a nonempty compact convex subset of a real Banach space has
a fixed point. Stated with `NormedAddCommGroup` + `NormedSpace ℝ` +
`CompleteSpace` (the canonical decomposition of "Banach space" in
mathlib); the `CompleteSpace` hypothesis is what distinguishes this
from the general normed-space statement.

Mathlib has `NormedAddCommGroup`, `NormedSpace`, `CompleteSpace`,
`IsCompact`, `Convex ℝ`, `ContinuousOn`, `MapsTo`, and
`ContractingWith.exists_fixedPoint` (Banach's contraction principle, a
strictly weaker fixed-point theorem). But **no Schauder fixed-point
theorem** — `grep -ri 'Schauder.*fixed\|fixed.*Schauder' Mathlib/`
returns nothing. (`SchauderBasis` / `GeneralSchauderBasis` are present
but they are different: Schauder bases are about sequences spanning a
Banach space, not fixed points.)

No open mathlib PR for Schauder (`gh search prs` returns no hits as of
2026-05-24). The Sperner → Brouwer → Schauder dependency chain is
partially in motion in mathlib: Sperner foundations partly landed; open
PR https://github.com/leanprover-community/mathlib4/pull/36770 uses
Brouwer to prove invariance of domain (so Brouwer itself is in flight).
Schauder is the next step in that chain and there is active downstream
demand from the PDE community (cf. Nelson Spence's 2026-03-06 Zulip
thread requesting Schauder / Schaefer / Leray–Schauder machinery for
elliptic-existence formalizations).

Stateable with zero new definitions.
-/

/-- **Schauder fixed-point theorem.** Every continuous self-map of a
nonempty compact convex subset of a real Banach space has a fixed
point. -/
@[eval_problem]
theorem schauder_fixed_point {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    {K : Set E}
    (_hK_compact : IsCompact K) (_hK_convex : Convex ℝ K)
    (_hK_nonempty : K.Nonempty)
    (f : E → E)
    (_hf_cont : ContinuousOn f K) (_hf_maps : Set.MapsTo f K K) :
    ∃ x ∈ K, f x = x := by
  sorry

end Topology
end LeanEval
