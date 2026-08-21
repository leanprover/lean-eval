import Mathlib.Analysis.Complex.Exponential
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from A conjecture of Erdős, supersingular primes and short character sums

We formalise the statement of the main result from M. Bennett and S. Siksek,
`A conjecture of Erdős, supersingular primes and short character sums`,
Annals of Math, 191 (2) 2020.
-/

set_option autoImplicit false

namespace ErdosSupersingularPrimes

open Int Real

/-- A solution to the Diophantine equation `n (n + d) (n + 2d) ··· (n + (k − 1)d) = y ^ l`,
where `gcd(n, d) = 1`. -/
structure Solution (k : ℕ) where
  /-- The exponent `l` in the solution. -/
  l : ℕ
  /-- The value of `n` in the solution. -/
  n : ℤ
  /-- The value of `d` in the solution. -/
  d : ℤ
  /-- The value of `y` in the solution. -/
  y : ℤ
  gcd : gcd n d = 1
  eq : ∏ i ∈ Finset.range k, (n + i * d) = y ^ l





end ErdosSupersingularPrimes
