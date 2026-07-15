import Mathlib

namespace LeanEval.Combinatorics.DehnSommerville

/-!
# The Dehn–Sommerville equations for simplicial spheres

`dehn_sommerville`: the h-vector of a finite simplicial `(d-1)`-sphere is
symmetric, `h_j = h_{d-j}`. Trusted helpers (`FiniteSimplicialSphere`,
`faceCount`, `extendedFaceCount`, `hVector`) are non-holes. Mathlib has
simplicial complexes but no f- or h-vector or Dehn–Sommerville theory. (The
companion upper-bound theorem for simplicial spheres is already in lean-eval.)
Category-(b) candidate from §142 of the Knill survey.
-/

/-- A finite geometric simplicial complex homeomorphic to the `(d-1)`-sphere. -/
structure FiniteSimplicialSphere (d : ℕ) where
  K : Geometry.SimplicialComplex ℝ (EuclideanSpace ℝ (Fin d))
  finite_faces : K.faces.Finite
  sphere_homeomorph :
    Nonempty (K.space ≃ₜ Metric.sphere (0 : EuclideanSpace ℝ (Fin d)) 1)

/-- Number of `k`-dimensional faces (faces with `k+1` vertices). -/
noncomputable def faceCount {d : ℕ} (X : FiniteSimplicialSphere d) (k : ℕ) : ℕ :=
  {s : Finset (EuclideanSpace ℝ (Fin d)) | s ∈ X.K.faces ∧ s.card = k + 1}.ncard

/-- Extended f-vector entry: `f_{-1} = 1`, then `f_{i-1}`. -/
noncomputable def extendedFaceCount {d : ℕ} (X : FiniteSimplicialSphere d) (i : ℕ) : ℕ :=
  if i = 0 then 1 else faceCount X (i - 1)

/-- The h-vector via the alternating binomial transform of the f-vector. -/
noncomputable def hVector {d : ℕ} (X : FiniteSimplicialSphere d) (j : ℕ) : ℤ :=
  ∑ i ∈ Finset.range (j + 1),
    (-1 : ℤ) ^ (j - i) * (Nat.choose (d - i) (j - i) : ℤ) *
      (extendedFaceCount X i : ℤ)



end LeanEval.Combinatorics.DehnSommerville
