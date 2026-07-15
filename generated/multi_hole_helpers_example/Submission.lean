import Mathlib
import Submission.Helpers
import ChallengeDeps
/-!
Regression test for the multi-hole / trusted-helpers pipeline. Exercises
four failure modes the generator used to have:

1. **Root-level helpers** (`rootHelper`) — no enclosing namespace, so the
   generator must *not* emit a spurious `open` for them.

2. **Helpers in a namespace that differs from the module's last path
   component** (`Helpers.preHole`, `Helpers.postHole`) — the injected
   `open` line must be derived from the helper names, not from
   `lastComponentStr entry.moduleName`.

3. **A helper that appears in source order *after* a hole**
   (`Helpers.postHole` between `first` and `second_eq`) — helper byte
   ranges computed from the raw source must remain valid when applied
   alongside hole-body replacement; a sequential strip-then-replace
   pipeline (with ranges derived from `.ilean`) would corrupt this case.

4. **A `structure` helper whose auto-generated companions appear in a
   hole's `sameModuleDependencies`** (`Helpers.WithCompanions.mk`,
   `Helpers.WithCompanions.value`) — companion names are not standalone
   `.ilean` entries; the helper validation accepts them iff their parent
   structure is itself a kept helper.
-/




namespace Submission

open _root_.Helpers.WithCompanions
open _root_.Helpers
namespace Helpers
def first : Nat := sorry
theorem second_eq : first + rootHelper + preHole = first + 141 := sorry
theorem third_eq : postHole + ({ value := 0 } : WithCompanions).value = 1000 := sorry

end Helpers

end Submission
