import Mathlib.Geometry.Manifold.Diffeomorph
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Geometry.Manifold.Instances.Real
import Mathlib.Geometry.Manifold.IsManifold.InteriorBoundary
import Mathlib.LinearAlgebra.UnitaryGroup
import EvalTools.Markers

namespace LeanEval
namespace Topology

open scoped Manifold ContDiff
open Metric (sphere)

/-!
# Watanabe's disproof of the 4-dimensional Smale conjecture, `[Kir97, Problems 4.34 and 4.126]`

The 4-dimensional generalized Smale conjecture asks whether the inclusion
`O(5) ↪ Diff(S⁴)` (restriction of the linear action on `ℝ⁵`) is a homotopy
equivalence — equivalently, whether `Diff(D⁴ rel ∂)` is contractible. Watanabe
(*Some exotic nontrivial elements of the rational homotopy groups of
`Diff(S⁴)`*, 2018) disproved it, showing `πₖ(Diff(D⁴ rel ∂)) ⊗ ℚ ≠ 0` for many
`k` (including `k = 1`), via configuration-space integrals.

This is the exact negation of the four-dimensional analogue of the (positive)
Smale conjecture for `S³` stated in `SmaleConjecture.lean`. That file states the
relative parameterized form of `O(4) ↪ Diff(S³)` being a homotopy equivalence —
the form Mathlib can express today, since it has no `C^∞` topology on
`Diffeomorph M N`. Here we bump `S³ ⤳ S⁴` and `O(4) ⤳ O(5)` and assert the
**negation**: the parameterized homotopy-equivalence statement for `S⁴` and
`O(5)` is false. Its inner statement reads: for every compact smooth
manifold-with-boundary `X` and every smooth family `F` of self-diffeomorphisms
of `S⁴` whose boundary restriction factors through the linear action of `O(5)`,
there is a smooth isotopy of `F`, rel `∂X`, to a family fully factoring through
`O(5)`. Taking `X = Sᵏ` (closed, so the boundary hypotheses are vacuous) this is
`πₖ(Diff(S⁴), O(5)) = 0`; Watanabe's nontriviality of `Diff(D⁴ rel ∂)` makes it
fail, which is exactly what the `¬` below records.

As in `SmaleConjecture.lean`, the translation between smooth families
parameterized by `X` and continuous maps into `Diff(S⁴)` with the `C^∞` topology
is the standard smoothing-theory dictionary; once Mathlib has that topology this
should be restated as "`O(5) ↪ Diff(S⁴)` is not a homotopy equivalence".
-/

/-- **Watanabe's theorem (2018): the 4-dimensional Smale conjecture is false**,
answering `[Kir97, Problems 4.34 and 4.126]`. The relative parameterized
statement that `O(5) ↪ Diff(S⁴)` is a homotopy equivalence — the exact
four-dimensional analogue of the (true) Smale conjecture for `S³` — does not
hold. -/
@[eval_problem]
theorem watanabe_four_dim_smale_disproof :
    ¬ (∀ {n : ℕ} [NeZero n]
        (X : Type) [TopologicalSpace X] [T2Space X] [SecondCountableTopology X]
        [ChartedSpace (EuclideanHalfSpace n) X] [IsManifold (𝓡∂ n) ∞ X]
        [CompactSpace X]
        (F F' : X × sphere (0 : EuclideanSpace ℝ (Fin 5)) 1 →
                sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
        ContMDiff ((𝓡∂ n).prod (𝓡 4)) (𝓡 4) ∞ F →
        ContMDiff ((𝓡∂ n).prod (𝓡 4)) (𝓡 4) ∞ F' →
        (∀ x p, F  (x, F' (x, p)) = p) →
        (∀ x p, F' (x, F  (x, p)) = p) →
        ∀ (ψ_bdry : (𝓡∂ n).boundary X → Matrix.orthogonalGroup (Fin 5) ℝ),
        Continuous ψ_bdry →
        (∀ (b : (𝓡∂ n).boundary X)
           (p : sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
              (F ((b : X), p) : EuclideanSpace ℝ (Fin 5)) =
                Matrix.UnitaryGroup.toLinearEquiv (ψ_bdry b)
                  (p : EuclideanSpace ℝ (Fin 5))) →
        ∃ (ψ : X → Matrix.orthogonalGroup (Fin 5) ℝ)
          (H H' : X × unitInterval × sphere (0 : EuclideanSpace ℝ (Fin 5)) 1 →
                  sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
          Continuous ψ ∧
          (∀ b : (𝓡∂ n).boundary X, ψ (b : X) = ψ_bdry b) ∧
          ContMDiff ((𝓡∂ n).prod ((𝓡∂ 1).prod (𝓡 4))) (𝓡 4) ∞ H ∧
          ContMDiff ((𝓡∂ n).prod ((𝓡∂ 1).prod (𝓡 4))) (𝓡 4) ∞ H' ∧
          (∀ x t p, H  (x, t, H' (x, t, p)) = p) ∧
          (∀ x t p, H' (x, t, H  (x, t, p)) = p) ∧
          (∀ x p, H (x, 0, p) = F (x, p)) ∧
          (∀ x (p : sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
              (H (x, 1, p) : EuclideanSpace ℝ (Fin 5)) =
              Matrix.UnitaryGroup.toLinearEquiv (ψ x)
                (p : EuclideanSpace ℝ (Fin 5))) ∧
          (∀ (b : (𝓡∂ n).boundary X)
             (t : unitInterval)
             (p : sphere (0 : EuclideanSpace ℝ (Fin 5)) 1),
              H ((b : X), t, p) = F ((b : X), p))) := by
  sorry

end Topology
end LeanEval
