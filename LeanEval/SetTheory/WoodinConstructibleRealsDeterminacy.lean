import Mathlib
import EvalTools.Markers

open Cardinal FirstOrder Ordinal Set

namespace LeanEval
namespace SetTheory

universe u

/-!
# Woodin's Theorem on the Axiom of Determinacy in $L(\mathbb{R})$

W. Hugh Woodin (1988, *Supercompact cardinals, sets of reals, and weakly
homogeneous trees*, *Proc. Natl. Acad. Sci. USA* 85, 6587–6591; building on
Martin–Steel 1989, *J. Amer. Math. Soc.* 2, 71–125, and refined to the sharp
hypothesis of $\omega$ Woodin cardinals below a measurable cardinal — see
Larson, *The Stationary Tower*, AMS Univ. Lecture Ser. 32, 2004, and Steel,
*An Outline of Inner Model Theory*, in *Handbook of Set Theory*, Springer,
2010) proved that if there exist infinitely many Woodin cardinals
$\delta_0 < \delta_1 < \cdots$ whose supremum lies strictly below a measurable
cardinal $\kappa$, then Gödel's inner model $L(\mathbb{R})$ (constructed from
$V_{\omega + 1}$ by iterating first-order definability along the ordinals)
satisfies the Axiom of Determinacy ($\mathrm{AD}^{L(\mathbb{R})}$): every game
on $\mathbb{N}$ whose payoff set $A \subseteq \mathbb{N}^{\mathbb{N}}$ belongs
to $L(\mathbb{R})$ admits a winning strategy in $L(\mathbb{R})$ for either
Player I or Player II.

Stated purely in Mathlib.
-/

namespace WoodinConstructibleRealsDeterminacy

/-- The first-order language of set theory $\{\in\}$. -/
def setLang : FirstOrder.Language.{0, 0} where
  Functions _ := Empty
  Relations
    | 2 => PUnit
    | _ => Empty

/-- Any class $M \subseteq V$ of ZFC sets is a `setLang`-structure under `∈`. -/
instance instSetLangStructure (M : Set ZFSet.{u}) : setLang.Structure M where
  funMap f := f.elim
  RelMap {n} r v :=
    match n, r with
    | 2, PUnit.unit => (v 0).1 ∈ (v 1).1

/-- The definable powerset $\mathrm{Def}(s)$ of a ZFC set $s$: the set of all
subsets $y \subseteq s$ definable over $(s, \in)$ by a first-order $\{\in\}$-formula
with parameters from $s$. -/
noncomputable def definablePowerset (s : ZFSet.{u}) : ZFSet.{u} :=
  s.powerset.sep fun y ↦
    ∃ (k : ℕ) (φ : setLang.BoundedFormula Empty (k + 1)) (p : Fin k → s.toSet),
      ∀ x : s.toSet, x.1 ∈ y ↔ φ.Realize Empty.elim (Fin.snoc p x)

/-- Transfinite stage $L_\alpha(\mathbb{R})$ of Gödel's inner model
$L(\mathbb{R}) = L(V_{\omega + 1})$ (Jech, *Set Theory*, 3rd Millennium ed.,
p. 193 & Chapter 33), initialized at $L_0(\mathbb{R}) = V_{\omega + 1}$. -/
noncomputable def constructibleRealsStage (α : Ordinal.{u}) : ZFSet.{u} :=
  Ordinal.limitRecOn α (ZFSet.vonNeumann (omega0 + 1))
    (fun _ s ↦ definablePowerset s)
    (fun o _ IH ↦ ZFSet.iUnion fun β : Iio o ↦ IH β.1 β.2)

/-- Gödel's inner model $L(\mathbb{R}) = \bigcup_{\alpha \in \mathrm{Ord}} L_\alpha(\mathbb{R})$. -/
noncomputable def constructibleReals : Set ZFSet.{u} :=
  ⋃ α : Ordinal.{u}, (constructibleRealsStage.{u} α).toSet

