/-
Copyright (c) 2026 Justus Springer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Justus Springer
-/

import Mathlib.Algebra.Field.ZMod
import Mathlib.Combinatorics.SimpleGraph.Density
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Data.Real.Basic
import Mathlib.Data.SetLike.Fintype
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.Order.Filter.AtTopBot.Defs
import EvalTools.Markers

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

open Classical in
/--
Statement of Theorem 1.12:

For every constant `0 < α < 1`, there exist a constant `ε > 0` and an
integer `r ≥ 0` such that for all sufficiently large integers `ℓ` and (after fixing it)
for all sufficiently large integers `k`, the following holds. Let `S ⊆ Grₖₗ` be such that
`Φ(S) ≤ α`. Then there exist subspaces `A ⊆ B ⊆ 𝔽₂ᵏ` such that `dim(A) = a`, `codim(B) = b`,
`a + b ≤ r` and `|S ∩ Grₖₗ[A,B]| / |Grₖₗ[A,B]| ≥ ε`.
-/
@[eval_problem]
theorem theorem_1_12 (α : ℝ) (hα : α ∈ Set.Ioo 0 1) :
    ∃ ε > 0, ∃ r, ∀ᶠ (ℓ : ℕ) (k : ℕ) in atTop, ∀ S : Finset (GrVertex k ℓ),
      (hS : S.Nonempty) → 2 * #S ≤ Fintype.card (GrVertex k ℓ) →
        Φ (Gr k ℓ) S hS ≤ α → ∃ (A B : Submodule 𝔽₂ (Fin k → 𝔽₂)), A ≤ B ∧
          letI a := finrank 𝔽₂ A; letI b := k - finrank 𝔽₂ B
          a + b ≤ r ∧ #(S ∩ SubGr k ℓ A B) / #(SubGr k ℓ A B) ≥ (ε : ℝ) := by
  sorry

end PseudorandomGrassmann
