import Mathlib

namespace LeanEval
namespace Geometry
namespace SpaceGroupsProblem

/-!
# 230 space groups (Fedorov 1891 / Schoenflies 1891)

In dimension 3, there are exactly 230 space groups, reducing to 219 if
enantiomorphic (chiral) pairs are identified, with 65 of the 230 being
*Sohncke* groups — those whose isometries are all orientation-
preserving. §94 in Knill's *Some Fundamental Theorems in Mathematics*;
main work due to E. Fedorov (1891) and A. Schoenflies (1891),
independently.

The three counts correspond to two equivalences on crystallographic
groups: `AffinelyEquivalent` (Aff(ℝ³)-conjugacy, count = 219) and
`AffOPEquivalent` (orientation-preserving Aff(ℝ³)-conjugacy, count =
230). The "65 Sohncke groups" count restricts the underlying groups to
those whose elements are all orientation-preserving isometries.
-/

/-- The Euclidean model space `ℝᵈ`. -/
abbrev E (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- The Euclidean motion group `E_d`. -/
abbrev EuclideanIsom (d : ℕ) := E d ≃ᵃⁱ[ℝ] E d

/-- The affine group `Aff(ℝᵈ)`. -/
abbrev AffineGroup (d : ℕ) := E d ≃ᵃ[ℝ] E d

/-- `g ∈ E_d` is **translation by `v`**. -/
def IsTranslationBy {d : ℕ} (g : EuclideanIsom d) (v : E d) : Prop :=
  ∀ x : E d, g x = x + v

/-- A subgroup `G ≤ E_d` is **discrete** in the proper-discontinuity
sense. -/
def IsDiscrete {d : ℕ} (G : Subgroup (EuclideanIsom d)) : Prop :=
  ∀ x : E d, ∀ ε > (0 : ℝ),
    {g : EuclideanIsom d | g ∈ G ∧ dist (g x) x ≤ ε}.Finite

/-- A subgroup `G ≤ E_d` is **crystallographic**: discrete and contains
`d` linearly independent translations. -/
structure IsCrystallographicGroup {d : ℕ} (G : Subgroup (EuclideanIsom d)) : Prop where
  discrete : IsDiscrete G
  cocompact : ∃ v : Fin d → E d, LinearIndependent ℝ v ∧
    ∀ i, ∃ g : EuclideanIsom d, g ∈ G ∧ IsTranslationBy g (v i)

/-- The set of crystallographic groups in dimension `d`. -/
def CrystallographicGroup (d : ℕ) : Type :=
  { G : Subgroup (EuclideanIsom d) // IsCrystallographicGroup G }

/-- An affine isometry is **orientation-preserving** if its linear part
has positive determinant. -/
def IsOrientationPreservingIsom {d : ℕ} (g : EuclideanIsom d) : Prop :=
  0 < (g.toAffineEquiv.linear.det : ℝ)

/-- Two subgroups `G₁, G₂ ≤ E_d` are **affinely equivalent**. -/
def AffinelyEquivalent {d : ℕ} (G₁ G₂ : Subgroup (EuclideanIsom d)) : Prop :=
  ∃ φ : AffineGroup d,
    {h : AffineGroup d | ∃ g ∈ G₁, h = φ * g.toAffineEquiv * φ⁻¹} =
    {h : AffineGroup d | ∃ g ∈ G₂, h = g.toAffineEquiv}

/-- Two subgroups `G₁, G₂ ≤ E_d` are **orientation-preserving affinely
equivalent**: conjugation by a positive-determinant affine map takes
one to the other. -/
def AffOPEquivalent {d : ℕ} (G₁ G₂ : Subgroup (EuclideanIsom d)) : Prop :=
  ∃ φ : AffineGroup d, 0 < (φ.linear.det : ℝ) ∧
    {h : AffineGroup d | ∃ g ∈ G₁, h = φ * g.toAffineEquiv * φ⁻¹} =
    {h : AffineGroup d | ∃ g ∈ G₂, h = g.toAffineEquiv}

/-- Count of crystallographic groups modulo affine equivalence. -/
noncomputable def crystallographicCount (d : ℕ) : ℕ∞ :=
  Set.encard {S : Set (CrystallographicGroup d) |
    ∃ G₀ : CrystallographicGroup d,
      S = {H : CrystallographicGroup d | AffinelyEquivalent G₀.1 H.1}}

/-- Count of crystallographic groups modulo orientation-preserving
affine equivalence. -/
noncomputable def crystallographicCountOP (d : ℕ) : ℕ∞ :=
  Set.encard {S : Set (CrystallographicGroup d) |
    ∃ G₀ : CrystallographicGroup d,
      S = {H : CrystallographicGroup d | AffOPEquivalent G₀.1 H.1}}

/-- Count of orientation-preserving crystallographic groups modulo
orientation-preserving affine equivalence. -/
noncomputable def crystallographicCountOPOnly (d : ℕ) : ℕ∞ :=
  Set.encard {S : Set { G : CrystallographicGroup d //
                          ∀ g, g ∈ G.1 → IsOrientationPreservingIsom g } |
    ∃ G₀ : { G : CrystallographicGroup d //
              ∀ g, g ∈ G.1 → IsOrientationPreservingIsom g },
      S = {H | AffOPEquivalent G₀.1.1 H.1.1}}



end SpaceGroupsProblem
end Geometry
end LeanEval
