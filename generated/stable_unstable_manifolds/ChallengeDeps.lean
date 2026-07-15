import Mathlib

namespace LeanEval
namespace Dynamics
namespace StableUnstableManifoldsProblem

/-!
# Local stable and unstable sets at a hyperbolic fixed point

For a `C¹` map `f : ℝⁿ → ℝⁿ` with a hyperbolic invertible fixed point at
`x₀`, some open neighbourhood `U ∋ x₀` carries genuinely local stable
and unstable sets — orbits required to stay inside `U` while converging
to `x₀` — meeting only at `x₀`. This is the set-level (topological)
shadow of the Hadamard–Perron theorem; the full theorem additionally
asserts that the local stable and unstable sets are immersed `C¹`
submanifolds tangent to the stable / unstable eigenspaces. §104 in
Knill's *Some Fundamental Theorems in Mathematics*.

The "orbit stays in `U`" requirement is essential: without it, homoclinic
points (forward and backward limits at `x₀`, but excursions outside any
small neighbourhood) would falsify `Wˢ ∩ Wᵘ = {x₀}` in systems with
homoclinic dynamics. With it, after shrinking `U`, the only point with
both forward and backward orbits remaining in `U` and converging to
`x₀` is `x₀` itself.
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



end StableUnstableManifoldsProblem
end Dynamics
end LeanEval
