import Mathlib
/-!
Minimal example exercising `noncomputable` data holes in the multi-hole
eval-problem pipeline. Honest solutions to data holes are frequently
noncomputable (`genus` in the Jacobian challenge is the motivating case),
so the generated `Solution.lean` delegations must themselves be
`noncomputable` to compile against such a submission. The `noncomputable`
modifiers on the holes below additionally exercise folding an existing
modifier into the rewritten signature: Lean's grammar puts attributes
before `noncomputable`, so a naive `@[reducible]` injection at the
declaration keyword would produce invalid syntax.
-/
def RWidget : Type := sorry
noncomputable instance instInhabitedRWidget : Inhabited RWidget := sorry
noncomputable def rwidgetPoint : RWidget := sorry
theorem rwidgetPoint_default : rwidgetPoint = (default : RWidget) := sorry
