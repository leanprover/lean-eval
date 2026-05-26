import LeanEval.Combinatorics.UnitDistance
import EvalTools.Markers

namespace LeanEval
namespace Combinatorics

/-!
# Spencer–Szemerédi–Trotter: the unit-distance graph has `O(n^{4/3})` edges

J. Spencer, E. Szemerédi, W. T. Trotter Jr., *Unit distances in the
Euclidean plane*, in Graph Theory and Combinatorics (Cambridge 1983),
Academic Press, 1984.

The naive bound `O(n^{3/2})` comes from observing that the unit-distance
graph is `K_{2,3}`-free (two unit circles meet in at most two points) and
applying Kővári–Sós–Turán. Spencer–Szemerédi–Trotter sharpened the
exponent to `4/3` by reducing to their incidence bound for points and
lines; Székely (1997) later gave a short crossing-number proof of the
same exponent. The exponent has stood since 1984 with only
constant-factor improvements (Ágoston–Pálvölgyi, 2022).
-/

open scoped Classical

/-- **Spencer–Szemerédi–Trotter (1984).** The number of unit-distance
pairs in any finite planar set is `O(n^{4/3})`: there is an absolute
constant `C > 0` such that every finite `P ⊆ ℝ²` satisfies

  `unitDist P ≤ C · |P|^{4/3}`. -/
@[eval_problem]
theorem unit_distance_upper_bound :
    ∃ C : ℝ, 0 < C ∧
      ∀ P : Finset E2, (unitDist P : ℝ) ≤ C * (P.card : ℝ) ^ ((4 : ℝ) / 3) := by
  sorry

end Combinatorics
end LeanEval
