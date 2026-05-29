import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Dynamics
namespace StableUnstableManifoldsProblem

/-!
# Stable and unstable manifolds at a hyperbolic fixed point

For a `C¹` map `f : ℝⁿ → ℝⁿ` with a hyperbolic invertible fixed point
at `x₀`, some open neighbourhood `U ∋ x₀` carries local stable and
unstable sets meeting only at `x₀`. Hadamard–Perron in barest
topological form; the full theorem additionally asserts that `Wˢ`, `Wᵘ`
are immersed `C¹` submanifolds tangent to the stable/unstable
eigenspaces. §104 in Knill's *Some Fundamental Theorems in
Mathematics*.

`Wˢ ∩ Wᵘ = {x₀}` is the real Hadamard–Perron content: in a hyperbolic
system the only point with both forward *and* backward orbits
converging to `x₀` is `x₀` itself.
-/

open scoped Topology
open Filter Polynomial

/-- The Euclidean model space `ℝⁿ`. -/
abbrev E (n : ℕ) : Type := EuclideanSpace ℝ (Fin n)

/-- Multiset of complex eigenvalues of `L : ℝⁿ →L[ℝ] ℝⁿ`. -/
noncomputable def complexEigenvalues {n : ℕ} (L : E n →L[ℝ] E n) : Multiset ℂ :=
  ((L : E n →ₗ[ℝ] E n).charpoly.map (algebraMap ℝ ℂ)).roots

/-- `L` is **hyperbolic**: no complex eigenvalue lies on the unit
circle. -/
def IsHyperbolicLinear {n : ℕ} (L : E n →L[ℝ] E n) : Prop :=
  ∀ μ ∈ complexEigenvalues L, ‖μ‖ ≠ 1

/-- **Stable and unstable manifolds exist at a hyperbolic fixed point**
(Hadamard–Perron, topological form). For a `C¹` map `f` with an
invertible hyperbolic fixed point at `x₀`, some open neighbourhood
`U ∋ x₀` carries the local stable set `Wˢ` (forward orbit converges to
`x₀`) and local unstable set `Wᵘ` (admits backward orbit converging to
`x₀`), and `Wˢ ∩ Wᵘ = {x₀}`. -/
@[eval_problem]
theorem stable_unstable_manifolds_exist (n : ℕ) (f : E n → E n) (x₀ : E n)
    (_hf : ContDiffAt ℝ 1 f x₀)
    (_hfix : f x₀ = x₀)
    (_hhyp : IsHyperbolicLinear (fderiv ℝ f x₀))
    (_hf_inv : (fderiv ℝ f x₀).IsInvertible) :
    ∃ U : Set (E n), IsOpen U ∧ x₀ ∈ U ∧
      ∃ Ws Wu : Set (E n),
        Ws = U ∩ {x | Tendsto (fun k => f^[k] x) atTop (𝓝 x₀)} ∧
        Wu = U ∩ {x | ∃ y : ℕ → E n,
          y 0 = x ∧ (∀ k, f (y (k + 1)) = y k) ∧
          Tendsto y atTop (𝓝 x₀)} ∧
        Ws ∩ Wu = {x₀} := by
  sorry

end StableUnstableManifoldsProblem
end Dynamics
end LeanEval
