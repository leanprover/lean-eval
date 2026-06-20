import Mathlib
import EvalTools.Markers

namespace LeanEval.LinearAlgebra.CanadaDay

/-!
# Canada Day theorem

`canada_day_theorem`: for every symmetric integer matrix `A`, the sum of all
`k × k` minors of `A` equals the sum of the principal `k × k` minors of `T * A`,
where `T` is the fixed lower-triangular matrix with entries `1`, `2`, and `0`.
Trusted helpers (`canadaDayT`, `SubsetCard`, `subsetEmbedding`, `minorDet`,
`allMinorSum`, `principalMinorSum`) are non-holes. Mathlib has determinants and
submatrices but not this minor-sum identity. Category-(b) candidate from §186 of
the Knill survey.
-/

open Matrix

variable {n k : ℕ}

/-- The fixed lower-triangular matrix `T` used in the Canada Day theorem. -/
def canadaDayT (n : ℕ) : Matrix (Fin n) (Fin n) ℤ :=
  fun i j => if j < i then 2 else if i = j then 1 else 0

/-- The `k`-element subsets of `Fin n`. -/
abbrev SubsetCard (n k : ℕ) := {s : Finset (Fin n) // s.card = k}

/-- The increasing enumeration `Fin k → Fin n` of a `k`-element subset. -/
def subsetEmbedding (I : SubsetCard n k) : Fin k → Fin n :=
  fun i => (I.1.orderIsoOfFin I.2 i : Fin n)

/-- The determinant of the submatrix of `A` with row set `I` and column set `J`. -/
def minorDet (A : Matrix (Fin n) (Fin n) ℤ)
    (I J : SubsetCard n k) : ℤ :=
  (A.submatrix (subsetEmbedding I) (subsetEmbedding J)).det

/-- Sum of all `k × k` minors of a square matrix. -/
def allMinorSum (A : Matrix (Fin n) (Fin n) ℤ) (k : ℕ) : ℤ :=
  ∑ I : SubsetCard n k, ∑ J : SubsetCard n k,
    minorDet A I J

/-- Sum of principal `k × k` minors of a square matrix. -/
def principalMinorSum (A : Matrix (Fin n) (Fin n) ℤ) (k : ℕ) : ℤ :=
  ∑ I : SubsetCard n k, minorDet A I I

/-- **Canada Day theorem.** For every symmetric integer matrix `A`, the sum of
all `k × k` minors of `A` equals the sum of the principal `k × k` minors of
`T * A`, where `T` is the fixed lower-triangular matrix with entries `1`, `2`,
and `0`. -/
@[eval_problem]
theorem canada_day_theorem (A : Matrix (Fin n) (Fin n) ℤ) (hA : A.IsSymm) :
    allMinorSum A k = principalMinorSum (canadaDayT n * A) k := by
  sorry

end LeanEval.LinearAlgebra.CanadaDay
