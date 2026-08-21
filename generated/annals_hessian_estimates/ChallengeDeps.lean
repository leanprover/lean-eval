import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.Analysis.InnerProductSpace.Spectrum
import Mathlib.Analysis.Normed.Lp.MeasurableSpace
import Mathlib.MeasureTheory.Function.LpSeminorm.Defs
import Mathlib.MeasureTheory.Measure.Haar.OfBasis
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Hessian estimates for the sigma-2 equation in dimension four

We formalise the statement of the main result from R. Shankar and Y. Yuan,
`Hessian estimates for the sigma-2 equation in dimension four`, Annals of Math, 201 (2) 2025.
-/

set_option autoImplicit false

namespace HessianEstimates

open Laplacian Metric ContDiff MeasureTheory ENNReal

section Definitions

variable {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]

/-- Given a function `f : E → F` we define the `ℝ≥0∞`-valued `C¹` norm on `s : Set E` by:
`‖f‖_{C¹(s)} := ‖f‖_{L∞(s)} + ‖Df‖_{L∞(s)}`. -/
noncomputable def eC1NormOn [NormedSpace ℝ E] [NormedSpace ℝ F] [MeasurableSpace E]
    (f : E → F) (s : Set E) (μ : Measure E := by volume_tac) : ℝ≥0∞ :=
  eLpNorm f ∞ (μ.restrict s) + eLpNorm (fderiv ℝ f) ∞ (μ.restrict s)

variable [InnerProductSpace ℝ E] [InnerProductSpace ℝ F]

/-- Given `f : E → ℝ` and `s : Set E` we define the hessian operator `H` within `s` at `x` as a
linear map from `E` to `E` defined by the identity:

`⟨Hf(x) u, v⟩ = D²f(x) (u,v)`.

where `D²f(x)` is the second Frechet derivative of `f` within `s` at `x` as a bilinear operator. -/
noncomputable def H [CompleteSpace E] (f : E → ℝ) (s : Set E) (x : E) : E →L[ℝ] E :=
  InnerProductSpace.continuousLinearMapOfBilin (fderivWithin ℝ (fderivWithin ℝ f s) s x)

variable [FiniteDimensional ℝ E] [FiniteDimensional ℝ F]

/-- Given a linear map `T` from a finite-dimensional inner product space `E` to a finite-dimensional
inner product space `F` we define the Frobenius norm of `T` by `‖T‖_F := √ Trace (T^* ∘ T)`. -/
noncomputable def frobeniusNorm (T : E →L[ℝ] F) : ℝ :=
  √ ((T.toLinearMap.adjoint ∘ₗ T).trace ℝ E)

open Classical in
/-- Given a symmetric linear endomorphism `T` of a finite-dimensional inner product space `E` we
define: `σ₂ T := ∑ i ≤ i < j ≤ n, λᵢ * λⱼ` where `λᵢ` are the eigenvalues of `T`. When `T` is a
non-symmetric linear endomorphism we give it the junk value `0`. -/
noncomputable def σ₂ (T : E →L[ℝ] E) : ℝ :=
  if hT : T.IsSymmetric then
    ∑ j, ∑ i < j, hT.eigenvalues rfl i * hT.eigenvalues rfl j
  else
    0

end Definitions

local notation "‖" f "‖_C¹(" s ")" => eC1NormOn f s volume

local notation "‖" T "‖_F" => frobeniusNorm T

local notation "ℝ⁴" => EuclideanSpace ℝ (Fin 4)

local notation "B₁(0)" => ball 0 1



end HessianEstimates
