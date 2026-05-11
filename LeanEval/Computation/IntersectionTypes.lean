import Mathlib.Logic.Relation

/-! # Intersection types for combinatory logic

Strongly normalising combinatory terms are exactly those typable with simple intersection types.
-/

namespace CombinatoryLogic

open Relation

/-- Combinatory terms. -/
inductive Tm where
  /-- S combinator, with semantics $λxyz. xz(yz)$. -/
  | S : Tm
  /-- K combinator, with semantics $λxy.x$. -/
  | K : Tm
  /-- (Function) application of combinatory terms. -/
  | app : Tm → Tm → Tm

namespace Tm

instance : Mul (Tm) where
  mul := Tm.app

/-- Reduction of combinatory terms. -/
inductive Red : Tm → Tm → Prop where
  /-- Operational semantics of `S`. -/
  | red_S (a b c : Tm) : Red (S * a * b * c) (a * c * (b * c))
  /-- Operational semantics of `K`. -/
  | red_K (a b : Tm) : Red (K * a * b) a

/-- Multistep reduction. -/
def MRed : Tm → Tm → Prop := ReflTransGen Red

scoped infix:30 " ⭢ " => Tm.Red
scoped infix:30 " ↠ " => Tm.MRed

/-- Strongly-normalising combinatory terms, that is, those that are the start of no infinite path
of reductions. -/
inductive SN : Tm → Prop where
  | intro (x : Tm) : (∀ y : Tm, x ⭢ y → y.SN)

end Tm

open Tm

/-- Simple intersection types. -/
inductive Ty where
  /-- Base type. -/
  | atom : Ty
  /-- Arrow type. -/
  | arr : Ty → Ty → Ty
  /-- Intersection type. -/
  | inter : Ty → Ty → Ty

scoped infixr:60 " ⤳ " => Ty.arr

instance : Inter Ty where
  inter := Ty.inter

/-- Typing derivations. -/
inductive HasTy : Tm → Ty → Prop where
  /-- Principal type of `S`. -/
  | ax_S (A A' B C : Ty) : HasTy S <| (A ⤳ B ⤳ C) ⤳ (A' ⤳ B) ⤳ A ∩ A' ⤳ C
  /-- Principal types of `K`. -/
  | ax_K (A B : Ty) : HasTy K <| A ⤳ B ⤳ A
  /-- Typing of an application. -/
  | arr_elim {x y : Tm} (A B : Ty) : HasTy x (A ⤳ B) → HasTy y A → HasTy (x * y) B
  /-- Introduction of intersection types. -/
  | inter_intro {x : Tm} (A B : Ty) : HasTy x A → HasTy x B → HasTy x (A ∩ B)
  /-- Left-elimination of intersection. -/
  | inter_elim_left {x : Tm} (A B : Ty) : HasTy x (A ∩ B) → HasTy x A
  /-- Right-elimination of intersection. -/
  | inter_elim_right {x : Tm} (A B : Ty) : HasTy x (A ∩ B) → HasTy x B

/-- Typable terms are strongly-normalising. -/
@[eval_problem]
theorem SN_of_hasTy {x : Tm} {A : Ty} (h : HasTy x A) : x.SN := sorry
