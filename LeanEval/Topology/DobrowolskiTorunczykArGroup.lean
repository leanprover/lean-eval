import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# The Dobrowolski–Toruńczyk Theorem on Polish AR Topological Groups

Tadeusz Dobrowolski and Henryk Toruńczyk (1981, *Separable complete ANRs
admitting a group structure are Hilbert manifolds*, *Topology Appl.* 12,
229–232, Main Theorem) proved that every non-locally-compact Polish topological
group that is an absolute retract for metrizable spaces is homeomorphic to the
real separable Hilbert space $\ell^2(\mathbb{N}, \mathbb{R})$ (vastly
generalizing the Anderson–Kadec theorem that all infinite-dimensional separable
Fréchet spaces are homeomorphic to $\ell^2$).
-/

namespace DobrowolskiTorunczykArGroup

/-- The real separable Hilbert space $\ell^2(\mathbb{N}, \mathbb{R})$. -/
abbrev Ell2Real : Type := lp (fun _ : ℕ ↦ ℝ) 2

/-- A topological space $X$ is an *absolute retract for metrizable spaces* if
$X$ is metrizable and every closed embedding of $X$ into a metrizable space $Z$
admits a continuous retraction $r : Z \to X$. -/
def IsAbsoluteRetract (X : Type) [TopologicalSpace X] : Prop :=
  TopologicalSpace.MetrizableSpace X ∧
    ∀ (Z : Type) [TopologicalSpace Z] [TopologicalSpace.MetrizableSpace Z] (e : X → Z),
      _root_.Topology.IsClosedEmbedding e → ∃ r : C(Z, X), ∀ x : X, r (e x) = x

end DobrowolskiTorunczykArGroup

/-- **Dobrowolski–Toruńczyk theorem on Polish AR topological groups.** Every
non-locally-compact Polish topological group that is an absolute retract for
metrizable spaces is homeomorphic to $\ell^2(\mathbb{N}, \mathbb{R})$. -/
@[eval_problem]
theorem dobrowolski_torunczyk_ar_group
    (G : Type) [Group G] [TopologicalSpace G] [IsTopologicalGroup G] [PolishSpace G]
    (hAR : DobrowolskiTorunczykArGroup.IsAbsoluteRetract G)
    (hnlc : ¬ LocallyCompactSpace G) :
    Nonempty (G ≃ₜ DobrowolskiTorunczykArGroup.Ell2Real) := by
  sorry

end Topology
end LeanEval
