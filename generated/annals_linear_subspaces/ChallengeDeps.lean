import Mathlib.Algebra.Module.ZLattice.Basic
import Mathlib.Analysis.InnerProductSpace.ExteriorPower
import Mathlib.Geometry.Euclidean.Angle.Unoriented.Basic
import Mathlib.LinearAlgebra.Projectivization.Basic
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Rational approximations to linear subspaces

We formalise the statement of the main result from N. de Saxcé,
`Rational approximations to linear subspaces`, Annals of Math, 203 (3) 2026.
-/

set_option autoImplicit false

noncomputable section

namespace LinearSubspaces

open ENNReal Real Module exteriorPower InnerProductGeometry

open scoped LinearAlgebra.Projectivization

variable {d : ℕ}

local notation "ℝᵈ" => EuclideanSpace ℝ (Fin d)

/-- When `x = x¹` and `y = y¹` are lines, the distance is the usual distance on the
projective space, given by `d(x¹,y¹) = sin ∡(x¹,y¹)`. -/
def distLines (x y : ℙ ℝ ℝᵈ) : ℝ := sin (angle x.rep y.rep)

/-- Then, if `x = x¹` is a line and `y = yᵏ` a k-dimensional subspace, we set
`d(x¹,yᵏ) = min { d(x¹, y¹) : y¹ ≤ yᵏ }`. -/
def distLineSubspace (x : ℙ ℝ ℝᵈ) (y : Submodule ℝ ℝᵈ) : ℝ :=
  ⨅ y' : {y' : ℙ ℝ ℝᵈ // y'.submodule ≤ y}, distLines x y'.1

/-- Finally, in general, if `x = xˡ` is `l`-dimensional and `y = yᵏ` is `k`-dimensional, then
`d(xˡ, yᵏ) = max { d(y¹, xˡ) : y¹ ≤ yᵏ }`, if `k ≤ l`, and
`d(xˡ, yᵏ) = max { d(x¹, yᵏ) : x¹ ≤ xˡ }`, if `k ≥ l`. -/
def distSubspaces (x y : Submodule ℝ ℝᵈ) : ℝ :=
  if finrank ℝ y ≤ finrank ℝ x then
    ⨆ y' : {y' : ℙ ℝ ℝᵈ // y'.submodule ≤ y}, distLineSubspace y'.1 x
  else
    ⨆ x' : {x' : ℙ ℝ ℝᵈ // x'.submodule ≤ x}, distLineSubspace x'.1 y

/-- The lattice `ℤᵈ`, as a `ℤ`-submodule of `ℝᵈ`. -/
abbrev intPoints : Submodule ℤ ℝᵈ :=
  .span ℤ (Set.range (EuclideanSpace.basisFun (Fin d) ℝ).toBasis)

local notation "ℤᵈ" => intPoints

/-- Given a subspace `V ≤ ℝᵈ`, this is the set `V ∩ ℤᵈ` as a `ℤ`-submodule of `V`. -/
def intPointsSubspace (V : Submodule ℝ ℝᵈ) : Submodule ℤ V :=
  ZLattice.comap ℝ ℤᵈ V.subtype

instance (V : Submodule ℝ ℝᵈ) : DiscreteTopology (intPointsSubspace V) :=
  ZLattice.comap_discreteTopology ℝ _ (by fun_prop) V.injective_subtype

/-- A subspace `V ≤ ℝᵈ` is called rational, if `V ∩ ℤᵈ` is a full-rank lattice in `V`.
Note that the paper never explicitly mentions the definition of "rational subspace" they are
using. The one we use here is common, and it is the most convenient for defining heights
of rational subspaces below. -/
abbrev IsRational (V : Submodule ℝ ℝᵈ) : Prop :=
  IsZLattice ℝ (intPointsSubspace V)

/-- For a rational subspace `V ≤ ℝᵈ`, a choice of a `ℤ`-basis of the lattice `V ∩ ℤᵈ`, viewed
as an `ℝ`-basis of `V`. -/
def chosenBasis (V : Submodule ℝ ℝᵈ) (hV : IsRational V) : Basis (Fin (finrank ℝ V)) ℝ V :=
  .ofZLatticeBasis ℝ _ <| .reindex (Free.chooseBasis ℤ (intPointsSubspace V)) <|
    Fintype.equivFinOfCardEq <| by rw [← finrank_eq_card_chooseBasisIndex, ZLattice.rank ℝ]

/-- For a rational subspace `V ≤ ℝᵈ`, choose a basis `v₁, ... vₖ` for the subgroup `V ∩ ℤᵈ`.
The height is defined as `H(v) = ‖v₁ ∧ ··· ∧ vₖ‖`, where the norm on `⋀ᵏ ℝᵈ` is the usual
Euclidean norm. -/
def height (V : Submodule ℝ ℝᵈ) (hV : IsRational V) : ℝ :=
  ‖ιMulti ℝ _ (V.subtype ∘ chosenBasis V hV)‖

/-- For a subspace `x ≤ ℝᵈ` and `k : ℕ`, define the diophantine exponent of `x`
for approximation by `k`-dimensional rational subspaces by
`βₖ(x) = inf { β > 0 | ∃ c > 0 : ∀ v ∈ Xₖ(ℚ), d(v, x) ≥ c * H(v)^(−β) }.` -/
def diophantineExponent (k : ℕ) (x : Submodule ℝ ℝᵈ) : ℝ≥0∞ :=
  sInf (.ofReal '' {β : ℝ | β > 0 ∧ ∃ c > 0, ∀ v : Submodule ℝ ℝᵈ, finrank ℝ v = k →
    (hv : IsRational v) → distSubspaces v x ≥ c * height v hv ^ (-β)})



end LinearSubspaces

end
