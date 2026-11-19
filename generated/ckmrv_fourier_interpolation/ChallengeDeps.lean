import Mathlib

namespace LeanEval.Analysis.CKMRVInterpolation

/-!
# Fourier interpolation in dimensions 8 and 24

Cohn, Kumar, Miller, Radchenko, and Viazovska proved that a radial Schwartz
function on `R^8` or `R^24` is determined by the values and radial derivatives
of the function and its Fourier transform at the nonzero vector lengths of
the `E8` or Leech lattice. More strongly, every four rapidly decreasing
sequences occur uniquely as these samples.

The equivalence in `CKMRV` is pinned to the sampling map itself, so the
statement does not hide interpolation basis functions in trusted definitions.
-/

open Filter Topology
open scoped FourierTransform SchwartzMap

/-- A function is radial if it takes the same value at points with the same norm. -/
def Radial {E F : Type*} [Norm E] (f : E → F) : Prop :=
  ∀ e e' : E, ‖e‖ = ‖e'‖ → f e = f e'

/-- Inclusion of a coordinate axis into Euclidean space. -/
abbrev realIncl {n : ℕ} [NeZero n] (r : ℝ) : EuclideanSpace ℝ (Fin n) :=
  WithLp.toLp 2 (if · = 0 then r else 0)

/-- The four sample sequences: values of `f` and its Fourier transform,
followed by their radial derivatives, at radii `sqrt (2 * k)`. -/
noncomputable def coeffs (n k₀ : ℕ) [NeZero n]
    (f : 𝓢(EuclideanSpace ℝ (Fin n), ℂ)) :
    (Set.Ici k₀ × Fin 4) → ℂ :=
  Function.uncurry fun k ↦
    let r := Real.sqrt (2 * k)
    let fhat :=
      FourierTransform.fourierCLM ℂ (𝓢(EuclideanSpace ℝ (Fin n), ℂ)) f
    ![f (realIncl r), fhat (realIncl r),
      deriv (f ∘ realIncl) r, deriv (fhat ∘ realIncl) r]

/-- A complex sequence indexed by integers at least `k₀` is rapidly decreasing
if multiplication by every natural power of the index still tends to zero. -/
def RapidlyDecreasing {k₀ : ℕ} (a : Set.Ici k₀ → ℂ) : Prop :=
  ∀ m : ℕ,
    Tendsto (fun k ↦ (k.1 : ℝ) ^ m * ‖a k‖) atTop (𝓝 0)

/-- Four rapidly decreasing sample sequences. -/
def RapidlyDecreasingSamples {k₀ : ℕ}
    (a : (Set.Ici k₀ × Fin 4) → ℂ) : Prop :=
  ∀ j, RapidlyDecreasing fun k ↦ a (k, j)

/-- Radial complex-valued Schwartz functions on `R^n`. -/
abbrev RadialSchwartz (n : ℕ) :=
  {f : 𝓢(EuclideanSpace ℝ (Fin n), ℂ) // Radial f}

/-- Four rapidly decreasing complex sample sequences indexed from `k₀`. -/
abbrev RapidSampleData (k₀ : ℕ) :=
  {a : (Set.Ici k₀ × Fin 4) → ℂ // RapidlyDecreasingSamples a}

/-- The full Fourier sampling isomorphism with dimension and starting index
as parameters. The equivalence is required to be the sampling map `coeffs`. -/
def CKMRV (n k₀ : ℕ) [NeZero n] : Prop :=
  ∃ e : RadialSchwartz n ≃ RapidSampleData k₀,
    ∀ f, (e f).1 = coeffs n k₀ f.1



end LeanEval.Analysis.CKMRVInterpolation
