import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Toruńczyk's Topological Characterization of Separable Hilbert Space

Henryk Toruńczyk (1981, *Characterizing Hilbert space topology*, *Fund. Math.*
111, 247–262, Theorem 3.1) proved that a Polish space $X$ is homeomorphic to the
real separable Hilbert space $\ell^2(\mathbb{N}, \mathbb{R})$ if (and only if)
$X$ is an absolute retract for metrizable spaces and satisfies the discrete
countable Hilbert-cubes property: for every open cover $\mathcal{U}$ of $X$,
every sequence of continuous maps $f_n : [0, 1]^{\mathbb{N}} \to X$ can be
$\mathcal{U}$-approximated by continuous maps $g_n : [0, 1]^{\mathbb{N}} \to X$
whose images form a discrete family in $X$.
-/

namespace TorunczykHilbertSpace

/-- The Hilbert cube $Q = [0, 1]^{\mathbb{N}}$ with the product topology. -/
abbrev HilbertCube : Type := ℕ → Set.Icc (0 : ℝ) 1

/-- The real separable Hilbert space $\ell^2(\mathbb{N}, \mathbb{R})$. -/
abbrev Ell2Real : Type := lp (fun _ : ℕ ↦ ℝ) 2

/-- A topological space $X$ is an *absolute retract for metrizable spaces* if
$X$ is metrizable and every closed embedding of $X$ into a metrizable space $Z$
admits a continuous retraction $r : Z \to X$. -/
def IsAbsoluteRetract (X : Type) [TopologicalSpace X] : Prop :=
  TopologicalSpace.MetrizableSpace X ∧
    ∀ (Z : Type) [TopologicalSpace Z] [TopologicalSpace.MetrizableSpace Z] (e : X → Z),
      _root_.Topology.IsClosedEmbedding e → ∃ r : C(Z, X), ∀ x : X, r (e x) = x

/-- A family of subsets `A : ι → Set X` is *discrete* in $X$ if every point of
$X$ has an open neighborhood meeting at most one member of the family. -/
def IsDiscreteFamily {X : Type} [TopologicalSpace X] {ι : Type} (A : ι → Set X) : Prop :=
  ∀ x : X, ∃ V : Set X, IsOpen V ∧ x ∈ V ∧ Set.Subsingleton {i : ι | (V ∩ A i).Nonempty}

/-- Toruńczyk's discrete-cells property: for every open cover $\mathcal{U}$ of
$X$, any sequence of continuous maps $f_n : Q \to X$ admits a
$\mathcal{U}$-close sequence of continuous maps $g_n : Q \to X$ whose images
form a discrete family in $X$. -/
def HasDiscreteCubes (X : Type) [TopologicalSpace X] : Prop :=
  ∀ 𝒰 : Set (Set X), (∀ U ∈ 𝒰, IsOpen U) → ⋃₀ 𝒰 = Set.univ →
    ∀ f : ℕ → HilbertCube → X, (∀ n, Continuous (f n)) →
      ∃ g : ℕ → HilbertCube → X, (∀ n, Continuous (g n)) ∧
        (∀ n z, ∃ U ∈ 𝒰, f n z ∈ U ∧ g n z ∈ U) ∧
        IsDiscreteFamily (fun n ↦ Set.range (g n))

end TorunczykHilbertSpace

/-- **Toruńczyk's characterization of separable Hilbert space.** Every Polish
absolute retract with the discrete countable Hilbert-cubes property is
homeomorphic to $\ell^2(\mathbb{N}, \mathbb{R})$. -/
@[eval_problem]
theorem torunczyk_hilbert_space (X : Type) [TopologicalSpace X] [PolishSpace X]
    (hAR : TorunczykHilbertSpace.IsAbsoluteRetract X)
    (hdisc : TorunczykHilbertSpace.HasDiscreteCubes X) :
    Nonempty (X ≃ₜ TorunczykHilbertSpace.Ell2Real) := by
  sorry

end Topology
end LeanEval
