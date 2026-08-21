import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace NewlanderNirenberg

/-!
# The Newlander–Nirenberg theorem

An almost complex structure whose Nijenhuis tensor vanishes is integrable:
near every point there are local coordinates in which the structure is the
standard one on `ℂⁿ`.

The content is local, so as with Darboux's theorem the statement lives on
an open set `U ⊆ ℝ^{2n}`. An almost complex structure on `U` is a smooth field
`J : U → End(ℝ^{2n})` with `J² = -1`; its Nijenhuis tensor is

  `N(V, W) = [JV, JW] - J[JV, W] - J[V, JW] - [V, W]`,

written with mathlib's `VectorField.lieBracket`. Because `N` is tensorial it
is enough to test it on globally smooth vector fields. The conclusion produces
a holomorphic coordinate chart: a local diffeomorphism `φ` onto an open subset
of `ℂⁿ` whose differential is complex linear, `dφ ∘ J = i · dφ`. Transition
maps between two such charts are then automatically biholomorphic, so the
charts make `U` a complex manifold inducing `J`.

mathlib has the Lie bracket of vector fields, `ContDiffOn`, `fderiv`,
`EuclideanSpace` and `OpenPartialHomeomorph`, but no almost complex
structures, no Nijenhuis tensor, and no Newlander–Nirenberg theorem. No
formalization of the theorem was found in any other proof assistant.
-/

open Set
open scoped ContDiff

/-- The model space `ℝ^{2n}` carrying the almost complex structure. -/
abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin (2 * n))

/-- The **Nijenhuis tensor** of a field of endomorphisms `J` on `ℝ^{2n}`,
evaluated on two vector fields `V`, `W` at a point:

  `N(V, W) = [JV, JW] - J[JV, W] - J[V, JW] - [V, W]`.

For an almost complex structure the last term is `J²[V, W]`, so this is the
usual torsion of `J`. When `U` is open and `IsAlmostComplexOn J U` holds, the
expression is `C^∞(U)`-bilinear in `V` and `W` on `U`: the terms involving the
derivatives of `V` and `W` cancel using `J² = -1`, so the value at a point of
`U` depends only on `V x`, `W x` and the derivative of `J` there. -/
noncomputable def nijenhuis {n : ℕ} (J : E n → E n →L[ℝ] E n)
    (V W : E n → E n) (x : E n) : E n :=
  VectorField.lieBracket ℝ (fun y ↦ J y (V y)) (fun y ↦ J y (W y)) x
    - J x (VectorField.lieBracket ℝ (fun y ↦ J y (V y)) W x)
    - J x (VectorField.lieBracket ℝ V (fun y ↦ J y (W y)) x)
    - VectorField.lieBracket ℝ V W x

/-- `J` is an **almost complex structure** on an open set `U ⊆ ℝ^{2n}` if it
is a smooth field of endomorphisms on `U` squaring to `-1`. -/
def IsAlmostComplexOn {n : ℕ} (J : E n → E n →L[ℝ] E n) (U : Set (E n)) : Prop :=
  ContDiffOn ℝ ∞ J U ∧ ∀ x ∈ U, ∀ v : E n, J x (J x v) = -v

/-- The Nijenhuis tensor of `J` vanishes on `U`. This is stated for all
globally smooth vector fields, which is the textbook hypothesis. Whenever `U`
is open and `IsAlmostComplexOn J U` holds it is equivalent to the pointwise
condition: the tensor is bilinear over functions, and constant vector fields
already realize every pair of tangent vectors. -/
def NijenhuisVanishesOn {n : ℕ} (J : E n → E n →L[ℝ] E n) (U : Set (E n)) : Prop :=
  ∀ V W : E n → E n, ContDiff ℝ ∞ V → ContDiff ℝ ∞ W →
    ∀ x ∈ U, nijenhuis J V W x = 0

/-- **The Newlander–Nirenberg theorem.** An almost complex structure with
vanishing Nijenhuis tensor is integrable. Formally: for every `x` in an open
set `U ⊆ ℝ^{2n}` carrying such a structure `J` there is a smooth local
diffeomorphism `φ` (an `OpenPartialHomeomorph`, smooth in both directions)
from a neighbourhood of `x` inside `U` onto an open subset of `ℂⁿ` whose
differential is complex linear:

  `dφ_y (J y v) = i · dφ_y v`.

Such charts are holomorphic coordinates for `J`. -/
@[eval_problem]
theorem newlander_nirenberg {n : ℕ} {U : Set (E n)} (_hU : IsOpen U)
    (J : E n → E n →L[ℝ] E n) (_hJ : IsAlmostComplexOn J U)
    (_hN : NijenhuisVanishesOn J U) {x : E n} (_hx : x ∈ U) :
    ∃ φ : OpenPartialHomeomorph (E n) (EuclideanSpace ℂ (Fin n)),
      x ∈ φ.source ∧ φ.source ⊆ U ∧
      ContDiffOn ℝ ∞ (φ : E n → EuclideanSpace ℂ (Fin n)) φ.source ∧
      ContDiffOn ℝ ∞ (φ.symm : EuclideanSpace ℂ (Fin n) → E n) φ.target ∧
      ∀ y ∈ φ.source, ∀ v : E n,
        fderiv ℝ (φ : E n → EuclideanSpace ℂ (Fin n)) y (J y v)
          = Complex.I • fderiv ℝ (φ : E n → EuclideanSpace ℂ (Fin n)) y v := by
  sorry

end NewlanderNirenberg
end Geometry
end LeanEval
