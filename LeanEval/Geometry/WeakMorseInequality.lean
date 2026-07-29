import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace WeakMorseInequality

/-!
# Weak Morse inequalities

§40 of Knill's *Some Fundamental Theorems in Mathematics* (an additional
statement of the section; the boxed main theorem is the strong Morse
inequality). For a Morse function `f` on a closed smooth finite-dimensional
manifold `M`,

`b_k(M) ≤ c_k(f)` for every `k`,

i.e. the `k`-th Betti number is bounded by the number of Morse-index-`k`
critical points. Follows from the strong Morse inequality but is often
proved directly via the Morse-Smale CW structure.

mathlib has the smooth-manifold framework, `mfderiv`, higher Fréchet
derivatives, and `singularHomologyFunctor` but no Morse functions, Morse
index, critical-point counts, Betti numbers (as a named definition), or
the weak Morse inequality. The Challenge ships seven helper definitions.
-/

open scoped Manifold ContDiff Topology
open CategoryTheory

/-- A point `x ∈ M` is a **critical point** of `f` if `mfderiv f x = 0`. -/
def IsCriticalPoint
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) (f : M → ℝ) (x : M) : Prop :=
  mfderiv I (modelWithCornersSelf ℝ ℝ) f x = 0

/-- **Local Hessian** of `f` at `x`, in the preferred extended chart. -/
noncomputable def localHessian
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) (f : M → ℝ) (x : M) :
    ContinuousMultilinearMap ℝ (fun _ : Fin 2 => E) ℝ :=
  iteratedFDeriv ℝ 2 (f ∘ (extChartAt I x).symm) (extChartAt I x x)

/-- A critical point `x` is **non-degenerate** when the local Hessian has
trivial radical. -/
def IsNondegenerateCritical
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) (f : M → ℝ) (x : M) : Prop :=
  IsCriticalPoint I f x ∧
    ∀ v : E, (∀ w : E, localHessian I f x ![v, w] = 0) → v = 0

/-- A **Morse function** on `M` is `C^∞`, has finitely many critical points,
and every critical point is non-degenerate. -/
structure IsMorseFunction
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) [IsManifold I ∞ M] (f : M → ℝ) : Prop where
  smooth : ContMDiff I (modelWithCornersSelf ℝ ℝ) ∞ f
  critical_finite : {x : M | IsCriticalPoint I f x}.Finite
  nondegenerate : ∀ x : M, IsCriticalPoint I f x → IsNondegenerateCritical I f x

/-- The **Morse index** of `f` at `x`. -/
noncomputable def morseIndex
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) (f : M → ℝ) (x : M) : ℕ :=
  sSup {k : ℕ | ∃ S : Submodule ℝ E,
    Module.finrank ℝ S = k ∧
      ∀ v ∈ S, v ≠ 0 → localHessian I f x ![v, v] < 0}

/-- `morseCount f k = c_k(f)`. -/
noncomputable def morseCount
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) (f : M → ℝ) (k : ℕ) : ℕ :=
  {x : M | IsCriticalPoint I f x ∧ morseIndex I f x = k}.ncard

/-- `b_k(M) := dim_ℝ H_k(M; ℝ)`. -/
noncomputable def bettiNumber (M : Type) [TopologicalSpace M] (k : ℕ) : ℕ :=
  Module.finrank ℝ
    (((AlgebraicTopology.singularHomologyFunctor (ModuleCat ℝ) k).obj
        (ModuleCat.of ℝ ℝ)).obj (TopCat.of M))

/-- **Weak Morse inequalities.** For a Morse function `f` on a closed
smooth finite-dimensional Hausdorff manifold `M` and every `k ∈ ℕ`,
`b_k(M) ≤ c_k(f)`. -/
@[eval_problem]
theorem weak_morse_inequality
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H} [I.Boundaryless]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M] [IsManifold I ∞ M]
    [CompactSpace M] [T2Space M] (f : M → ℝ) (_hf : IsMorseFunction I f) (k : ℕ) :
    bettiNumber M k ≤ morseCount I f k := by
  sorry

end WeakMorseInequality
end Geometry
end LeanEval
