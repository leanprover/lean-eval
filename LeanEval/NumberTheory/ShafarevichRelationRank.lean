import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Shafarevich's relation-rank bound

`shafarevich_relation_rank_bound` bounds the relation rank of the Galois group
`G = Gal(F^{un,p}/F)` of the maximal unramified pro-`p` extension of a number
field `F`, for odd `p`:

```
r(G) ≤ d(G) + (r₁ + r₂ - 1) + δ_p(F),
```

where `d(G)` is the generator rank, `r(G) = dim_{𝔽_p} H²(G; 𝔽_p)` the relation
rank, `r₁`/`r₂` the number of real/complex places of `F`, and `δ_p(F) = 1` iff
`F` contains a primitive `p`-th root of unity. The bound also asserts that
`r(G)` is finite (`H2Finite`).

References: D. C. Mayer, *New number fields with known p-class tower*, Theorem
5.1 with `S = ∅`; H. Koch, *Galois Theory of p-Extensions*, Theorems 11.5 and
11.8; Shafarevich (1963).

This is the second of the two external inputs of Logical Intelligence's
formalization of the disproof of Erdős's unit-distance conjecture
(<https://github.com/logical-intelligence/erdos-unit-distance>,
`Hyp_ShafarevichRelationRankBound`), where it is taken as a hypothesis. It is
not currently available in Mathlib.

## Trusted scaffolding

Everything below the statement's data — `IsEverywhereUnramified`,
`maximalUnramifiedProPF`, `MaxUnramifiedProPGaloisGroup` (with its group and
topology instances), and the rank definitions `generatorRank`, `relationRank`,
`H2Finite` — are **trusted helper definitions** (they are not holes). They fix
the meaning of `Gal(F^{un,p}/F)`, `d(G)`, and `r(G)`, following
`ErdosUnitDistance.Defs.MaxUnramifiedProPGaloisGroup` and
`ErdosUnitDistance.Defs.ProPGroups`. A solver must prove the inequality *about
these definitions*; their correctness is part of the trusted statement.

`maximalUnramifiedProPF F p` is the compositum, inside `AlgebraicClosure F`, of
all finite Galois everywhere-unramified intermediate extensions with `p`-group
Galois group — the usual construction of the maximal unramified pro-`p`
extension.
-/

open NumberField CategoryTheory

/-- `M/F` is everywhere unramified: every nonzero prime of `𝓞 F` has
ramification index `1` in `𝓞 M`, and every real place of `F` stays real in
`M`. -/
def IsEverywhereUnramified
    (F M : Type) [Field F] [Field M] [NumberField F] [NumberField M]
    [Algebra F M] : Prop :=
  (∀ (𝔭 : Ideal (𝓞 F)) (𝔓 : Ideal (𝓞 M)),
      𝔭.IsPrime → 𝔭 ≠ ⊥ →
      𝔓 ∈ 𝔭.primesOver (𝓞 M) →
      Ideal.ramificationIdx 𝔭 𝔓 = 1) ∧
  (∀ w : NumberField.InfinitePlace F, w.IsReal →
    ∀ w' : NumberField.InfinitePlace M,
      w'.comap (algebraMap F M) = w → w'.IsReal)

/-- The maximal unramified pro-`p` extension `F^{un,p}` of `F`: the compositum
of all finite-dimensional Galois everywhere-unramified intermediate extensions
whose Galois group is a `p`-group. -/
noncomputable def maximalUnramifiedProPF
    (F : Type) [Field F] [NumberField F]
    (p : ℕ) [Fact (Nat.Prime p)] :
    IntermediateField F (AlgebraicClosure F) :=
  ⨆ (M : IntermediateField F (AlgebraicClosure F))
      (_ : FiniteDimensional F M)
      (_ : IsGalois F M)
      (_ : IsPGroup p (M ≃ₐ[F] M))
      (_ : NumberField M)
      (_ : IsEverywhereUnramified F M),
    M

/-- `Gal(F^{un,p}/F)`, the Galois group of the maximal unramified pro-`p`
extension. -/
noncomputable def MaxUnramifiedProPGaloisGroup
    (F : Type) [Field F] [NumberField F] (p : ℕ) [Fact (Nat.Prime p)] :
    Type :=
  (maximalUnramifiedProPF F p) ≃ₐ[F] (maximalUnramifiedProPF F p)

