import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# Fitting's theorem

Let `G` be a group and `H`, `K` two normal nilpotent subgroups of `G`.
Then `H ⊔ K`, the subgroup they generate, is again nilpotent. Equivalently,
the *Fitting subgroup* `F(G) := ⊔ {N : Subgroup G | N.Normal ∧ IsNilpotent N}`
is nilpotent — at least for finite groups, where the supremum is a finite
join.

H. Fitting, "Beiträge zur Theorie der Gruppen endlicher Ordnung",
Jahresbericht der Deutschen Mathematiker-Vereinigung 48 (1938), 77-141.
A foundational structural result: it justifies talking about *the*
maximal normal nilpotent subgroup of a finite group. In CFSG the
Fitting subgroup plays a basic role in local analysis, e.g. through the
generalised Fitting subgroup `F*(G) = F(G) · E(G)` (Bender 1971).

Statement: two-subgroup form, valid for arbitrary groups (the finite-group
hypothesis is unnecessary in this form, since two normal nilpotent
subgroups always generate a nilpotent subgroup, with class bounded by the
sum of classes).
-/

/-- **Fitting's theorem.** The join of two normal nilpotent subgroups is
nilpotent. -/
@[eval_problem]
theorem fitting {G : Type*} [Group G]
    (H K : Subgroup G) [H.Normal] [K.Normal]
    [Group.IsNilpotent H] [Group.IsNilpotent K] :
    Group.IsNilpotent (H ⊔ K : Subgroup G) := by
  sorry

end GroupTheory
end LeanEval
