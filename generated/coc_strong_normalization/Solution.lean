import ChallengeDeps

import Submission
import ChallengeDeps
/-!
# Strong normalization for the calculus of constructions with universes

## The system

`Tm` is the usual lambda syntax with de Bruijn variables: variables, sorts, application,
`lam A b` for `λ (x : A). b`, and `pi A B` for `Π (x : A). B`. The sorts `Srt` are an
impredicative `Prop` together with a predicative hierarchy `Type 0`, `Type 1`, ..., typed by
`Ax`, which gives `Prop : Type 0` and `Type i : Type (i+1)`. This is the non-cumulative,
Π-only generalized calculus of constructions CCω: its concrete sort-formation and product
rules agree with Lean's `Prop`/`Type i` hierarchy, while omitting Lean's inductive types,
proof irrelevance, and other extensions. Products are formed by `Rl`, where
`Rl s₁ s₂ s₃` says a `Π` with domain in `s₁` and codomain in `s₂` lands in `s₃`; the three
rules are the impredicative `Rl s .prop .prop`, the predicative
`Rl (.type i) (.type j) (.type (max i j))`, and `Rl .prop (.type i) (.type i)`. There is no
cumulativity. `Step` is beta reduction under any context, `Conv` its equivalence closure, and
`Wf`/`Typing` the mutually defined context-well-formedness and typing judgements. Finally,
`SN t` says `t` admits no infinite chain of `Step`s, expressed as accessibility for the
reversed relation.

Reading the syntax takes a moment, so as a worked example, `λ (A : Prop). λ (x : A). x` is

    Tm.lam (.srt .prop) (.lam (.var 0) (.var 0))

and its type `Π (A : Prop). Π (x : A). A` is

    Tm.pi (.srt .prop) (.pi (.var 0) (.var 1))

where `A` is `.var 0` under one binder and `.var 1` under two.

## The task

Prove six things about this system.

* `typing_polyId`: the term above really does have the type above. This one is short.
* `typing_polyId_app`: applying it to `False` is well typed, exercising `Typing.app`.
* `step_polyId_app`: that application takes the expected beta step, exercising `subst`.
* `subject_reduction`: if `Γ ⊢ t : A` and `t` steps to `t'`, then `Γ ⊢ t' : A`.
* `strong_normalization`: every well-typed term is strongly normalizing.
* `consistency`: no closed term has type `Π (P : Prop). P`, which in this syntax is
  `Tm.pi (.srt .prop) (.var 0)`.

`strong_normalization` is the substantial one. The obstacle is the impredicative rule
`Rl s .prop .prop`: a proposition may quantify over domains in `Prop` or any `Type i`, so no
induction on the structure of types can get off the ground, and one needs Girard's reducibility
candidates adapted to dependent types. Coquand and Huet introduced the calculus of
constructions; Luo proved strong normalization for the stronger extended calculus with a
predicative universe hierarchy, and Barras formalized sound models of CC and CCω. Given
normalization, subject reduction, confluence, and the corresponding canonical-form analysis,
`consistency` follows by analysing closed normal forms: an inhabitant of
`Π (P : Prop). P` would have to be a `lam` whose body is a normal term of type `P` in the
context `[Prop]`, and the only variable available there has type `Prop`, not `P`.

For a smaller rehearsal, replace the hierarchy by the two sorts `Prop` and `Type 0`, and drop
the axiom `Type 0 : Type 1` so that `Type 0` is a top sort. The four surviving product rules
give the usual λC presentation. This is a different typing relation, rather than literally a
subsystem obtained by restricting the terms of CCω, but it keeps the impredicativity while
dropping the hierarchy.

## Design notes

No mathlib is needed and nothing here is executable, so there is no definition hole to game;
the holes are all theorems about a fixed trusted system.

The three small guards exercise the statement itself. If the typing rules were mis-stated so
that nothing were typable, both `strong_normalization` and `consistency` would hold vacuously.
Requiring the polymorphic identity to be typable rules that out, and it exercises
impredicativity on the way, since `Π (A : Prop). A → A` lands in `Prop` only because
`Rl (.type 0) .prop .prop` is available. The application and step guards additionally pin down
`Typing.app`, beta reduction, and substitution.
-/

namespace LeanEval
namespace ProgramVerification
namespace CoCStrongNormalization

/-! ## The problem -/

/--
Anti-vacuity guard: the polymorphic identity `λ (A : Prop). λ (x : A). x` has type
`Π (A : Prop). Π (x : A). A`. This is typable only because `Prop` is impredicative.
-/
theorem typing_polyId :
    Typing [] (.lam (.srt .prop) (.lam (.var 0) (.var 0)))
      (.pi (.srt .prop) (.pi (.var 0) (.var 1))) := Submission.LeanEval.ProgramVerification.CoCStrongNormalization.typing_polyId

/--
Anti-vacuity guard: applying the polymorphic identity to `False` exercises application typing.
Here `False` is encoded as `Π (P : Prop). P`.
-/
theorem typing_polyId_app :
    Typing []
      (.app
        (.lam (.srt .prop) (.lam (.var 0) (.var 0)))
        (.pi (.srt .prop) (.var 0)))
      (.pi (.pi (.srt .prop) (.var 0)) (.pi (.srt .prop) (.var 0))) := Submission.LeanEval.ProgramVerification.CoCStrongNormalization.typing_polyId_app

/-- Anti-vacuity guard: the same application takes its expected beta step. -/
theorem step_polyId_app :
    Step
      (.app
        (.lam (.srt .prop) (.lam (.var 0) (.var 0)))
        (.pi (.srt .prop) (.var 0)))
      (.lam (.pi (.srt .prop) (.var 0)) (.var 0)) := Submission.LeanEval.ProgramVerification.CoCStrongNormalization.step_polyId_app

/-- Types are preserved by reduction. -/
theorem subject_reduction (Γ : List Tm) (t t' A : Tm) :
    Typing Γ t A → Step t t' → Typing Γ t' A := Submission.LeanEval.ProgramVerification.CoCStrongNormalization.subject_reduction Γ t t' A

/-- Every well-typed term is strongly normalizing. -/
theorem strong_normalization (Γ : List Tm) (t A : Tm) :
    Typing Γ t A → SN t := Submission.LeanEval.ProgramVerification.CoCStrongNormalization.strong_normalization Γ t A

/-- The system is logically consistent: `Π (P : Prop). P` is not inhabited. -/
theorem consistency : ¬ ∃ t : Tm, Typing [] t (.pi (.srt .prop) (.var 0)) := Submission.LeanEval.ProgramVerification.CoCStrongNormalization.consistency

end CoCStrongNormalization
end ProgramVerification
end LeanEval