/-- Canonical encoding of a Baire real $x : \mathbb{N} \to \mathbb{N}$ as its
Kuratowski function graph $\{(n, x(n)) \mid n \in \mathbb{N}\} \in V_{\omega + 1}$. -/
noncomputable def encodeReal (x : ℕ → ℕ) : ZFSet.{u} :=
  ZFSet.iUnion fun n : ULift.{u} ℕ ↦
    {ZFSet.pair (n.down : Ordinal.{u}).toZFSet (x n.down : Ordinal.{u}).toZFSet}

/-- Canonical encoding of a subset $A \subseteq \mathbb{N}^{\mathbb{N}}$ as a ZFC
subset of $\omega^\omega$. -/
noncomputable def encodeRealSet (A : Set (ℕ → ℕ)) : ZFSet.{u} :=
  (ZFSet.omega.funs ZFSet.omega).sep fun z ↦ ∃ x ∈ A, z = encodeReal.{u} x

/-- Canonical encoding of a finite sequence $s \in \mathbb{N}^{<\omega}$ as an
element of $V_\omega$ (function from $|s|$ to $\omega$). -/
noncomputable def encodeSeq (s : List ℕ) : ZFSet.{u} :=
  ZFSet.iUnion fun i : ULift.{u} (Fin s.length) ↦
    {ZFSet.pair (i.down.1 : Ordinal.{u}).toZFSet (s[i.down.1] : Ordinal.{u}).toZFSet}

/-- Canonical encoding of a game strategy $\sigma : \mathbb{N}^{<\omega} \to \mathbb{N}$
as a ZFC set of Kuratowski pairs $\{(s, \sigma(s)) \mid s \in \mathbb{N}^{<\omega}\}$. -/
noncomputable def encodeStrategy (σ : List ℕ → ℕ) : ZFSet.{u} :=
  ZFSet.iUnion fun s : ULift.{u} (List ℕ) ↦
    {ZFSet.pair (encodeSeq.{u} s.down) (σ s.down : Ordinal.{u}).toZFSet}

/-- Finite play prefix of length $k$ of Player I strategy $\sigma$ against
Player II strategy $\tau$. -/
def playPrefix (σ τ : List ℕ → ℕ) : ℕ → List ℕ
  | 0 => []
  | k + 1 =>
      let s := playPrefix σ τ k
      s ++ [if k % 2 = 0 then σ s else τ s]

/-- Infinite outcome play $(\sigma * \tau) : \mathbb{N} \to \mathbb{N}$. -/
def strategicPlay (σ τ : List ℕ → ℕ) (k : ℕ) : ℕ :=
  if k % 2 = 0 then σ (playPrefix σ τ k) else τ (playPrefix σ τ k)

/-- A cardinal $\kappa$ is *measurable* if $\kappa > \aleph_0$ and carries a
nonprincipal $\kappa$-complete ultrafilter. -/
def IsMeasurableCardinal (κ : Cardinal.{u}) : Prop :=
  ℵ₀ < κ ∧ ∃ U : Ultrafilter κ.ord.ToType,
    (∀ x : κ.ord.ToType, ({x} : Set κ.ord.ToType)ᶜ ∈ (U : Filter κ.ord.ToType)) ∧
    ∀ (ι : Type u), #ι < κ → ∀ F : ι → Set κ.ord.ToType,
      (∀ i, F i ∈ (U : Filter κ.ord.ToType)) → (⋂ i, F i) ∈ (U : Filter κ.ord.ToType)

/-- Elementary embedding $j : V \to M$ into a transitive class $M$ with critical
point $\kappa$. -/
def HasCriticalPoint (M : Set ZFSet.{u}) (j : ZFSet.{u} → ZFSet.{u})
    (κ : Ordinal.{u}) : Prop :=
  (∀ x ∈ M, ∀ y ∈ x, y ∈ M) ∧
  (∃ hj : ∀ x, j x ∈ M,
    ∀ ⦃m : ℕ⦄ (φ : setLang.BoundedFormula Empty m) (xs : Fin m → (univ : Set ZFSet.{u})),
      φ.Realize Empty.elim xs ↔
        φ.Realize Empty.elim (fun i ↦ (⟨j (xs i).1, hj (xs i).1⟩ : M))) ∧
  (∀ ξ < κ, j ξ.toZFSet = ξ.toZFSet) ∧
  κ.toZFSet ∈ j κ.toZFSet

