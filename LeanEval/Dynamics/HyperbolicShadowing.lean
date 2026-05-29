import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Dynamics
namespace HyperbolicShadowingProblem

/-!
# Anosov–Bowen shadowing lemma

Every compact hyperbolic invariant set of a `C¹` diffeomorphism admits
an open neighbourhood on which every approximate orbit is `δ`-close to
a true `T`-orbit. Anosov 1967; Bowen 1975. §67 in Knill's *Some
Fundamental Theorems in Mathematics*.

Knill's setting is "smooth manifold"; we formalise on
`E d := EuclideanSpace ℝ (Fin d)`. Shadowing is local near the
hyperbolic set, and any compact hyperbolic set on a smooth manifold
embeds into some `ℝᵈ` via Whitney embedding, so the Euclidean
formulation captures Knill's content without introducing manifold-with-
corners / tangent-bundle-splitting machinery that is not yet usable in
mathlib.
-/

open scoped Topology

/-- The Euclidean model space `ℝᵈ`. -/
abbrev E (d : ℕ) := EuclideanSpace ℝ (Fin d)

variable {d : ℕ}

/-- A **hyperbolic structure** for a homeomorphism `T : ℝᵈ → ℝᵈ` on a
`T`-invariant set `K`: at each point `x ∈ K` the ambient space `ℝᵈ`
splits as a direct sum of a stable subspace `Eˢ x` and an unstable
subspace `Eᵘ x`; the derivative `dT_x` preserves the splitting; and
forward (resp. backward) iteration contracts `Eˢ` (resp. `Eᵘ`)
exponentially at a uniform rate `λ ∈ (0, 1)` with a uniform constant
`C > 0`. -/
structure HyperbolicStructure (T : E d ≃ₜ E d) (K : Set (E d)) where
  contDiff_fwd : ContDiff ℝ 1 (T : E d → E d)
  contDiff_bwd : ContDiff ℝ 1 (T.symm : E d → E d)
  invariant : (T : E d → E d) '' K = K
  stable : E d → Submodule ℝ (E d)
  unstable : E d → Submodule ℝ (E d)
  isCompl_stable_unstable : ∀ x ∈ K, IsCompl (stable x) (unstable x)
  stable_invariant : ∀ x ∈ K,
    (stable x).map (fderiv ℝ (T : E d → E d) x : E d →ₗ[ℝ] E d) = stable (T x)
  unstable_invariant : ∀ x ∈ K,
    (unstable x).map (fderiv ℝ (T : E d → E d) x : E d →ₗ[ℝ] E d) = unstable (T x)
  rate : ℝ
  rate_pos : 0 < rate
  rate_lt_one : rate < 1
  const : ℝ
  const_pos : 0 < const
  contract_stable : ∀ x ∈ K, ∀ v : E d, v ∈ stable x → ∀ n : ℕ,
    ‖fderiv ℝ ((T : E d → E d)^[n]) x v‖ ≤ const * rate ^ n * ‖v‖
  contract_unstable : ∀ x ∈ K, ∀ v : E d, v ∈ unstable x → ∀ n : ℕ,
    ‖fderiv ℝ ((T.symm : E d → E d)^[n]) x v‖ ≤ const * rate ^ n * ‖v‖

/-- `K ⊆ ℝᵈ` is a **hyperbolic invariant set** for `T` if it admits a
hyperbolic splitting. -/
def IsHyperbolic (T : E d ≃ₜ E d) (K : Set (E d)) : Prop :=
  Nonempty (HyperbolicStructure T K)

/-- `(xₙ)_{n : ℕ}` is an **ε-pseudo orbit** of `T : ℝᵈ → ℝᵈ`:
`‖x (n+1) − T (xₙ)‖ < ε` for every `n`. -/
def IsPseudoOrbit (T : E d → E d) (ε : ℝ) (x : ℕ → E d) : Prop :=
  ∀ n : ℕ, ‖x (n + 1) - T (x n)‖ < ε

/-- `K ⊆ ℝᵈ` has the **shadowing property** for `T`: there exists an
open neighbourhood `U ⊇ K` such that, for every accuracy `δ > 0`, some
tolerance `ε > 0` makes every `ε`-pseudo orbit in `U` `δ`-close to a
real forward `T`-orbit. -/
def HasShadowing (T : E d → E d) (K : Set (E d)) : Prop :=
  ∃ U : Set (E d), IsOpen U ∧ K ⊆ U ∧
    ∀ δ > 0, ∃ ε > 0, ∀ x : ℕ → E d,
      (∀ n, x n ∈ U) → IsPseudoOrbit T ε x →
      ∃ y : E d, ∀ n : ℕ, ‖x n - T^[n] y‖ < δ

/-- **Anosov–Bowen shadowing lemma** (Anosov 1967; Bowen 1975). Every
hyperbolic invariant set has the shadowing property. -/
@[eval_problem]
theorem hyperbolic_has_shadowing
    (T : E d ≃ₜ E d) (K : Set (E d)) (_hK : IsHyperbolic T K) :
    HasShadowing (T : E d → E d) K := by
  sorry

end HyperbolicShadowingProblem
end Dynamics
end LeanEval
