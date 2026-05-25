import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Geometry
namespace SchlafliClassification

/-!
# Schläfli classification

§42 of Knill's *Some Fundamental Theorems in Mathematics*. Schläfli's dimension-by-dimension enumeration of regular convex polytopes:
`p_3 = 5` (Euclid XIII), `p_4 = 6` (Schläfli's six 4-polytopes), and
`p_d = 3` for every `d ≥ 5` (regular simplex, hypercube, cross-polytope).
Does not include the `d = 2` case `p_2 = ∞`; see the companion Platonic
classification PR for the full tuple.

mathlib has `convexHull`, `extremePoints`, `IsExposed`, `vectorSpan`,
`AffineIsometryEquiv`, and `Set.encard`, but **no convex-polytope
datatype**, no face lattice, no regular-polytope concept, and none of the
classification counts. The Challenge ships ~1.5 pages of definitions
(`ConvexPolytope`, `dim`, `IsFace`, `Flag`, `isSymmetry`, `IsRegular`,
`Similar`, `regularPolytopes`, `regularSimilar`, `platonicCount`) on top
of mathlib.
-/

open scoped Topology

/-- The Euclidean model space `ℝⁿ`. -/
abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- A **convex polytope** in `ℝⁿ`: the convex hull of a finite nonempty set
whose listed vertices are exactly the extreme points of the hull. -/
structure ConvexPolytope (n : ℕ) where
  vertices : Finset (E n)
  vertices_nonempty : vertices.Nonempty
  vertices_eq_extremePoints :
    (vertices : Set (E n)) =
      Set.extremePoints ℝ (convexHull ℝ ((vertices : Set (E n))))

namespace ConvexPolytope

/-- The underlying convex set of the polytope. -/
def toSet {n : ℕ} (P : ConvexPolytope n) : Set (E n) :=
  convexHull ℝ ((P.vertices : Set (E n)))

/-- The affine dimension of `P`. -/
noncomputable def dim {n : ℕ} (P : ConvexPolytope n) : ℕ :=
  Module.finrank ℝ (vectorSpan ℝ P.toSet)

/-- `P` is **full-dimensional** if `dim P = n`. -/
def IsFullDim {n : ℕ} (P : ConvexPolytope n) : Prop := P.dim = n

/-- A **face** of `P` is a nonempty exposed subset. -/
def IsFace {n : ℕ} (P : ConvexPolytope n) (F : Set (E n)) : Prop :=
  IsExposed ℝ P.toSet F ∧ F.Nonempty

/-- The affine dimension of a subset of `ℝⁿ`. -/
noncomputable def faceDim {n : ℕ} (F : Set (E n)) : ℕ :=
  Module.finrank ℝ (vectorSpan ℝ F)

/-- A **flag** of a full-dimensional `n`-polytope `P`: a strictly
increasing chain `F_0 ⊂ F_1 ⊂ ⋯ ⊂ F_{n−1}` of faces with `faceDim F_k = k`. -/
structure Flag {n : ℕ} (P : ConvexPolytope n) where
  face : Fin n → Set (E n)
  isFace : ∀ k, P.IsFace (face k)
  dim_eq : ∀ k : Fin n, faceDim (face k) = k.val
  strict_mono : ∀ i j : Fin n, i < j → face i ⊂ face j

/-- Affine isometries of `ℝⁿ` — the rigid motions. -/
abbrev Isom (n : ℕ) := E n ≃ᵃⁱ[ℝ] E n

/-- `φ` is a **symmetry** of `P` if it maps `P` onto itself. -/
def isSymmetry {n : ℕ} (P : ConvexPolytope n) (φ : Isom n) : Prop :=
  ((φ : E n → E n)) '' P.toSet = P.toSet

/-- `P` is **regular** (Platonic) if it is full-dimensional and its
symmetry group acts transitively on its flags. -/
def IsRegular {n : ℕ} (P : ConvexPolytope n) : Prop :=
  P.IsFullDim ∧
    ∀ F G : P.Flag, ∃ φ : Isom n,
      P.isSymmetry φ ∧
        ∀ k : Fin n, ((φ : E n → E n)) '' F.face k = G.face k

/-- Two polytopes are **similar** when related by a positive scaling and an
affine isometry. -/
def Similar {n : ℕ} (P Q : ConvexPolytope n) : Prop :=
  ∃ a : ℝ, 0 < a ∧ ∃ φ : Isom n,
    Q.toSet = (fun x : E n => a • x) '' ((φ : E n → E n) '' P.toSet)

end ConvexPolytope

/-- The set of regular (Platonic) polytopes in dimension `d`. -/
def regularPolytopes (d : ℕ) : Set (ConvexPolytope d) :=
  {P | P.IsRegular}

/-- The similarity relation on regular polytopes in dimension `d`. -/
def regularSimilar (d : ℕ) (P Q : regularPolytopes d) : Prop :=
  ConvexPolytope.Similar (P : ConvexPolytope d) (Q : ConvexPolytope d)

/-- `p_d` — count of Platonic polytopes in dimension `d` up to similarity,
in `ℕ∞ = ℕ ∪ {⊤}` so `⊤` records "infinitely many". -/
noncomputable def platonicCount (d : ℕ) : ℕ∞ :=
  Set.encard {S : Set (regularPolytopes d) |
    ∃ P, S = {Q : regularPolytopes d | regularSimilar d P Q}}

/-- **Schläfli classification.** `p_3 = 5 ∧ p_4 = 6 ∧ ∀ d ≥ 5, p_d = 3`. -/
@[eval_problem]
theorem schlafli_classification :
    platonicCount 3 = 5 ∧
      platonicCount 4 = 6 ∧
        ∀ d, 5 ≤ d → platonicCount d = 3 := by
  sorry

end SchlafliClassification
end Geometry
end LeanEval