noncomputable instance MaxUnramifiedProPGaloisGroup.instGroup
    (F : Type) [Field F] [NumberField F] (p : ℕ) [Fact (Nat.Prime p)] :
    Group (MaxUnramifiedProPGaloisGroup F p) :=
  inferInstanceAs (Group ((maximalUnramifiedProPF F p) ≃ₐ[F] _))

noncomputable instance MaxUnramifiedProPGaloisGroup.instTopologicalSpace
    (F : Type) [Field F] [NumberField F] (p : ℕ) [Fact (Nat.Prime p)] :
    TopologicalSpace (MaxUnramifiedProPGaloisGroup F p) :=
  inferInstanceAs (TopologicalSpace ((maximalUnramifiedProPF F p) ≃ₐ[F] _))

instance MaxUnramifiedProPGaloisGroup.instIsTopologicalGroup
    (F : Type) [Field F] [NumberField F] (p : ℕ) [Fact (Nat.Prime p)] :
    IsTopologicalGroup (MaxUnramifiedProPGaloisGroup F p) :=
  inferInstanceAs (IsTopologicalGroup ((maximalUnramifiedProPF F p) ≃ₐ[F] _))

/-- The generator rank `d(G)`: the minimal cardinality of a (topological)
generating set of `G`. -/
noncomputable def generatorRank
    (G : Type) [Group G] [TopologicalSpace G] [IsTopologicalGroup G] : ℕ :=
  sInf {k : ℕ | ∃ S : Finset G, S.card = k ∧
    (Subgroup.closure (S : Set G)).topologicalClosure = ⊤}

/-- The trivial `ZMod p`-representation of `G`. -/
noncomputable def trivialZModpRep
    (p : ℕ) (G : Type) [Group G] [TopologicalSpace G] [IsTopologicalGroup G] :
    Action (TopModuleCat (ZMod p)) G :=
  Action.trivial G (TopModuleCat.of (ZMod p) (ZMod p))

/-- The relation rank `r(G) = dim_{𝔽_p} H²(G; 𝔽_p)`, via degree-`2` continuous
cohomology with trivial `ZMod p` coefficients. -/
noncomputable def relationRank
    (p : ℕ) [Fact p.Prime] (G : Type)
    [Group G] [TopologicalSpace G] [IsTopologicalGroup G] : ℕ :=
  Module.finrank (ZMod p)
    ((continuousCohomology (ZMod p) G 2).obj (trivialZModpRep p G))

/-- `H²(G; 𝔽_p)` is finite-dimensional, i.e. the relation rank is finite. -/
def H2Finite (p : ℕ) [Fact p.Prime] (G : Type)
    [Group G] [TopologicalSpace G] [IsTopologicalGroup G] : Prop :=
  FiniteDimensional (ZMod p)
    ((continuousCohomology (ZMod p) G 2).obj (trivialZModpRep p G))

/-- **Shafarevich's relation-rank bound** (odd `p`, empty-`S` specialization).

For a number field `F` and an odd prime `p`, with `G = Gal(F^{un,p}/F)` the
Galois group of the maximal unramified pro-`p` extension, the relation rank is
finite and

```
r(G) ≤ d(G) + (r₁ + r₂ - 1) + δ_p(F),
```

where `r₁ = nrRealPlaces F`, `r₂ = nrComplexPlaces F`, and `δ_p(F) = 1` iff `F`
contains a primitive `p`-th root of unity.

References: Mayer, Theorem 5.1 (`S = ∅`); Koch, Theorems 11.5 and 11.8. -/
@[eval_problem]
theorem shafarevich_relation_rank_bound
    (F : Type) [Field F] [NumberField F] (p : ℕ) [Fact p.Prime] (_hpOdd : Odd p) :
    H2Finite p (MaxUnramifiedProPGaloisGroup F p) ∧
      (open Classical in
       relationRank p (MaxUnramifiedProPGaloisGroup F p) ≤
        generatorRank (MaxUnramifiedProPGaloisGroup F p) +
          (NumberField.InfinitePlace.nrRealPlaces F +
            NumberField.InfinitePlace.nrComplexPlaces F - 1) +
          (if ∃ ζ : F, IsPrimitiveRoot ζ p then 1 else 0)) := by
  sorry

end NumberTheory
end LeanEval
