import Mathlib
import Submission
/-!
Minimal example exercising `instance` holes in the multi-hole
eval-problem pipeline. The carrier type is itself a hole so the source
has no non-hole declarations and the generator does not need a
`ChallengeDeps` split.
-/

@[reducible] noncomputable def WidgetCarrier : Type := Submission.WidgetCarrier

@[reducible] noncomputable instance instInhabitedWidget : Inhabited WidgetCarrier := Submission.instInhabitedWidget
