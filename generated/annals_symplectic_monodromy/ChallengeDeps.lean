import Mathlib.Analysis.CStarAlgebra.Classes
import Mathlib.LinearAlgebra.Dimension.Basic
import Mathlib.RingTheory.Ideal.Quotient.Defs
import Mathlib.RingTheory.MvPowerSeries.Derivative
import Mathlib.Topology.UnitInterval
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Symplectic monodromy at radius zero and equimultiplicity of
# μ-constant families

We formalise the statement of the main result from J. Fernández de Bobadilla and T. Pełka,
`Symplectic monodromy at radius zero and equimultiplicity of μ-constant families`,
Annals of Math, 200 (1) 2024.
-/

set_option autoImplicit false

namespace SymplecticMonodromy

open MvPowerSeries

/-- The Milnor number of `f` is `dim_ℂ ℂ⟦z₁, ⋯, zₙ⟧ / ⟨∂f/∂z₁, ⋯, ∂f/∂zₙ⟩`. -/
noncomputable def milnorNumber {σ R : Type*} [CommRing R] (f : MvPowerSeries σ R) : ℕ∞ :=
  (Module.rank R (MvPowerSeries σ R ⧸ Ideal.span (Set.range (pderiv R · f)))).toENat



end SymplecticMonodromy
