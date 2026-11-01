import Mathlib

namespace LeanEval.LinearAlgebra.TraceNewton

/-!
# Trace Cayley-Hamilton / Newton identity

`trace_cayley_hamilton_newton`: the Newton trace recurrence for the
coefficients of the characteristic polynomial,
`k cₖ + ∑_{j=1}^k tr(Aʲ) c_{k-j} = 0`, where `χ_A(X) = Xᴺ + c₁ Xᴺ⁻¹ + ⋯ + c_N`.
Trusted helper `charpolyDescendingCoeff` (non-hole). Category-(b) candidate from
§220 of the Knill survey.
-/

open Matrix Polynomial
open scoped BigOperators Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The coefficient `c_k` in the usual monic characteristic-polynomial
expansion `χ_A(X) = X^N + c₁ X^(N-1) + ... + c_N`.

Mathlib's `Matrix.charpoly` is the monic characteristic polynomial
`det (X • 1 - A)`, so this is the coefficient of degree `N - k`.
For `k > N`, the coefficient is `0`, which lets the trace recurrence be
stated uniformly for all positive `k`. -/
noncomputable def charpolyDescendingCoeff {R : Type*} [CommRing R]
    (A : Matrix n n R) (k : ℕ) : R :=
  if k ≤ Fintype.card n then
    Polynomial.coeff A.charpoly (Fintype.card n - k)
  else
    0



end LeanEval.LinearAlgebra.TraceNewton
