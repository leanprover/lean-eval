import Mathlib
import EvalTools.Markers

/-!
## Theorems in graph theory

This file states four theorems about embedding of graphs in surfaces:
the Ringel–Youngs theorem, the four color theorem, Wagner's theorem, and Kuratowski's theorem.
Finiteness assumptions in these theorems are probably unnecessary.

It also defines the graph minor relation and state the Robertson–Seymour theorem.
-/

namespace SimpleGraph

section Sigma

variable {ι : Type*} {V : ι → Type*} (G : Π i, SimpleGraph (V i))

/-- The binary relation underlying a disjoint union of simple graphs. -/
inductive SigmaRel : (Σ i, V i) → (Σ i, V i) → Prop
  | mk {i : ι} {v w : V i} (h : (G i).Adj v w) : SigmaRel (.mk i v) (.mk i w)

/-- The disjoint union of simple graphs. -/
def sigma : SimpleGraph (Σ i, V i) where
  Adj := SigmaRel G
  symm := ⟨fun _ _ ↦ by rintro ⟨⟩; tauto⟩
  loopless := ⟨fun _ ↦ by rintro ⟨h⟩; exact (G _).loopless.1 _ h⟩

end Sigma

variable {V V' : Type*} (G : SimpleGraph V) (G' : SimpleGraph V')

/-- The disjoint union of vertices and edges of a simple graph (every edge appears twice in
opposite orientation). -/
abbrev VertexEdgeSpace : Type _ :=
  (Σ _ : V, Unit) ⊕ (Σ _ : G.edgeSet, unitInterval)

/-- The relation identifying repeated edges and endpoints of edges with vertices. -/
inductive SpaceRel : G.VertexEdgeSpace → G.VertexEdgeSpace → Prop
  | fst e : SpaceRel (.inr ⟨e, 0⟩) (.inl ⟨e.1.out.1, ()⟩)
  | snd e : SpaceRel (.inr ⟨e, 1⟩) (.inl ⟨e.1.out.2, ()⟩)

/-- The topological space associated to a simple graph. -/
abbrev Space : Type _ := Quot G.SpaceRel

/-- A simple graph is planar if it can be embedded into the plane. -/
def Planar : Prop := ∃ f : G.Space → ℝ × ℝ, Topology.IsEmbedding f

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

variable {G} (n : G.edgeSet → ℕ)

/-- To subdivide a simple graph, we assign a natural number nₑ to each edge `e` of the graph, and
divide the edge `e` into a path of length `nₑ + 1` (`nₑ = 0` means that the edge is not subdivided,
and the `nₑ = -1` case can be used to define contraction).
The subdivided graph can be obtained by identifying vertices of the disjoint union of the original
graph (with all edges removed) together with one path graph (on `Fin (nₑ + 2)`) for each edge `e`
of the original graph. `SubdivideType n` is the vertex type of the disjoint union. -/
def SubdivideType : Type _ := V ⊕ Σ e : G.edgeSet, Fin (n e + 2)

/-- The relation to identify vertices of the disjoint union. -/
inductive SubdivideRel : SubdivideType n → SubdivideType n → Prop
  | fst e : SubdivideRel (.inr ⟨e, 0⟩) (.inl e.1.out.fst)
  | snd e : SubdivideRel (.inr ⟨e, .last _⟩) (.inl e.1.out.snd)

/-- The subdivided simple graph. -/
def subdivide : SimpleGraph (Quot (SubdivideRel n)) :=
  .map (Quot.mk _) <| .sum ⊥ <| .sigma fun _ ↦ .pathGraph _

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

/-- The **Ringle–Youngs theorem** (1068, formerly **Heawood conjecture**), which determines the
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

/-- The complete graph K₅. -/
abbrev K5 : SimpleGraph (Fin 5) := .completeGraph _

/-- The complete bipartite graph K_{3,3}. -/
abbrev K33 : SimpleGraph (Fin 3 ⊕ Fin 3) := completeBipartiteGraph ..

/--
**Kuratowski's theorem**: a (finite simple) graph is planar iff it does not contain a subgraph
that is a subdivision of K₅ or K_{3,3}.

**Wagner's theorem**: a (finite simple) graph is planar iff it does not contain K₅ or K_{3,3}
as a minor. Reference: Wagner, K. "Über eine Eigenschaft der ebenen Komplexe."
Math. Ann. 114, 570-590, 1937.

According to https://en.wikipedia.org/wiki/Kuratowski%27s_theorem, both theorems are equivalent. -/
@[eval_problem]
theorem wagner_kuratowski {V : Type*} (G : SimpleGraph V) [Finite V] :
    List.TFAE
    [ G.Planar, ¬ K5.IsMinor G ∧ ¬ K33.IsMinor G,
      ∀ (S : G.Subgraph) (n5 : K5.edgeSet → ℕ) (n33 : K33.edgeSet → ℕ),
        IsEmpty (K5.Iso S.coe) ∧ IsEmpty (K33.Iso S.coe) ] := by
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
