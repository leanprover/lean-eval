import Mathlib.Order.Lattice.Nat
import Mathlib.Data.Set.Card
import Mathlib.Order.Filter.AtTopBot.Defs
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from A proof of the Erdős–Faber–Lovász conjecture

We formalise the statement of the main result from D. Y. Kang, T. Kelly, D. Kühn, A. Methuku, and
D. Osthus, `A proof of the Erdős–Faber–Lovász conjecture`, Annals of Math, 198 (2) 2023.
-/

set_option autoImplicit false

namespace ErdosFaberLovaszConjecture

open Filter

variable {V : Type*}

/-- We define a `Hypergraph` on a type of vertices `V` to be a set of sets of `V`
(an edge of a `Hypergraph` is a subset of `V`). -/
abbrev Hypergraph (V : Type*) := Set (Set V)

/-- An `α`-coloring of a hypergraph `𝓗` is a map from the edges of `𝓗` (its elements)
to `α`, such that any two distinct edges which share a vertex are mapped to distinct colors. -/
structure Hypergraph.Coloring (α : Type*) (𝓗 : Hypergraph V) where
  /-- The labeling of a hypergraph coloring. -/
  labels : 𝓗 → α
  isColoring (e₁ e₂ : 𝓗) (h : e₁ ≠ e₂) (h' : (e₁ ∩ e₂ : Set V).Nonempty) : labels e₁ ≠ labels e₂

/-- We say that a hypergraph `𝓗` is linear if any two distinct edges share at most one vertex. -/
def Hypergraph.IsLinear (𝓗 : Hypergraph V) :=
  𝓗.Pairwise fun e₁ e₂ ↦ (e₁ ∩ e₂).Subsingleton

/-- We define the chromatic index of a hypergraph `𝓗` to be the smallest natural number `n` such
that there exists a `(Fin n)`-coloring of `𝓗` (a coloring using `n` colors). -/
noncomputable def Hypergraph.chromaticIndex (𝓗 : Hypergraph V) : ℕ :=
  sInf {n : ℕ | Nonempty (𝓗.Coloring (Fin n))}



end ErdosFaberLovaszConjecture
