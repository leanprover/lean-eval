import Mathlib
import EvalTools.Markers

open scoped BigOperators ComplexConjugate ContDiff Manifold

namespace LeanEval
namespace Combinatorics

/-!
# The Green–Tao–Ziegler Inverse Theorem for the Gowers $U^{s+1}[N]$ Norms

Ben Green, Terence Tao, and Tamar Ziegler (2012, *Ann. of Math.* (2) 176,
1231–1372, Theorem 1.3; following Green–Tao 2008 for $U^3[N]$ and
Bergelson–Tao–Ziegler 2010 in the ergodic setting; see also Manners 2018 for
quantitative bounds) proved that for every step $s \ge 1$ and threshold
$\delta > 0$, there exists a finite collection of filtered $s$-step nilmanifolds
$(G_m / \Gamma_m, G_{m,\bullet})_{m < K}$ (equipped with right-invariant
metrics) together with a correlation threshold $c = c(s, \delta) > 0$ such that
for every $N \ge 1$ and every $1$-bounded function
$f : \{1, \dots, N\} \to \mathbb{C}$ satisfying $\|f\|_{U^{s+1}[N]} \ge \delta$,
there exist an index $m < K$, a polynomial sequence $g : \mathbb{Z} \to G_m$
adapted to the filtration $G_{m,\bullet}$, and a $1$-bounded $1$-Lipschitz
function $\Phi : G_m / \Gamma_m \to \mathbb{C}$ such that
$$
  \left| \frac{1}{N} \sum_{n=1}^N f(n) \, \overline{\Phi(g(n)\Gamma_m)} \right| \ge c.
$$

