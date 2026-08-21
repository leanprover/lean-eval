import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

namespace LeanEval.Analysis.TenMartini

/-!
# The Ten Martini Problem

Avila and Jitomirskaya proved that the spectrum of the almost Mathieu
operator is a Cantor set for every irrational frequency and every nonzero
coupling constant.

The operator acts on `l^2(Z)` by

`(H u)(n) = u(n+1) + u(n-1) + 2 lambda cos(2 pi (theta + n alpha)) u(n)`.

We specify this coordinate formula transparently and ask for construction of
the bounded operator as part of the theorem, so the spectral conclusion does
not rest on an existence hypothesis.
-/

open Set

/-- The Hilbert space `l^2(Z)` of square-summable complex sequences. -/
abbrev EllTwo : Type := lp (fun _ : ℤ => ℂ) 2

/-- A bounded operator on `l^2(Z)` has the almost Mathieu coordinate formula
with frequency `alpha`, coupling `lambda`, and phase `theta`. -/
def IsAlmostMathieuOperator (α coupling θ : ℝ) (H : EllTwo →L[ℂ] EllTwo) : Prop :=
  ∀ (u : EllTwo) (n : ℤ),
    H u n =
      u (n + 1) + u (n - 1) +
        ((2 * coupling * Real.cos (2 * Real.pi * (θ + (n : ℝ) * α) : ℝ) : ℂ) * u n)



end LeanEval.Analysis.TenMartini
