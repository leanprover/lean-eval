import Mathlib
import EvalTools.Markers

open Filter MeasureTheory Set
open scoped BigOperators ComplexConjugate ContDiff ENNReal Manifold Topology

namespace LeanEval
namespace Dynamics

/-!
# The Host–Kra Structure Theorem for Characteristic Pronilfactors

Bernard Host and Bryna Kra (2005, *Nonconventional ergodic averages and
nilmanifolds*, *Ann. of Math.* (2) 161, 397–488, Theorem 10.1; independently
Tamar Ziegler 2007, *Universal characteristic factors and Furstenberg averages*,
*J. Amer. Math. Soc.* 20, 53–97) proved that for every ergodic invertible
measure-preserving transformation $T$ of a standard Borel probability space
$(X, \mathcal{B}, \mu)$ and every integer $s \ge 1$, the characteristic factor
$\mathcal{Z}_s(X)$ governing the Gowers–Host–Kra uniformity seminorm
$\|\cdot\|_{U^{s+1}(X, \mu, T)}$ (and thereby the $L^2(\mu)$-limiting behavior
of $(s + 1)$-term multiple ergodic averages) has the structure of an
*$s$-step pronilsystem* — an inverse limit of $s$-step nilsystems
$(N_m / \Gamma_m, \mu_m, x\Gamma_m \mapsto a_m x\Gamma_m)$ along continuous
surjective equivariant factor maps $p_m : N_{m+1} / \Gamma_{m+1} \to N_m / \Gamma_m$.

Stated purely in Mathlib.
-/

namespace HostKraZieglerStructure

/-- Recursive Gowers–Host–Kra box functional $\|f\|_{U^k(X, \mu, T)}^{2^k}$
(Host–Kra 2005, §1.1, eq. (2)):
$Q_0(f) = \operatorname{Re} \int_X f\,d\mu$, and
$Q_{k+1}(f) = \limsup_{H \to \infty} \frac{1}{H} \sum_{h=0}^{H-1}
  Q_k(f \cdot \overline{f \circ T^h})$
(whose limit in fact exists for every $k \ge 1$ and $f \in L^\infty(\mu)$). -/
noncomputable def hostKraBoxFunctional {X : Type} [MeasurableSpace X]
    (μ : Measure X) (T : X → X) : ℕ → (X → ℂ) → ℝ
  | 0, f => (∫ x, f x ∂μ).re
  | k + 1, f =>
      (Filter.limsup (fun H : ℕ ↦
        (((H : ℝ)⁻¹ * ∑ h ∈ Finset.range H,
          hostKraBoxFunctional μ T k (fun x ↦ f x * conj (f (T^[h] x))) : ℝ) : EReal))
        atTop).toReal

