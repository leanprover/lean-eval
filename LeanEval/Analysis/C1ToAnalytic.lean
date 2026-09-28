import Mathlib
import EvalTools.Markers

/-!
# From C¹-manifold to real analytic

If 1 ≤ k ≤ n where k and n are integers, ∞ or ω, every Cᵏ-structure on a (paracompact, Hausdorff)
manifold can be upgraded to a compatible Cⁿ structure, and uniquely so in the sense that any
two Cⁿ-structures inducing the given Cᵏ-structure are connected by an isotopy through
Cᵏ-diffeomorphisms.

This essentially says the classification of Cᵏ-manifolds (k ≥ 1) is the same problem as
the classification of smooth (or real analytic) manifolds.

Counterexamples abound if the Hausdorff assumption is removed, but it is not clear whether the
paracompact assumption is necessary. https://en.wikipedia.org/wiki/Long_line_(topology)#Properties
claims that every smooth structure on the long line extends to infinitely many real analytic
structures, but this appears to be an overclaim, see https://mathoverflow.net/questions/404692.

## References

* Koji Shiga. Some aspects of real-analytic manifolds and differentiable manifolds.
  J. Math. Soc. Japan 16(2): 128-142 (April, 1964). DOI: 10.2969/jmsj/01620128

* https://mathoverflow.net/questions/8789/can-every-manifold-be-given-an-analytic-structure/8799
  mentions work of Morrey, Grauert and Whitney in the real analytic case.

* https://en.wikipedia.org/wiki/Differential_structure#Existence_and_uniqueness_theorems
-/

variable (k n : WithTop ℕ∞)
variable (M N V W : Type*) [TopologicalSpace M] [TopologicalSpace N]
variable [NormedAddCommGroup V] [NormedSpace ℝ V]
variable [NormedAddCommGroup W] [NormedSpace ℝ W]

open scoped Manifold

/-- A Cᵏ-structure on a manifold can be upgraded to a compatible Cⁿ-structure if `1 ≤ k ≤ n`
(if `n ≤ k` this is trivial). We use two isomorphic model vector spaces V and W in the statement
to avoid introducing two `ChartedSpace V M` instances. -/
@[eval_problem]
theorem exists_isManifold_of_le (hk : 1 ≤ k) [FiniteDimensional ℝ V] (e : V ≃ₗ[ℝ] W)
    [ChartedSpace V M] [IsManifold 𝓘(ℝ,V) k M] [T2Space M] [ParacompactSpace M] :
    ∃ (_ : ChartedSpace W M) (_ : IsManifold 𝓘(ℝ,W) n M)
      (f : M ≃ₘ^k⟮𝓘(ℝ,V), 𝓘(ℝ,W)⟯ M), f.toHomeomorph = .refl _ := by
  sorry

/-- If `1 ≤ k ≤ n`, then any Cᵏ-diffeomorphism between two Cⁿ-manifolds is Cᵏ-isotopic to a
Cⁿ-diffeomorphism via Cᵏ-diffeomorphisms. Again, this is probably trivially true fo `n ≤ k`,
and the model spaces are automatically isomorphic given the diffeomorphism unless both spaces
are empty. -/
@[eval_problem]
theorem exists_homotopy_of_diffeomorph (hk : 1 ≤ k) (hkn : k ≤ n) [FiniteDimensional ℝ V]
    [ChartedSpace V M] [IsManifold 𝓘(ℝ,V) n M] [ChartedSpace W N] [IsManifold 𝓘(ℝ,W) n N]
    [T2Space M] [ParacompactSpace M] (e : V ≃ₗ[ℝ] W) (f : M ≃ₘ^k⟮𝓘(ℝ,V), 𝓘(ℝ,W)⟯ N) :
    ∃ H : ℝ × M → N, ContMDiff (𝓘(ℝ,ℝ).prod 𝓘(ℝ,V)) 𝓘(ℝ,W) k H ∧
      (H ⟨0, ·⟩) = f ∧ ∃ g : M ≃ₘ^n⟮𝓘(ℝ,V), 𝓘(ℝ,W)⟯ N, (H ⟨1, ·⟩) = g := by
  sorry
