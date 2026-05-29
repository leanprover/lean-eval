import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace WallpaperGroupsProblem

/-!
# Seventeen wallpaper groups (Pólya–Niggli 1924)

There are exactly 17 wallpaper groups, the discrete cocompact subgroups
of the Euclidean motion group `E_2` (planar affine isometries), counted
up to affine equivalence. Pólya–Niggli 1924; §94 in Knill's *Some
Fundamental Theorems in Mathematics*.

The discreteness definition uses properly-discontinuous-action
(positive minimal distance from each orbit point) rather than the
topology-on-`E_d` formulation, since mathlib does not equip the
affine-isometry equivalence type with a default topology. The two
formulations agree for subgroups of `E_d` once `E_d` is given the
standard Lie-group topology.
-/

/-- The Euclidean model space `ℝᵈ`. -/
abbrev E (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- The Euclidean motion group `E_d`: affine isometries of `ℝᵈ`. -/
abbrev EuclideanIsom (d : ℕ) := E d ≃ᵃⁱ[ℝ] E d

/-- The affine group `Aff(ℝᵈ)`: invertible affine self-maps of `ℝᵈ`. -/
abbrev AffineGroup (d : ℕ) := E d ≃ᵃ[ℝ] E d

/-- `g ∈ E_d` is **translation by `v`** if it acts as `x ↦ x + v`. -/
def IsTranslationBy {d : ℕ} (g : EuclideanIsom d) (v : E d) : Prop :=
  ∀ x : E d, g x = x + v

/-- A subgroup `G ≤ E_d` is **discrete** (proper discontinuity): for
every `x ∈ ℝᵈ` and every `ε > 0`, only finitely many `g ∈ G` satisfy
`dist (g x) x ≤ ε`. -/
def IsDiscrete {d : ℕ} (G : Subgroup (EuclideanIsom d)) : Prop :=
  ∀ x : E d, ∀ ε > (0 : ℝ),
    {g : EuclideanIsom d | g ∈ G ∧ dist (g x) x ≤ ε}.Finite

/-- A subgroup `G ≤ E_d` is **crystallographic** if it is discrete and
contains `d` linearly independent translations (equivalently, acts
cocompactly on `ℝᵈ`). -/
structure IsCrystallographicGroup {d : ℕ} (G : Subgroup (EuclideanIsom d)) : Prop where
  discrete : IsDiscrete G
  cocompact : ∃ v : Fin d → E d, LinearIndependent ℝ v ∧
    ∀ i, ∃ g : EuclideanIsom d, g ∈ G ∧ IsTranslationBy g (v i)

/-- Two subgroups `G₁, G₂ ≤ E_d` are **affinely equivalent** if some
`φ ∈ Aff(ℝᵈ)` conjugates one into the other (inside `Aff(ℝᵈ)` via
`AffineIsometryEquiv.toAffineEquiv`). -/
def AffinelyEquivalent {d : ℕ} (G₁ G₂ : Subgroup (EuclideanIsom d)) : Prop :=
  ∃ φ : AffineGroup d,
    {h : AffineGroup d | ∃ g ∈ G₁, h = φ * g.toAffineEquiv * φ⁻¹} =
    {h : AffineGroup d | ∃ g ∈ G₂, h = g.toAffineEquiv}

/-- The set of crystallographic groups in dimension `d`. -/
def CrystallographicGroup (d : ℕ) : Type :=
  { G : Subgroup (EuclideanIsom d) // IsCrystallographicGroup G }

/-- Count of crystallographic groups in dimension `d`, modulo affine
equivalence, as `ℕ∞`. -/
noncomputable def crystallographicCount (d : ℕ) : ℕ∞ :=
  Set.encard {S : Set (CrystallographicGroup d) |
    ∃ G₀ : CrystallographicGroup d,
      S = {H : CrystallographicGroup d | AffinelyEquivalent G₀.1 H.1}}

/-- **There are exactly 17 wallpaper groups** (Pólya–Niggli 1924). -/
@[eval_problem]
theorem there_are_17_wallpaper_groups :
    crystallographicCount 2 = 17 := by
  sorry

end WallpaperGroupsProblem
end Geometry
end LeanEval
