import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Gauss–Wantzel constructibility theorem (prime case)

§87 (additional statement 3) of Knill's *Some Fundamental Theorems in
Mathematics*. For an odd prime `p`, the regular `p`-gon (equivalently
`cos(2π/p)`) is ruler-and-compass constructible iff `p` is a Fermat
prime `2^(2^k) + 1`. This is Knill's "n is a Fermat prime" specialised
to prime `n`; the full Gauss–Wantzel theorem allows
`n = 2^a · ∏ distinct Fermat primes`.

Mathlib has Galois theory, cyclotomic fields (`CyclotomicField`,
`IsCyclotomicExtension`), and Fermat-number infrastructure
(`Nat.fermatNumber`), but no ruler-and-compass constructibility theory
and no Gauss–Wantzel theorem. `grep -ri 'constructible.*real\|gauss[_-]?wantzel'`
in mathlib returns no hits.

We bundle a small algebraic characterisation of the constructible reals:
the smallest subfield of `ℝ` closed under real square roots. This is the
textbook algebraic equivalent of the geometric notion (ruler-and-compass
constructible reals = `ℚ`-tower of degree-2 extensions in `ℝ`), and is
the form needed to apply Galois theory.

The proof reduces to the equivalence:
`cos(2π/p)` constructible ⇔ `[ℚ(cos(2π/p)) : ℚ]` is a power of 2 ⇔
`p − 1` is a power of 2 ⇔ `p` is a Fermat prime.
-/

/-- The constructible reals: the smallest subfield of `ℝ` closed under
real square roots. -/
inductive IsConstructible : ℝ → Prop
  | base (q : ℚ) : IsConstructible (q : ℝ)
  | add {x y} : IsConstructible x → IsConstructible y → IsConstructible (x + y)
  | neg {x} : IsConstructible x → IsConstructible (-x)
  | mul {x y} : IsConstructible x → IsConstructible y → IsConstructible (x * y)
  | inv {x} : IsConstructible x → IsConstructible x⁻¹
  | sqrt {x} : IsConstructible x → IsConstructible (Real.sqrt x)

/-- **Gauss–Wantzel theorem (prime case).** For an odd prime `p`,
`cos(2π/p)` is ruler-and-compass constructible iff `p` is a Fermat prime
`2^(2^k) + 1`. -/
@[eval_problem]
theorem gauss_wantzel_prime (p : ℕ) (_hp : p.Prime) (_hodd : Odd p) :
    IsConstructible (Real.cos (2 * Real.pi / p)) ↔ ∃ k : ℕ, p = 2 ^ (2 ^ k) + 1 := by
  sorry

end NumberTheory
end LeanEval
