import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Combinatorics
namespace UpperBoundSimplicialSpheresProblem

/-!
# Upper bound theorem for simplicial spheres (Stanley 1975),
geometrically-embedded variant

Among finite `(d − 1)`-dimensional simplicial spheres with `n`
vertices, the cyclic polytope `C(n, d)` maximises every face number
`f_k`. Conjectured by Motzkin (1957); McMullen 1970 for the polytope
case; Stanley 1975 extended to all finite simplicial spheres via the
Stanley–Reisner face-ring proof. §142 in Knill's *Some Fundamental
Theorems in Mathematics*.

The Lean encoding `FiniteSimplicialSphere d` uses mathlib's
`Geometry.SimplicialComplex ℝ (EuclideanSpace ℝ (Fin d))` — finite
geometric complexes linearly embedded in `ℝᵈ` whose underlying space
is homeomorphic to the unit sphere in `ℝᵈ`. Stanley's full theorem
applies to *all* finite abstract simplicial spheres, and our
geometric class is a subset (not every abstract finite simplicial
sphere embeds linearly in `ℝᵈ`), so Stanley 1975 *implies* the
statement here.

Mathlib has the finite-simplicial-complex substrate
(`AbstractSimplicialComplex`, `Geometry.SimplicialComplex` with
`faces` / `vertices` / `facets` / `space`) but no cyclic polytopes,
h-vectors, g-vectors, Dehn–Sommerville, face rings, or upper bound
theorem.
-/

noncomputable section

open BigOperators

/-- The ambient Euclidean space for a `(d − 1)`-sphere. -/
abbrev E (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- A finite geometric simplicial complex whose underlying space is
homeomorphic to the standard `(d − 1)`-sphere in `ℝᵈ`. -/
structure FiniteSimplicialSphere (d : ℕ) where
  K : Geometry.SimplicialComplex ℝ (E d)
  finite_faces : K.faces.Finite
  sphere_homeomorph : Nonempty (K.space ≃ₜ Metric.sphere (0 : E d) 1)

/-- Number of `k`-dimensional faces (faces with `k + 1` vertices). -/
def faceCount {d : ℕ} (X : FiniteSimplicialSphere d) (k : ℕ) : ℕ :=
  {s : Finset (E d) | s ∈ X.K.faces ∧ s.card = k + 1}.ncard

/-- Extended f-vector entry: `f_{-1} = 1`, and `f_i` thereafter. -/
def extendedFaceCount {d : ℕ} (X : FiniteSimplicialSphere d) (i : ℕ) : ℕ :=
  if i = 0 then 1 else faceCount X (i - 1)

/-- h-vector entry of `X`, via the binomial transform of the f-vector. -/
def hVector {d : ℕ} (X : FiniteSimplicialSphere d) (j : ℕ) : ℤ :=
  ∑ i ∈ Finset.range (j + 1),
    (-1 : ℤ) ^ (j - i) * (Nat.choose (d - i) (j - i) : ℤ) *
      (extendedFaceCount X i : ℤ)

/-- h-vector of the cyclic polytope `C(n, d)`: first half
`choose (n − d − 1 + j) j`, second half symmetric. -/
def cyclicH (n d j : ℕ) : ℕ :=
  Nat.choose (n - d - 1 + min j (d - j)) (min j (d - j))

/-- Face number `f_k(C(n, d))`, via the inverse h-to-f transform. -/
def cyclicPolytopeFaceCount (n d k : ℕ) : ℕ :=
  ∑ j ∈ Finset.range (k + 2),
    Nat.choose (d - j) (k + 1 - j) * cyclicH n d j

/-- **Upper bound theorem for simplicial spheres** (Stanley 1975).
Every `k`-face count of a finite simplicial `(d − 1)`-sphere with `n`
vertices is bounded above by the corresponding face count of the
cyclic polytope `C(n, d)`. -/
@[eval_problem]
theorem upper_bound_theorem_simplicial_spheres
    {d n k : ℕ} (X : FiniteSimplicialSphere d)
    (_hn : faceCount X 0 = n) (_hk : k < d) :
    faceCount X k ≤ cyclicPolytopeFaceCount n d k := by
  sorry

end

end UpperBoundSimplicialSpheresProblem
end Combinatorics
end LeanEval
