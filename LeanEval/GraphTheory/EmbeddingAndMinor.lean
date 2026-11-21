import Mathlib
import EvalTools.Markers

/-!
## Theorems in graph theory

This file states the Ringel–Youngs and four color theorems about graph embeddings in surfaces.
It also defines the graph minor relation and states the Robertson–Seymour theorem.
-/

namespace SimpleGraph

variable {V V' : Type*} (G : SimpleGraph V)

/-- The disjoint union of the vertices and one interval for each unoriented edge. -/
abbrev VertexEdgeSpace : Type _ :=
  (Σ _ : V, Unit) ⊕ (Σ _ : G.edgeSet, unitInterval)

/-- The relation identifying endpoints of edge intervals with their vertices. -/
inductive SpaceRel : G.VertexEdgeSpace → G.VertexEdgeSpace → Prop
  | fst e : SpaceRel (.inr ⟨e, 0⟩) (.inl ⟨e.1.out.1, ()⟩)
  | snd e : SpaceRel (.inr ⟨e, 1⟩) (.inl ⟨e.1.out.2, ()⟩)

/-- The topological space associated to a simple graph. -/
abbrev Space : Type _ := Quot G.SpaceRel

/-- A function is adapted to a graph if it has connected fibers.
From https://github.com/leanprover-community/mathlib4/pull/36210. -/
def Adapted (f : V → V') : Prop :=
  ∀ ⦃x y : V⦄, f x = f y → ∃ p : G.Walk x y, ∀ z ∈ p.support, f z = f x

/-- A graph `G` is a contraction of a graph `G'` if it is the image of `G'` via `SimpleGraph.map`
through a function `f` that is surjective and has connected fibers. This can in particular be used
when `f` is a quotient map with connected cosets.
From https://github.com/leanprover-community/mathlib4/pull/36210. -/
def IsContraction (G' : SimpleGraph V') : Prop :=
  ∃ φ : V' → V, φ.Surjective ∧ Adapted G' φ ∧ G = G'.map φ

/-- A graph `G` is a minor of a graph `G'` if it is a contraction of a subgraph of `G'`.
From https://github.com/leanprover-community/mathlib4/pull/36210. -/
def IsMinor (G' : SimpleGraph V') : Prop :=
  ∃ K : Subgraph G', G.IsContraction K.coe

end SimpleGraph

namespace LeanEval.GraphTheory

/-- The closed unit disc in the complex plane. -/
abbrev ClosedUnitDisc : Type := Metric.closedBall (0 : ℂ) 1

/-- The boundary point exp(2πir) on the boundary of the closed unit disc in the complex plane. -/
noncomputable def bdyPtOfReal (r : ℝ) : ClosedUnitDisc :=
  ⟨r.fourierChar, r.fourierChar.2.le⟩

/-- The representative orientable surface homeomorphic to a closed orientable genus `p`
surface with `n` discs removed, obtained by identifying the boundary of a disc in the pattern
`a₁b₁a₁⁻¹b₁⁻¹⋯aₚbₚaₚ⁻¹bₚ⁻¹c₁h₁c₁⁻¹⋯cₙhₙcₙ⁻¹`.
Same definition as in `LeanEval.Topology.ClassificationOfSurfaces`. -/
inductive OrientableRel (p n : ℕ) : ClosedUnitDisc → ClosedUnitDisc → Prop
  | a (x : unitInterval) (i : Fin p) : OrientableRel p n
      (bdyPtOfReal <| (4 * i + x) / (4 * p + 3 * n))
      (bdyPtOfReal <| (4 * i + 3 - x) / (4 * p + 3 * n))
  | b (x : unitInterval) (i : Fin p) : OrientableRel p n
      (bdyPtOfReal <| (4 * i + 1 + x) / (4 * p + 3 * n))
      (bdyPtOfReal <| (4 * i + 4 - x) / (4 * p + 3 * n))
  | c (x : unitInterval) (i : Fin n) : OrientableRel p n
      (bdyPtOfReal <| - (3 * i + x) / (4 * p + 3 * n))
      (bdyPtOfReal <| - (3 * i + 3 - x) / (4 * p + 3 * n))

/-- The representative non-orientable surface homeomorphic to a connected sum of `p` projective
planes with `n` discs removed, obtained by identifying the boundary of a disc in the pattern
`a₁a₁⋯aₚaₚc₁h₁c₁⁻¹⋯cₙhₙcₙ⁻¹`.
Same definition as in `LeanEval.Topology.ClassificationOfSurfaces`.-/
inductive NonOrientableRel (p n : ℕ) : ClosedUnitDisc → ClosedUnitDisc → Prop
  | a (x : unitInterval) (i : Fin p) : NonOrientableRel p n
      (bdyPtOfReal <| (2 * i + x) / (2 * p + 3 * n))
      (bdyPtOfReal <| (2 * i + 1 + x) / (2 * p + 3 * n))
  | c (x : unitInterval) (i : Fin n) : NonOrientableRel p n
      (bdyPtOfReal <| -(3 * i + x) / (2 * p + 3 * n))
      (bdyPtOfReal <| -(3 * i + 3 - x) / (2 * p + 3 * n))

/-- The chromatic number of a space is the supremum of the chromatic numbers of finite simple graphs
embedded in the space. -/
noncomputable def iSupChromaticNumber (X : Type*) [TopologicalSpace X] : ℕ∞ :=
  ⨆ G : Σ n : ℕ, {G : SimpleGraph (Fin n) // ∃ f : G.Space → X, Topology.IsEmbedding f},
    G.snd.1.chromaticNumber

/-- The **Ringel–Youngs theorem** (1968, formerly **Heawood conjecture**), which determines the
chromatic number of every closed surface (except the sphere, which is later work of Appel and Haken
in 1976). Allowing surfaces with boundaries (e.g. replacing `OrientableRel g 0` by
`OrientableRel g n`) should not change the chromatic number.

References:
Ringel, G. and Youngs, J. W. T. "Solution of the Heawood Map-Coloring Problem."
Proc. Nat. Acad. Sci. USA 60, 438-445, 1968.
https://en.wikipedia.org/wiki/Heawood_conjecture
https://mathworld.wolfram.com/HeawoodConjecture.html -/
@[eval_problem]
theorem ringel_youngs (g : ℕ+) :
    let γ (n : ℝ) := Nat.floor ((7 + √(48 * n + 1)) / 2)
    iSupChromaticNumber (Quot (OrientableRel g 0)) = γ g ∧
    iSupChromaticNumber (Quot (NonOrientableRel g 0)) = if g = 2 then 6 else γ (g / 2) := by
  sorry

/-- The four color theorem. See https://en.wikipedia.org/wiki/Four_color_theorem and the
Rocq proof https://github.com/rocq-community/fourcolor. -/
@[eval_problem]
theorem four_color : iSupChromaticNumber (ℝ × ℝ) = 4 := by
  sorry

/-- The type of finite simple graphs. -/
structure FiniteSimpleGraph : Type 1 where
  {Vertex : Type}
  [finite : Finite Vertex]
  graph : SimpleGraph Vertex

/-- The **Robertson–Seymour theorem**: finite simple graphs form a well-quasi-ordering under the graph
minor relationship. See https://en.wikipedia.org/wiki/Robertson%E2%80%93Seymour_theorem. -/
@[eval_problem]
theorem robertson_seymour : WellQuasiOrdered fun G H : FiniteSimpleGraph ↦ G.graph.IsMinor H.graph := by
  sorry

end LeanEval.GraphTheory
