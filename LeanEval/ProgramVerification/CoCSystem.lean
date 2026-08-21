/-!
The fixed calculus used by the CoC strong-normalization evaluation problem.

It lives in a separate trusted module because Lean's `Wf`/`Typing` mutual
inductive block must remain intact when the evaluation workspace is extracted.
-/

namespace LeanEval
namespace ProgramVerification
namespace CoCStrongNormalization

/-- Sorts: an impredicative `Prop` and a predicative hierarchy `Type 0`, `Type 1`, ... -/
inductive Srt where
  | prop : Srt
  | type : Nat → Srt
  deriving DecidableEq, Repr, Inhabited

/-- Terms, with de Bruijn variables. -/
inductive Tm where
  | var : Nat → Tm
  | srt : Srt → Tm
  | app : Tm → Tm → Tm
  /-- `lam A b` is `λ (x : A). b`. -/
  | lam : Tm → Tm → Tm
  /-- `pi A B` is `Π (x : A). B`. -/
  | pi : Tm → Tm → Tm
  deriving DecidableEq, Repr, Inhabited

/-- `lift d c t` adds `d` to every free variable of `t` at index `c` or above. -/
def lift (d c : Nat) : Tm → Tm
  | .var i => if i < c then .var i else .var (i + d)
  | .srt s => .srt s
  | .app f a => .app (lift d c f) (lift d c a)
  | .lam A b => .lam (lift d c A) (lift d (c + 1) b)
  | .pi A B => .pi (lift d c A) (lift d (c + 1) B)

/-- `subst k u t` replaces variable `k` of `t` by `u`, decrementing the variables above `k`. -/
def subst (k : Nat) (u : Tm) : Tm → Tm
  | .var i => if i < k then .var i else if i = k then lift k 0 u else .var (i - 1)
  | .srt s => .srt s
  | .app f a => .app (subst k u f) (subst k u a)
  | .lam A b => .lam (subst k u A) (subst (k + 1) u b)
  | .pi A B => .pi (subst k u A) (subst (k + 1) u B)

/-- One step of beta reduction, under any context. -/
inductive Step : Tm → Tm → Prop where
  | beta (A b a : Tm) : Step (.app (.lam A b) a) (subst 0 a b)
  | appFun {f f' : Tm} (a : Tm) : Step f f' → Step (.app f a) (.app f' a)
  | appArg (f : Tm) {a a' : Tm} : Step a a' → Step (.app f a) (.app f a')
  | lamTy {A A' : Tm} (b : Tm) : Step A A' → Step (.lam A b) (.lam A' b)
  | lamBody (A : Tm) {b b' : Tm} : Step b b' → Step (.lam A b) (.lam A b')
  | piDom {A A' : Tm} (B : Tm) : Step A A' → Step (.pi A B) (.pi A' B)
  | piCod (A : Tm) {B B' : Tm} : Step B B' → Step (.pi A B) (.pi A B')

/-- Beta conversion: the equivalence closure of `Step`. -/
inductive Conv : Tm → Tm → Prop where
  | refl (t : Tm) : Conv t t
  | fwd {t u v : Tm} : Conv t u → Step u v → Conv t v
  | bwd {t u v : Tm} : Conv t u → Step v u → Conv t v

/-- `Ax s s'` says that the sort `s` is itself typed by the sort `s'`. -/
inductive Ax : Srt → Srt → Prop where
  | prop : Ax .prop (.type 0)
  | type (i : Nat) : Ax (.type i) (.type (i + 1))

/--
`Rl s₁ s₂ s₃` says a `Π` whose domain lives in `s₁` and whose codomain lives in `s₂` itself
lives in `s₃`. The first constructor is the impredicativity of `Prop`.
-/
inductive Rl : Srt → Srt → Srt → Prop where
  | prop (s : Srt) : Rl s .prop .prop
  | type (i j : Nat) : Rl (.type i) (.type j) (.type (max i j))
  | propType (i : Nat) : Rl .prop (.type i) (.type i)

mutual

/-- Well-formedness of a context; the head of the list is the most recent binding. -/
inductive Wf : List Tm → Prop where
  | nil : Wf []
  | cons {Γ : List Tm} {A : Tm} {s : Srt} : Wf Γ → Typing Γ A (.srt s) → Wf (A :: Γ)

/-- The typing judgement. -/
inductive Typing : List Tm → Tm → Tm → Prop where
  | srt {Γ : List Tm} {s s' : Srt} : Wf Γ → Ax s s' → Typing Γ (.srt s) (.srt s')
  | var {Γ : List Tm} {i : Nat} {A : Tm} :
      Wf Γ → Γ[i]? = some A → Typing Γ (.var i) (lift (i + 1) 0 A)
  | pi {Γ : List Tm} {A B : Tm} {s₁ s₂ s₃ : Srt} :
      Typing Γ A (.srt s₁) → Typing (A :: Γ) B (.srt s₂) → Rl s₁ s₂ s₃ →
      Typing Γ (.pi A B) (.srt s₃)
  | lam {Γ : List Tm} {A B b : Tm} {s : Srt} :
      Typing Γ (.pi A B) (.srt s) → Typing (A :: Γ) b B →
      Typing Γ (.lam A b) (.pi A B)
  | app {Γ : List Tm} {f a A B : Tm} :
      Typing Γ f (.pi A B) → Typing Γ a A →
      Typing Γ (.app f a) (subst 0 a B)
  | conv {Γ : List Tm} {t A B : Tm} {s : Srt} :
      Typing Γ t A → Typing Γ B (.srt s) → Conv A B → Typing Γ t B

end

/-- `t` is strongly normalizing: there is no infinite chain of `Step`s out of `t`. -/
def SN (t : Tm) : Prop := Acc (fun u v => Step v u) t

end CoCStrongNormalization
end ProgramVerification
end LeanEval