Following Green–Tao–Ziegler Definition 1.1 and Appendix B, the localized
interval Gowers norm $\|f\|_{U^k[N]}$ is computed by embedding
$\{1, \dots, N\}$ into a cyclic group $\mathbb{Z} / N' \mathbb{Z}$ with
$N' = 2^{k+1} N$ and normalizing by
$\|\mathbf{1}_{[1, N]}\|_{U^k(\mathbb{Z}/N'\mathbb{Z})}$. Stated purely in
Mathlib.
-/

namespace GreenTaoZiegler

/-- Cyclic Gowers $U^k$ norm on $\mathbb{Z}/N'\mathbb{Z}$. -/
noncomputable def cyclicGowersNorm (k N' : ℕ) [NeZero N'] (F : ZMod N' → ℂ) : ℝ :=
  (((N' : ℝ) ^ (k + 1))⁻¹ *
    (∑ x : ZMod N', ∑ h : Fin k → ZMod N',
      ∏ v : Fin k → Bool,
        (if Even (Finset.univ.filter fun i ↦ v i).card then id else conj)
          (F (x + ∑ i : Fin k, if v i then h i else 0))).re) ^
    ((2 : ℝ) ^ k)⁻¹

/-- Zero-extension of $f : \mathbb{N} \to \mathbb{C}$ on $\{1, \dots, N\}$ to
$\mathbb{Z}/N'\mathbb{Z}$. -/
def intervalExt (N N' : ℕ) (f : ℕ → ℂ) (z : ZMod N') : ℂ :=
  if 1 ≤ z.val ∧ z.val ≤ N then f z.val else 0

/-- The localized Gowers $U^k[N]$ norm of $f$ on $\{1, \dots, N\}$
(Green–Tao–Ziegler, Appendix B), defined via embedding into
$\mathbb{Z} / (2^{k+1} N)\mathbb{Z}$. -/
noncomputable def intervalGowersNorm (k N : ℕ) (f : ℕ → ℂ) : ℝ :=
  if h : 1 ≤ k ∧ 1 ≤ N then
    let N' := 2 ^ (k + 1) * N
    haveI : NeZero N' := ⟨Nat.ne_of_gt (Nat.mul_pos (by positivity) h.2)⟩
    cyclicGowersNorm k N' (intervalExt N N' f) /
      cyclicGowersNorm k N' (intervalExt N N' (fun _ ↦ 1))
  else 0

/-- A degree-$s$ filtration $G = F_0 = F_1 \ge F_2 \ge \cdots$ of closed
connected subgroups of a topological group $G$, with $[F_i, F_j] \le F_{i+j}$
and $F_i = \{1\}$ for all $i > s$. -/
def IsDegreeFiltration {G : Type} [Group G] [TopologicalSpace G]
    (s : ℕ) (F : ℕ → Subgroup G) : Prop :=
  F 0 = ⊤ ∧ F 1 = ⊤ ∧ Antitone F ∧
  (∀ i, IsClosed (F i : Set G) ∧ IsConnected (F i : Set G)) ∧
  (∀ i j, ⁅F i, F j⁆ ≤ F (i + j)) ∧
  ∀ i, s < i → F i = ⊥

/-- Discrete derivative $\partial_h g(n) = g(n + h) g(n)^{-1}$ of a sequence
$g : \mathbb{Z} \to G$. -/
def discreteDeriv {G : Type} [Group G] (h : ℤ) (g : ℤ → G) (n : ℤ) : G :=
  g (n + h) * (g n)⁻¹

/-- Iterated discrete derivative $\partial_{h_1} \cdots \partial_{h_k} g$. -/
def iterDiscreteDeriv {G : Type} [Group G] : List ℤ → (ℤ → G) → (ℤ → G)
  | [], g => g
  | h :: hs, g => discreteDeriv h (iterDiscreteDeriv hs g)

/-- A polynomial sequence $g : \mathbb{Z} \to G$ adapted to a filtration $F$
(Green–Tao–Ziegler, Definition 1.8): every $k$-fold discrete derivative
$\partial_{h_1} \cdots \partial_{h_k} g(n)$ lies in $F_k$. -/
def IsPolySeq {G : Type} [Group G] (F : ℕ → Subgroup G) (g : ℤ → G) : Prop :=
  ∀ (hs : List ℤ) (n : ℤ), iterDiscreteDeriv hs g n ∈ F hs.length

/-- Quotient distance on the left-coset space $G / \Gamma$ induced by a
right-invariant metric on $G$:
$d_{G/\Gamma}(x\Gamma, y\Gamma) = \inf \{d(x', y') \mid x'\Gamma = x\Gamma,\; y'\Gamma = y\Gamma\}$. -/
noncomputable def cosetDist {G : Type} [Group G] [MetricSpace G]
    (Γ : Subgroup G) (p q : G ⧸ Γ) : ℝ :=
  sInf {r : ℝ | ∃ x y : G, (x : G ⧸ Γ) = p ∧ (y : G ⧸ Γ) = q ∧ r = dist x y}

end GreenTaoZiegler

/-- **Green–Tao–Ziegler inverse theorem for the Gowers $U^{s+1}[N]$ norms.**
For every integer $s \ge 1$ and $\delta > 0$, there exist $c > 0$ and a finite
collection of connected, simply connected finite-dimensional $s$-step filtered
nilpotent real Lie groups $G_m$ (with right-invariant metrics) and discrete
cocompact subgroups $\Gamma_m \le G_m$ (with $\Gamma_m \cap F_{m,i}$ cocompact
in $F_{m,i}$) such that every $1$-bounded function
$f : \{1, \dots, N\} \to \mathbb{C}$ with $\|f\|_{U^{s+1}[N]} \ge \delta$ has
correlation at least $c$ with a $1$-bounded $1$-Lipschitz $s$-step nilsequence
$n \mapsto \Phi(g(n)\Gamma_m)$. -/
@[eval_problem]
theorem green_tao_ziegler_gowers_inverse {s : ℕ} (hs : 1 ≤ s) {δ : ℝ} (hδ : 0 < δ) :
    ∃ (K : ℕ) (c : ℝ)
      (d : Fin K → ℕ)
      (G : Fin K → Type)
      (_ : ∀ m, Group (G m))
      (_ : ∀ m, MetricSpace (G m))
      (_ : ∀ m, ChartedSpace (EuclideanSpace ℝ (Fin (d m))) (G m))
      (_ : ∀ m, LieGroup 𝓘(ℝ, EuclideanSpace ℝ (Fin (d m))) ∞ (G m))
      (_ : ∀ m, SimplyConnectedSpace (G m))
      (Γ : ∀ m, Subgroup (G m))
      (F : ∀ m, ℕ → Subgroup (G m)),
      0 < c ∧
      (∀ m (x y z : G m), dist (x * z) (y * z) = dist x y) ∧
      (∀ m, DiscreteTopology (Γ m) ∧ CompactSpace (G m ⧸ Γ m)) ∧
      (∀ m, GreenTaoZiegler.IsDegreeFiltration s (F m) ∧
        ∀ i, CompactSpace (F m i ⧸ (Γ m).subgroupOf (F m i))) ∧
      ∀ (N : ℕ), 1 ≤ N → ∀ (f : ℕ → ℂ),
        (∀ n ∈ Finset.Icc 1 N, ‖f n‖ ≤ 1) →
        δ ≤ GreenTaoZiegler.intervalGowersNorm (s + 1) N f →
        ∃ (m : Fin K) (g : ℤ → G m) (Φ : G m ⧸ Γ m → ℂ),
          GreenTaoZiegler.IsPolySeq (F m) g ∧
          (∀ p, ‖Φ p‖ ≤ 1) ∧
          (∀ p q, dist (Φ p) (Φ q) ≤ GreenTaoZiegler.cosetDist (Γ m) p q) ∧
          c ≤ ‖((N : ℂ)⁻¹) * ∑ n ∈ Finset.Icc 1 N,
            f n * conj (Φ (g n : G m ⧸ Γ m))‖ := by
  sorry

end Combinatorics
end LeanEval
