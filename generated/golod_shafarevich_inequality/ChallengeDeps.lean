import Mathlib

namespace LeanEval
namespace GroupTheory

/-!
# The Golod–Shafarevich inequality

`golod_shafarevich_inequality` is the Golod–Shafarevich inequality for finite
`p`-groups: for a nontrivial finite `p`-group `Q`,

```
d(Q) ^ 2 < 4 r(Q),
```

where `d(Q)` is the generator rank (minimal size of a generating set) and
`r(Q)` is the relation rank (`𝔽_p`-dimension of `H²(Q; 𝔽_p)`).

References: NSW (Neukirch–Schmidt–Wingberg, *Cohomology of Number Fields*),
Theorem 3.9.7; Serre, *Galois Cohomology*, Chapter I, Appendix 2, Theorem 1.

This is one of the two external inputs of Logical Intelligence's formalization
of the disproof of Erdős's unit-distance conjecture
(<https://github.com/logical-intelligence/erdos-unit-distance>,
`Hyp_GolodShafarevichInequality`), where it is taken as a hypothesis. It is not
currently available in Mathlib.

The two helper definitions `generatorRank` and `relationRank` below are trusted
(they are not holes); they fix the meaning of `d(Q)` and `r(Q)`. A finite
`p`-group is viewed as a topological group with the discrete topology, so that
topological generation agrees with ordinary generation and continuous
cohomology agrees with ordinary group cohomology. These definitions follow
`ErdosUnitDistance.Defs.ProPGroups`.
-/

open CategoryTheory

/-- The generator rank `d(G)`: the minimal cardinality of a (topological)
generating set of `G`. For a finite discrete group this is the ordinary minimal
number of generators. -/
noncomputable def generatorRank
    (G : Type) [Group G] [TopologicalSpace G] [IsTopologicalGroup G] : ℕ :=
  sInf {k : ℕ | ∃ S : Finset G, S.card = k ∧
    (Subgroup.closure (S : Set G)).topologicalClosure = ⊤}

/-- The trivial `ZMod p`-representation of `G`, as an object of
`Action (TopModuleCat (ZMod p)) G`. -/
noncomputable def trivialZModpRep
    (p : ℕ) (G : Type) [Group G] [TopologicalSpace G] [IsTopologicalGroup G] :
    Action (TopModuleCat (ZMod p)) G :=
  Action.trivial G (TopModuleCat.of (ZMod p) (ZMod p))

/-- The relation rank `r(G) = dim_{𝔽_p} H²(G; 𝔽_p)`, computed via continuous
cohomology in degree `2` with trivial `ZMod p` coefficients. -/
noncomputable def relationRank
    (p : ℕ) [Fact p.Prime] (G : Type)
    [Group G] [TopologicalSpace G] [IsTopologicalGroup G] : ℕ :=
  Module.finrank (ZMod p)
    ((continuousCohomology (ZMod p) G 2).obj (trivialZModpRep p G))



end GroupTheory
end LeanEval
