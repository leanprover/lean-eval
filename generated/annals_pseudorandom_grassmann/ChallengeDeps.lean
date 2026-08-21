import Mathlib.Algebra.Field.ZMod
import Mathlib.Combinatorics.SimpleGraph.Density
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Data.Real.Basic
import Mathlib.Data.SetLike.Fintype
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.Order.Filter.AtTopBot.Defs
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Pseudorandom sets in Grassmann graph have near-perfect expansion

We formalise the statement of the main result from S. Khot, D. Minzer, and M. Safra,
`Pseudorandom sets in Grassmann graph have near-perfect expansion`, Annals of Math, 198 (1) 2023.
-/

set_option autoImplicit false

namespace PseudorandomGrassmann

open Module Finset Filter

local notation "𝔽₂" => ZMod 2

/-- The vertex type of the Grassmann graph `Grₖₗ`: the `ℓ`-dimensional subspaces of `𝔽₂ᵏ`. -/
abbrev GrVertex (k ℓ : ℕ) : Type :=
  {L : Submodule 𝔽₂ (Fin k → 𝔽₂) // finrank 𝔽₂ L = ℓ}

/-- The Grassmann graph `Grₖₗ`: vertices are `ℓ`-dimensional subspaces of `𝔽₂ᵏ`,
and two subspaces are adjacent when their intersection has dimension `ℓ - 1`. -/
def Gr (k ℓ : ℕ) : SimpleGraph (GrVertex k ℓ) :=
  .fromRel (fun L L' ↦ finrank 𝔽₂ (L.val ⊓ L'.val :) = ℓ - 1)

open Classical in
/-- The subset of vertices `Grₖₗ[A,B] = {L | A ⊆ L ⊆ B}`, where `A, B ⊆ 𝔽₂ᵏ` are subspaces.
See page 13 of the paper. -/
noncomputable def SubGr (k ℓ : ℕ) (A B : Submodule 𝔽₂ (Fin k → 𝔽₂)) : Finset (GrVertex k ℓ) :=
  {L | A ≤ L ∧ L ≤ B}

open Classical in
/-- Definition 1.8 from the paper: Let `G = (V,E)` be an `n`-vertex, `d`-regular graph.
For a non-empty set of vertices `S ⊆ V` with `|S| ≤ n/2`, its (edge-)expansion is defined
as `Φ(S) = |E(S,S̄)| / (d·|S|)`, where `E(S,S̄)` denotes the set of edges with one endpoint
in S and the other in `S̄ = V\S`.
In Lean, we don't require the conditions `d`-regular and `|S| ≤ n/2` for this definition.
However, we need `S` nonempty to define the degree `d` as the degree of an arbitrary element
of `S`. Note that this only gives the correct definition for regular graphs. -/
noncomputable def Φ {V : Type*} [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj]
    (S : Finset V) (h : S.Nonempty) : ℚ :=
  #(G.interedges S Sᶜ) / (G.degree h.choose * #S)



end PseudorandomGrassmann
