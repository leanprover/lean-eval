import Mathlib

namespace LeanEval.ToposTheory

/-!
# The fundamental theorem of topos theory

`fundamental_topos_theory`: the slice category `E/X` of an elementary topos `E`
is again an elementary topos. The trusted helper `IsTopos` (a non-hole) bundles
the four Mathlib classes that make up "elementary topos". Mathlib has finite
limits and cartesian-monoidal structure on `Over X` and a subobject-classifier
class, but neither `MonoidalClosed (Over X)` (the locally-cartesian-closed
upgrade) nor `HasSubobjectClassifier (Over X)` — so no fundamental theorem.

Category-(b) candidate from §54 of the Knill survey.
-/


open _root_.CategoryTheory _root_.CategoryTheory.Limits

/-- An **elementary topos**: finite limits, a cartesian closed structure
(cartesian-monoidal with internal homs), and a subobject classifier. -/
def IsTopos (E : Type*) [Category E] : Prop :=
  HasFiniteLimits E ∧
  ∃ cm : CartesianMonoidalCategory E,
    (letI : MonoidalCategory E := cm.toMonoidalCategory
     Nonempty (MonoidalClosed E)) ∧
    HasSubobjectClassifier E



end LeanEval.ToposTheory
