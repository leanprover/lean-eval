import Mathlib

namespace LeanEval
namespace Geometry

/-!
# Independence of the parallel postulate

Theorem #12 on Freek Wiedijk's *Formalizing 100 Theorems* list
(<https://www.cs.ru.nl/~freek/100/>). Euclid's parallel postulate is
logically independent of the remaining axioms of plane geometry: there is a
model of absolute (neutral) geometry in which the postulate holds and one in
which it fails, so neither it nor its negation follows from the other axioms.

We use Tarski's axiomatization. `TarskiAbsolute` bundles the betweenness (`B`)
and congruence (`C`) primitives with axioms `A1`–`A9` and the continuity
axiom `A11` — everything except the parallel postulate — following
Schwabhäuser–Szmielew–Tarski. The **Euclidean axiom** `A10` is kept separate
as a `Prop`. `parallel_postulate_independent` then asserts both that some
model satisfies `A10` (the real coordinate plane) and that some model refutes
it (the Klein–Beltrami disk model of the hyperbolic plane).

This formalization was cross-checked against the two existing formalizations
recorded on Freek's list:

* **HOL Light**, John Harrison — `Multivariate/tarski.ml` (axioms hold in
  `ℝ²`) and `100/independence.ml` (the Klein model satisfies `A1`–`A9`, `A11`
  but not `A10`). Axioms `A1`–`A10` match Harrison's `TARSKI_AXIOM_n`
  character-for-character; `A11` is Harrison's second-order continuity axiom.
* **Isabelle/AFP**, Tim Makarios — entry `Tarskis_Geometry`, which builds the
  Klein–Beltrami model and proves it satisfies every Tarski axiom except the
  Euclidean one.
-/

/-- A type carrying the **Tarski absolute-geometry signature** — a betweenness
relation `B` and a congruence relation `C` — satisfying axioms `A1`–`A9` and
`A11` (everything except the parallel postulate `A10`), following
Schwabhäuser–Szmielew–Tarski. -/
class TarskiAbsolute (M : Type*) where
  /-- Betweenness: `B a b c` says `b` lies between `a` and `c` (collinear; the
  non-strict convention, allowing `b = a` or `b = c`). -/
  B : M → M → M → Prop
  /-- Congruence of segments: `C a b c d` says `ab` is congruent to `cd`. -/
  C : M → M → M → M → Prop
  /-- **A1** Reflexivity of congruence. -/
  congr_refl : ∀ a b, C a b b a
  /-- **A2** Transitivity of congruence. -/
  congr_trans : ∀ a b c d e f, C a b c d → C a b e f → C c d e f
  /-- **A3** Identity of congruence: a zero-length segment has equal endpoints. -/
  congr_id : ∀ a b c, C a b c c → a = b
  /-- **A4** Segment construction: any segment can be extended to match a given length. -/
  segment_construction : ∀ a b c d, ∃ x, B a b x ∧ C b x c d
  /-- **A5** Five-segment axiom (a substitute for SAS congruence). -/
  five_segment : ∀ a b c d a' b' c' d', a ≠ b →
    B a b c → B a' b' c' →
    C a b a' b' → C b c b' c' → C a d a' d' → C b d b' d' →
    C c d c' d'
  /-- **A6** Identity of betweenness. -/
  betw_id : ∀ a b, B a b a → a = b
  /-- **A7** Inner Pasch. -/
  inner_pasch : ∀ a b c p q, B a p c → B b q c → ∃ x, B p x b ∧ B q x a
  /-- **A8** Lower-dimension axiom: there exist three non-collinear points. -/
  lower_dim : ∃ a b c, ¬ B a b c ∧ ¬ B b c a ∧ ¬ B c a b
  /-- **A9** Upper-dimension axiom (2D): three points equidistant from two
  distinct points are collinear. -/
  upper_dim : ∀ a b c p q, p ≠ q → C p a q a → C p b q b → C p c q c →
    B a b c ∨ B b c a ∨ B c a b
  /-- **A11** Continuity (second-order form): if some point `a` precedes the
  whole of `Y` as seen from `X` — every `x ∈ X` lies between `a` and every
  `y ∈ Y` — then some point `b` lies between every `x ∈ X` and every
  `y ∈ Y`. -/
  continuity : ∀ X Y : Set M,
    (∃ a, ∀ x ∈ X, ∀ y ∈ Y, B a x y) → (∃ b, ∀ x ∈ X, ∀ y ∈ Y, B x b y)

/-- The **Euclidean axiom** `A10` (Tarski's form of the parallel postulate,
equivalent to Euclid's fifth in the presence of the other axioms): for any
point `d` inside the angle `bac` and any point `t` on the ray from `a`
through `d`, the two sides of the angle, suitably extended, meet on a line
through `t`. -/
def Euclidean (M : Type*) (T : TarskiAbsolute M) : Prop :=
  ∀ a b c d t : M, T.B a d t → T.B b d c → a ≠ d →
    ∃ x y : M, T.B a b x ∧ T.B a c y ∧ T.B x t y



end Geometry
end LeanEval