/-- Kuratowski graph of $f : \delta \to \mathrm{Ord}$. -/
noncomputable def ordinalFuncGraph (δ : Ordinal.{u}) (f : Ordinal.{u} → Ordinal.{u}) :
    ZFSet.{u} :=
  ZFSet.iUnion fun ξ : Iio δ ↦ {ZFSet.pair ξ.1.toZFSet (f ξ.1).toZFSet}

/-- A cardinal $\delta$ is a *Woodin cardinal* (Kanamori, Theorem 26.14). -/
def IsWoodinCardinal (δ : Cardinal.{u}) : Prop :=
  ∀ f : Ordinal.{u} → Ordinal.{u}, (∀ ξ < δ.ord, f ξ < δ.ord) →
    ∃ κ < δ.ord, (∀ ξ < κ, f ξ < κ) ∧
      ∃ (M : Set ZFSet.{u}) (j : ZFSet.{u} → ZFSet.{u}) (η : Ordinal.{u}),
        HasCriticalPoint M j κ ∧
        ZFSet.pair κ.toZFSet η.toZFSet ∈ j (ordinalFuncGraph δ.ord f) ∧
        ∀ x ∈ ZFSet.vonNeumann η, x ∈ M

end WoodinConstructibleRealsDeterminacy

/-- **Woodin's $\mathrm{AD}^{L(\mathbb{R})}$ theorem.** If there exist a
strictly increasing $\omega$-sequence of Woodin cardinals
$\delta_0 < \delta_1 < \cdots$ and a measurable cardinal $\kappa$ with
$\sup_{n \in \mathbb{N}} \delta_n < \kappa$, then $L(\mathbb{R})$ satisfies the
Axiom of Determinacy: every subset $A \subseteq \mathbb{N}^{\mathbb{N}}$ in
$L(\mathbb{R})$ is determined (via a winning strategy in $L(\mathbb{R})$, since
$\mathbb{N}^{<\omega} \to \mathbb{N}$ lies in $L(\mathbb{R})$). -/
@[eval_problem]
theorem woodin_constructible_reals_determinacy
    {δ : ℕ → Cardinal.{u}} {κ : Cardinal.{u}}
    (hmono : StrictMono δ)
    (hwoodin : ∀ n : ℕ, WoodinConstructibleRealsDeterminacy.IsWoodinCardinal (δ n))
    (hlt : (⨆ n : ℕ, δ n) < κ)
    (hκ : WoodinConstructibleRealsDeterminacy.IsMeasurableCardinal κ)
    (A : Set (ℕ → ℕ))
    (hA : WoodinConstructibleRealsDeterminacy.encodeRealSet.{u} A ∈
      WoodinConstructibleRealsDeterminacy.constructibleReals.{u}) :
    (∃ σ : List ℕ → ℕ,
      WoodinConstructibleRealsDeterminacy.encodeStrategy.{u} σ ∈
        WoodinConstructibleRealsDeterminacy.constructibleReals.{u} ∧
      ∀ τ : List ℕ → ℕ, WoodinConstructibleRealsDeterminacy.strategicPlay σ τ ∈ A) ∨
    (∃ τ : List ℕ → ℕ,
      WoodinConstructibleRealsDeterminacy.encodeStrategy.{u} τ ∈
        WoodinConstructibleRealsDeterminacy.constructibleReals.{u} ∧
      ∀ σ : List ℕ → ℕ, WoodinConstructibleRealsDeterminacy.strategicPlay σ τ ∉ A) := by
  sorry

end SetTheory
end LeanEval
