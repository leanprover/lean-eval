import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Dynamics

/-!
# The Vlasov pushforward theorem

`vlasov_pushforward_solves` is the kinetic-theory method-of-characteristics
identity (Knill attributes it to Maxwell; existence of the flow in the
mean-field limit is Brown–Hepp 1977): if `X_t : M → T*N` solves the Vlasov
Hamiltonian system with initial probability measure `m`, then the pushforward
`P^t := (X_t)_* m` is a weak (Lagrangian) solution of the Vlasov
integro-differential equation.

It is stated on the model phase space `Phase d = ℝᵈ × ℝᵈ`. The trusted helper
definitions (`Phase`, `IsVlasovHamiltonianFlow`, `vlasovMeanField`,
`IsVlasovWeakSolution`) are non-holes. Mathlib has gradients, pushforward
measures, Picard–Lindelöf, and integral curves, but nothing Vlasov-shaped
(no kinetic equation, no weak/distributional transport PDE, no mean-field
limit).

This is a category-(b) candidate from §78 of the Knill survey
(`sections/078-hamiltonian-dynamics.md`).
-/

open MeasureTheory
open scoped Gradient ContDiff

/-- The model phase space `T*N = N × N` for `N = ℝᵈ`. -/
abbrev Phase (d : ℕ) :=
  EuclideanSpace ℝ (Fin d) × EuclideanSpace ℝ (Fin d)

variable {d : ℕ}

/-- The **Vlasov Hamiltonian system** on `X : ℝ → Phase d → Phase d`,
pointwise in `x` and `t`: `f' = g` and
`g' = ∫ y, ∇V((X t x).1 − (X t y).1) ∂m`. -/
def IsVlasovHamiltonianFlow
    (V : EuclideanSpace ℝ (Fin d) → ℝ)
    (m : Measure (Phase d))
    (X : ℝ → Phase d → Phase d) : Prop :=
  ∀ (x : Phase d) (t : ℝ),
    HasDerivAt (fun s => (X s x).1) (X t x).2 t ∧
    HasDerivAt (fun s => (X s x).2)
      (∫ y, ∇ V ((X t x).1 - (X t y).1) ∂m) t

/-- The **Vlasov mean field** `W(x) = ∫ ∇V(x − x') dP(x', y')`. -/
noncomputable def vlasovMeanField
    (V : EuclideanSpace ℝ (Fin d) → ℝ)
    (P : Measure (Phase d))
    (x : EuclideanSpace ℝ (Fin d)) :
    EuclideanSpace ℝ (Fin d) :=
  ∫ z, ∇ V (x - z.1) ∂P

/-- `P : ℝ → Measure (T*N)` is a **weak (Lagrangian) solution** of the Vlasov
integro-differential equation: for every smooth compactly supported test
function `φ` and time `t`,
`(d/dt) ∫ φ dP_t = ∫ (y · ∇_x φ + W(x) · ∇_y φ) dP_t`. -/
def IsVlasovWeakSolution
    (V : EuclideanSpace ℝ (Fin d) → ℝ)
    (P : ℝ → Measure (Phase d)) : Prop :=
  ∀ φ : Phase d → ℝ, ContDiff ℝ ∞ φ → HasCompactSupport φ →
    ∀ t : ℝ,
      HasDerivAt (fun s => ∫ z, φ z ∂(P s))
        (∫ z, (fderiv ℝ (fun x' => φ (x', z.2)) z.1) z.2
            + (fderiv ℝ (fun y' => φ (z.1, y')) z.2)
                (vlasovMeanField V (P t) z.1) ∂(P t)) t

/-- **Vlasov pushforward theorem.** If `X_t` solves the Vlasov Hamiltonian
system with initial probability measure `m`, then `P^t := (X_t)_* m` is a weak
(Lagrangian) solution of the Vlasov integro-differential equation. -/
@[eval_problem]
theorem vlasov_pushforward_solves
    (V : EuclideanSpace ℝ (Fin d) → ℝ)
    (_hV : ContDiff ℝ ∞ V)
    (m : Measure (Phase d)) [IsProbabilityMeasure m]
    (X : ℝ → Phase d → Phase d)
    (_hX : IsVlasovHamiltonianFlow V m X)
    (_hXMeas : ∀ t, Measurable (X t)) :
    IsVlasovWeakSolution V (fun t => Measure.map (X t) m) := by
  sorry

end Dynamics
end LeanEval