/-- Sequential inverse limit $\varprojlim_m Y_m$ with the subspace topology from
$\prod_m Y_m$. -/
abbrev SeqInvLimit {Y : ℕ → Type} (p : ∀ m, Y (m + 1) → Y m) : Type :=
  {y : ∀ m, Y m // ∀ m, p m (y (m + 1)) = y m}

/-- A probability-preserving system $(Z, \nu, S)$ is an *$s$-step pronilsystem*
(Host–Kra 2005, §1.2 and Theorem 10.1) if it is an inverse limit of $s$-step
nilsystems $(N_m / \Gamma_m, \mu_m, x\Gamma_m \mapsto a_m x\Gamma_m)$, where
each $N_m$ is a second-countable finite-dimensional real Lie group that is
nilpotent of class at most $s$ (`Group.IsNilpotent (N m) ∧ Group.nilpotencyClass (N m) ≤ s`),
$\Gamma_m \le N_m$ is a discrete cocompact subgroup, $\mu_m$ is an
$N_m$-invariant Borel probability measure on $N_m / \Gamma_m$, and the bonding
maps $p_m : N_{m+1} / \Gamma_{m+1} \to N_m / \Gamma_m$ are continuous,
surjective, and intertwine the translations by $a_{m+1}$ and $a_m$ (as well as
the measures $\mu_{m+1}$ and $\mu_m$ via the projections from $(Z, \nu)$). -/
def IsPronilsystem (s : ℕ) {Z : Type} [TopologicalSpace Z] [MeasurableSpace Z]
    (ν : Measure Z) (S : Z → Z) : Prop :=
  BorelSpace Z ∧ IsProbabilityMeasure ν ∧ MeasurePreserving S ν ν ∧
    ∃ (d : ℕ → ℕ) (N : ℕ → Type)
      (_ : ∀ m, Group (N m))
      (_ : ∀ m, TopologicalSpace (N m))
      (_ : ∀ m, T2Space (N m))
      (_ : ∀ m, SecondCountableTopology (N m))
      (_ : ∀ m, ChartedSpace (EuclideanSpace ℝ (Fin (d m))) (N m))
      (_ : ∀ m, LieGroup 𝓘(ℝ, EuclideanSpace ℝ (Fin (d m))) ∞ (N m))
      (Γ : ∀ m, Subgroup (N m))
      (a : ∀ m, N m)
      (p : ∀ m, N (m + 1) ⧸ Γ (m + 1) → N m ⧸ Γ m)
      (μ : ∀ m, @Measure (N m ⧸ Γ m) (borel (N m ⧸ Γ m)))
      (e : Z ≃ₜ SeqInvLimit p),
      (∀ m, Group.IsNilpotent (N m) ∧ Group.nilpotencyClass (N m) ≤ s) ∧
      (∀ m, DiscreteTopology (Γ m) ∧ CompactSpace (N m ⧸ Γ m)) ∧
      (∀ m, @IsProbabilityMeasure (N m ⧸ Γ m) (borel _) (μ m) ∧
        @SMulInvariantMeasure (N m) (N m ⧸ Γ m) _ (borel _) (μ m)) ∧
      (∀ m, Continuous (p m) ∧ Function.Surjective (p m) ∧
        ∀ y, p m (a (m + 1) • y) = a m • p m y) ∧
      (∀ z m, (e (S z)).1 m = a m • (e z).1 m) ∧
      ∀ m, @Measure.map Z (N m ⧸ Γ m) _ (borel _) (fun z ↦ (e z).1 m) ν = μ m

end HostKraZieglerStructure

/-- **Host–Kra–Ziegler structure theorem.** For every ergodic invertible
measure-preserving transformation $T$ on a standard Borel probability space
$(X, \mu)$ and every integer $s \ge 1$, there exist an ergodic $s$-step
pronilsystem $(Z, \nu, S)$ and a measurable factor map $\pi : X \to Z$
($\pi_* \mu = \nu$ and $\pi(T x) = S(\pi(x))$ for $\mu$-a.e. $x$) whose
pullback $\sigma$-algebra $\pi^{-1}(\mathcal{B}_Z)$ is the exact characteristic
factor for the Gowers–Host–Kra uniformity seminorm $\|\cdot\|_{U^{s+1}}$: for
every $f \in L^\infty(X, \mu)$, $\|f\|_{U^{s+1}}^{2^{s+1}} = 0$ if and only if
$\mathbb{E}_\mu[f \mid \pi^{-1}(\mathcal{B}_Z)] = 0$ $\mu$-almost everywhere. -/
@[eval_problem]
theorem host_kra_ziegler_structure
    {X : Type} [mX : MeasurableSpace X] [StandardBorelSpace X]
    {μ : Measure X} [IsProbabilityMeasure μ]
    (T : X ≃ᵐ X) (hT : Ergodic T μ) {s : ℕ} (hs : 1 ≤ s) :
    ∃ (Z : Type) (_ : TopologicalSpace Z) (mZ : MeasurableSpace Z)
      (ν : Measure Z) (S : Z → Z) (π : X → Z),
      HostKraZieglerStructure.IsPronilsystem s ν S ∧
      Ergodic S ν ∧
      Measurable π ∧
      Measure.map π μ = ν ∧
      (∀ᵐ x ∂μ, π (T x) = S (π x)) ∧
      ∀ f : X → ℂ, MemLp f ⊤ μ →
        (HostKraZieglerStructure.hostKraBoxFunctional μ T (s + 1) f = 0 ↔
          μ[f | mZ.comap π] =ᵐ[μ] 0) := by
  sorry

end Dynamics
end LeanEval
