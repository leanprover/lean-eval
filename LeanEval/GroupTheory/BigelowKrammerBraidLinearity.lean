import Mathlib.Analysis.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import TauCeti.GroupTheory.SpecificGroups.Braid.Basic
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# Bigelow–Krammer Linearity of Artin Braid Groups

Whether Artin's braid group $B_n$ admits a faithful finite-dimensional linear
representation for all $n$ was a longstanding open question (after Moody 1991,
Long–Paton 1993, and Bigelow 1999 proved that the classical Burau representation
is unfaithful for $n \ge 5$). Daan Krammer (2000, *The braid group $B_4$ is
linear*, *Invent. Math.* 142, 451–486; 2002, *Braid groups are linear*, *Ann. of
Math.* (2) 155, 131–156) and Stephen J. Bigelow (2001, *Braid groups are
linear*, *J. Amer. Math. Soc.* 14, 471–486) independently proved that the
$\binom{n}{2}$-dimensional Lawrence–Krammer representation over
$\mathbb{Z}[q^{\pm 1}, t^{\pm 1}]$ (and hence over $\mathbb{C}$ after choosing
algebraically independent $q, t \in \mathbb{C}^\times$) is faithful for every
$n$, establishing that all Artin braid groups are linear.
-/

/-- **Bigelow–Krammer theorem.** For every $n \in \mathbb{N}$, the $n$-strand
Artin braid group $B_n$ admits an injective group homomorphism into
$\operatorname{GL}_d(\mathbb{C})$ for some $d \in \mathbb{N}$. -/
@[eval_problem]
theorem bigelow_krammer_braid_linearity (n : ℕ) :
    ∃ (d : ℕ) (ρ : TauCeti.BraidGroup n →* Matrix.GeneralLinearGroup (Fin d) ℂ),
      Function.Injective ρ := by
  sorry

end GroupTheory
end LeanEval
