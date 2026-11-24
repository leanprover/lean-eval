import TauCeti.Dynamics.Billiard.RotationNumber
import EvalTools.Markers

/-!
# The Birkhoff–Poritsky conjecture for centrally symmetric billiard tables

We formalise Theorem 1.1 of M. Bialy and A. E. Mironov, *The Birkhoff-Poritsky conjecture for
centrally-symmetric billiard tables*, Ann. of Math. 196 (1) (2022), no. 2,
https://doi.org/10.4007/annals.2022.196.1.2 (arXiv:2008.03566).

Let `γ` be a simple closed centrally symmetric `C²` curve of positive curvature, with the
counterclockwise orientation, and `T` the billiard ball map on the phase cylinder. Suppose `T`
has a continuous rotational invariant curve `α` of rotation number `1/4` consisting of
`4`-periodic orbits, and let `A` be the domain between `α` and the boundary `{δ = 0}` of the
phase cylinder, where `δ` is the angle between the line and the tangent. If `A` is foliated by
continuous rotational invariant curves, then `γ` is an ellipse.

## Conventions

* The table is Tau Ceti's `TauCeti.StrictConvexBilliardTable o`: an `L`-periodic unit-speed
  parametrization `χ : ℝ → E` of a strictly convex curve in an oriented Euclidean plane `E`,
  positively oriented, injective on `[0, L)`. It is `C²` (`ContDiff ℝ 2 χ`) with positive
  curvature (`χ'' ≠ 0`, the curvature of a unit-speed curve being `‖χ''‖`).
* States are written in the coordinates `(s, v)` with `v = cos δ ∈ (-1, 1)`, and the billiard
  map is lifted to `χ.nextCollision` on the strip `ℝ × (-1, 1)`. The boundary `{δ = 0}` is
  `{v = 1}`, where rotation numbers tend to `0`.
* Rotational invariant curves are taken as invariant graphs `{v = ψ(s)}` of continuous
  `L`-periodic functions (`TauCeti.StrictConvexBilliardTable.IsInvariantGraph`), with rotation
  number `TauCeti.StrictConvexBilliardTable.IsInvariantGraph.rotationNumber`. By Birkhoff's
  theorem every rotational invariant curve of the billiard map is such a graph, as the paper
  recalls in its Section 3, so this is no restriction.
* The domain `A` between `α = {v = ψ₀(s)}` and `{v = 1}` is `{(s, v) | ψ₀(s) < v < 1}`. It is
  foliated by invariant curves if it is the disjoint union of the graphs in some family of
  invariant graphs.
* An ellipse is an affine image `{c + cos θ • a + sin θ • b}` of the unit circle, with `a`, `b`
  linearly independent.
-/

open Set

noncomputable section

namespace BirkhoffPoritsky

open TauCeti

variable {E : Type} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [Fact (Module.finrank ℝ E = 2)]

/-- A set is centrally symmetric if it is invariant under the point reflection `x ↦ 2c - x` in
some centre `c`. -/
def IsCentrallySymmetric (S : Set E) : Prop :=
  ∃ c : E, ∀ x ∈ S, c - (x - c) ∈ S

/-- An ellipse in a real plane: the image of the unit circle under an injective affine map. -/
def IsEllipse (S : Set E) : Prop :=
  ∃ c a b : E, LinearIndependent ℝ ![a, b] ∧
    S = range fun θ : ℝ ↦ c + Real.cos θ • a + Real.sin θ • b

/-- **Bialy–Mironov, Theorem 1.1.** A centrally symmetric `C²` billiard table of positive
curvature, whose billiard map has an invariant curve `α = {v = ψ₀(s)}` of rotation number `1/4`
consisting of `4`-periodic orbits such that the domain between `α` and the boundary
`{δ = 0} = {v = 1}` is foliated by invariant curves, is an ellipse. -/
@[eval_problem]
theorem birkhoff_poritsky_centrally_symmetric {o : Orientation ℝ E (Fin 2)}
    (χ : StrictConvexBilliardTable o) (hχ : ContDiff ℝ 2 χ)
    (hκ : ∀ s, deriv (deriv χ) s ≠ 0)
    (hsymm : IsCentrallySymmetric (range χ))
    (ψ₀ : ℝ → ℝ) (hα : χ.IsInvariantGraph ψ₀) (hρ : hα.rotationNumber hχ = 1 / 4)
    (hper : ∀ s, ∃ k : ℤ, χ.nextCollision^[4] (s, ψ₀ s) = (s + k * χ.period, ψ₀ s))
    (hfol : ∃ F : Set (ℝ → ℝ),
      (∀ ψ ∈ F, χ.IsInvariantGraph ψ ∧ ∀ s, ψ₀ s < ψ s) ∧
      (∀ s v, ψ₀ s < v → v < 1 → ∃ ψ ∈ F, ψ s = v) ∧
      (∀ ψ ∈ F, ∀ ψ' ∈ F, ∀ s, ψ s = ψ' s → ψ = ψ')) :
    IsEllipse (range χ) := by
  sorry

end BirkhoffPoritsky
