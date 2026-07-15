import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.Complex.UpperHalfPlane.Manifold
import Mathlib.Geometry.Manifold.Diffeomorph
import EvalTools.Markers

/-!
# Uniformization theorem for Riemann surfaces

The usual statement of the uniformization theorem says that a simply connected Riemann surface
is isomorphic to either the Riemann sphere, the complex plane, or the open unit disc
[Hubbard, Theorem 1.1.1]. Since we do not have Riemann sphere in mathlib yet, here we instead
formalize the statement of Theorem 1.1.2, which Hubbard shows is stronger than Theorem 1.1.1
using one page of algebraic topology and complex analysis. The statement is:

If a Riemann surface `X` is connected and noncompact and its cohomology satisfies H¹(X,ℝ)=0,
then it is isomorphic either to the complex plane or to the open unit disc.

Since mathlib does not have singular cohomology yet, we write H¹(X,ℝ) as Hom(π₁(X),ℝ),
which as Hubbard remarks is valid for connected topological spaces.
We also replace the open unit disc by the upper half plane, because the latter already
has a Riemann surface structure in mathlib while the former does not.

Hubbard devotes §1.2–1.7 (15 pages) to proving this statement. §1.3 is devoted to Radó's
theorem (Riemann surfaces are second-countable), which is another LeanEval problem
(`LeanEval.Geometry.rado_riemannSurface`). To avoid the overlap, we assume the
Riemann surface is second countable in our statement here.

[AnghelStan] presents a self-contained proof of the a priori weaker statement that every
non-compact simply-connected Riemann surface is biholomorphic to a domain in ℂ. The proof
uses Sard's lemma together with the Riemann mapping theorem to circumvent certain prerequisites
in the proof in [Hubbard]. Full Lean proofs of the Riemann mapping theorem can be found in
https://github.com/vbeffara/RMT4/ or https://github.com/leanprover-community/mathlib4/pull/33505.

Reference:
[Hubbard] John Hamal Hubbard, *Teichmüller theory and applications to geometry, topology, and dynamics. Vol. 1*
[AnghelStan] Cipriana Anghel, Rares Stan, *Uniformization of Riemann surfaces revisited*, https://arxiv.org/abs/2008.12189
-/

namespace LeanEval.Geometry

noncomputable abbrev mℂ := modelWithCornersSelf ℂ ℂ

open scoped Manifold ContDiff

variable {X : Type*} [TopologicalSpace X] [T2Space X] [ConnectedSpace X]
variable [SecondCountableTopology X] [ChartedSpace ℂ X] [IsManifold mℂ 1 X]

@[eval_problem]
theorem uniformization_key (hX : ¬ CompactSpace X) [SimplyConnectedSpace X] :
    ∃ D : TopologicalSpace.Opens ℂ, Nonempty (X ≃ₘ⟮mℂ, mℂ⟯ D) := by
  sorry

@[eval_problem]
theorem uniformization (hX : ¬ CompactSpace X) (x : X)
    [Subsingleton <| Additive (FundamentalGroup X x) →+ ℝ] :
    Nonempty (X ≃ₘ⟮mℂ, mℂ⟯ ℂ) ∨ Nonempty (X ≃ₘ⟮mℂ, mℂ⟯ UpperHalfPlane) := by
  sorry

end LeanEval.Geometry
