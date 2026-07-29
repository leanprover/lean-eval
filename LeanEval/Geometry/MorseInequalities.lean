import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace MorseInequalities

/-!
# Morse inequalities (Marston Morse, 1934)

§40 of Knill's *Some Fundamental Theorems in Mathematics*. For a Morse
function `f` on a closed smooth finite-dimensional manifold `M`,

`∑_{j≤k} (−1)^{k−j} c_j(f) ≥ ∑_{j≤k} (−1)^{k−j} b_j(M)`

for every `k`, where `c_j` is the number of critical points of `f` of Morse
index `j` and `b_j` is the `j`-th Betti number of `M`.

mathlib has the smooth-manifold framework, `mfderiv`, higher Fréchet
derivatives, and `singularHomologyFunctor` — but no Morse functions, Morse
index, critical-point counts, Betti numbers (as a named definition), or
the Morse inequalities. The Challenge ships seven helper definitions
(`IsCriticalPoint`, `localHessian`, `IsNondegenerateCritical`,
`IsMorseFunction`, `morseIndex`, `morseCount`, `bettiNumber`,
`alternatingPartialSum`) on top of mathlib.
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

/-- A critical point `x` is **non-degenerate** when the local Hessian, viewed
as a symmetric bilinear form on `E`, has trivial radical. -/
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

/-- The **Morse index** of `f` at `x` — the supremum of dimensions of
subspaces of `E` on which the local Hessian is negative-definite. -/
noncomputable def morseIndex
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) (f : M → ℝ) (x : M) : ℕ :=
  sSup {k : ℕ | ∃ S : Submodule ℝ E,
    Module.finrank ℝ S = k ∧
      ∀ v ∈ S, v ≠ 0 → localHessian I f x ![v, v] < 0}

/-- `morseCount f k` is the number `c_k(f)` of Morse-index-`k` critical points. -/
noncomputable def morseCount
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℝ E H) (f : M → ℝ) (k : ℕ) : ℕ :=
  {x : M | IsCriticalPoint I f x ∧ morseIndex I f x = k}.ncard

/-- `b_k(M) := dim_ℝ H_k(M; ℝ)`, the `k`-th Betti number with real
coefficients. -/
noncomputable def bettiNumber (M : Type) [TopologicalSpace M] (k : ℕ) : ℕ :=
  Module.finrank ℝ
    (((AlgebraicTopology.singularHomologyFunctor (ModuleCat ℝ) k).obj
        (ModuleCat.of ℝ ℝ)).obj (TopCat.of M))

/-- The alternating partial sum `∑_{j=0}^{k} (−1)^{k−j} a_j`. -/
def alternatingPartialSum (a : ℕ → ℕ) (k : ℕ) : ℤ :=
  ∑ j ∈ Finset.range (k + 1), (-1 : ℤ) ^ (k - j) * (a j : ℤ)

/-- **Morse inequalities** (Marston Morse, 1934). For a Morse function `f`
on a closed smooth finite-dimensional Hausdorff manifold `M` and every `k ∈ ℕ`,
`∑_{j≤k}(−1)^{k−j} c_j(f) ≥ ∑_{j≤k}(−1)^{k−j} b_j(M)`. -/
@[eval_problem]
theorem morse_inequality
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H] {I : ModelWithCorners ℝ E H} [I.Boundaryless]
    {M : Type} [TopologicalSpace M] [ChartedSpace H M] [IsManifold I ∞ M]
    [CompactSpace M] [T2Space M] (f : M → ℝ) (_hf : IsMorseFunction I f) (k : ℕ) :
    alternatingPartialSum (bettiNumber M) k ≤
      alternatingPartialSum (morseCount I f) k := by
  sorry

end MorseInequalities
end Geometry
end LeanEval
