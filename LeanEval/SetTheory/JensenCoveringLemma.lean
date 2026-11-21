import Mathlib
import EvalTools.Markers

open Cardinal FirstOrder Ordinal Set

namespace LeanEval
namespace SetTheory

universe u

/-!
# Jensen's Covering Lemma for Gödel's Constructible Universe $L$

Ronald B. Jensen (1975; published in K. J. Devlin and R. B. Jensen, *Marginalia
to a theorem of Silver*, in *ISILC Logic Conference*, Lecture Notes in Math.
499, Springer, 1975, 115–142; see also Jech, *Set Theory*, 3rd Millennium ed.,
Springer, 2003, Theorem 18.30) proved that either $0^\#$ exists (equivalently,
by Kunen 1970 and Silver 1971, Jech Theorem 18.20, there exists a nontrivial
elementary embedding $j : L \to L$) or $L$ is remarkably close to the full set
universe $V$: every uncountable set $X$ of ordinals is covered by a
constructible set $Y \in L$ of ordinals having the same cardinality $|Y| = |X|$
in $V$.

Stated purely in Mathlib using `ZFSet`, `Ordinal`, `Cardinal`, and
`FirstOrder.Language`.
-/

namespace JensenCoveringLemma

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
subsets $y \subseteq s$ first-order definable over $(s, \in)$ with parameters
from $s$. -/
noncomputable def definablePowerset (s : ZFSet.{u}) : ZFSet.{u} :=
  s.powerset.sep fun y ↦
    ∃ (k : ℕ) (φ : setLang.BoundedFormula Empty (k + 1)) (p : Fin k → s.toSet),
      ∀ x : s.toSet, x.1 ∈ y ↔ φ.Realize Empty.elim (Fin.snoc p x)

/-- Transfinite stage $L_\alpha$ of Gödel's constructible hierarchy:
$L_0 = \emptyset$, $L_{\alpha + 1} = \mathrm{Def}(L_\alpha)$, and
$L_\lambda = \bigcup_{\beta < \lambda} L_\beta$ for limit ordinals $\lambda$. -/
noncomputable def constructibleStage (α : Ordinal.{u}) : ZFSet.{u} :=
  Ordinal.limitRecOn α ∅
    (fun _ s ↦ definablePowerset s)
    (fun o _ IH ↦ ZFSet.iUnion fun β : Iio o ↦ IH β.1 β.2)

/-- Gödel's constructible universe $L = \bigcup_{\alpha \in \mathrm{Ord}} L_\alpha$. -/
noncomputable def constructibleClass : Set ZFSet.{u} :=
  ⋃ α : Ordinal.{u}, (constructibleStage.{u} α).toSet

/-- Existence of $0^\#$ (in Kunen's equivalent characterization, Jech Theorem
18.20): there exists a nontrivial elementary embedding $j : (L, \in) \to (L, \in)$. -/
def ZeroSharpExists : Prop :=
  ∃ j : setLang.ElementaryEmbedding constructibleClass.{u} constructibleClass.{u},
    ∃ x : constructibleClass.{u}, j x ≠ x

end JensenCoveringLemma

/-- **Jensen's covering lemma.** If $0^\#$ does not exist, then for every
uncountable set of ordinals $X$ ($\aleph_1 \le |X|$), there exists a
constructible set of ordinals $Y \in L$ such that $X \subseteq Y$ and
$|Y| = |X|$ (in $V$). -/
@[eval_problem]
theorem jensen_covering_lemma
    (h0 : ¬ JensenCoveringLemma.ZeroSharpExists.{u})
    {X : ZFSet.{u}} (hX_ord : ∀ x ∈ X, ZFSet.IsOrdinal x)
    (hX_uncount : aleph 1 ≤ #X.toSet) :
    ∃ Y ∈ JensenCoveringLemma.constructibleClass.{u},
      X ⊆ Y ∧ (∀ y ∈ Y, ZFSet.IsOrdinal y) ∧ #Y.toSet = #X.toSet := by
  sorry

end SetTheory
end LeanEval
