import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Normed.Algebra.Spectrum
import Mathlib.Combinatorics.SimpleGraph.AdjMatrix
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Equiangular lines with a fixed angle

We formalise the statement of the main result from Z. Jiang, J. Tidor, Y. Yao, S. Zhang, and
Y. Zhao, `Equiangular lines with a fixed angle`, Annals of Math, 194 (3) 2021.
-/

set_option autoImplicit false

namespace EquiangularLinesFixedAngle

open Filter

open scoped RealInnerProductSpace

/-- A set of unit vectors in `d`-dimensional euclidean space with pairwise inner product `±α`.
See the third paragraph of the introduction. -/
structure EquiangularLines (α : ℝ) (d : ℕ) where
  /-- The set of unit vectors in `d`-dimensional Euclidean space. -/
  carrier : Set (EuclideanSpace ℝ (Fin d))
  norm : ∀ x ∈ carrier, ‖x‖ = 1
  angle : carrier.Pairwise fun x y ↦ |⟪x, y⟫| = α

/-- The maximum number of lines in `d`-dimensional euclidean space through the origin with
pairwise angle `arccos(α)`. See the third paragraph of the introduction. We take the
supremum in `ℕ` here. Note that the carrier sets `E.carrier` are bounded above since
`N_α(d) ≤ binom(d+1,2)` by Gerzon (also mentioned in the introduction). -/
noncomputable def N (α : ℝ) (d : ℕ) : ℕ := ⨆ E : EquiangularLines α d, E.carrier.ncard

open Classical in
/-- The spectral radius order of a positive real number. See Definition 1.1. -/
noncomputable def spectralRadiusOrder (lambda : ℝ) : ℕ∞ :=
  ⨅ k ∈ {k : ℕ | ∃ G : SimpleGraph (Fin k), spectralRadius ℝ (G.adjMatrix ℝ) = .ofReal lambda}, k

/-
Note that if `λ > 0` then `spectralRadiusOrder λ` cannot be `0` or `1`, because the spectral
radius of the adjacency matrix of any graph with no edges is `0`. So our subtractions
and divisions below are not pathological.
-/



end EquiangularLinesFixedAngle
