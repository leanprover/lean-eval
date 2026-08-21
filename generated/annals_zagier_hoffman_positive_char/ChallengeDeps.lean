import Mathlib.NumberTheory.FunctionField
import Mathlib.RingTheory.SimpleRing.Principal
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statements from On Zagier-Hoffman's conjectures in positive characteristic

We formalise the statements of the main results from T. N. Dac,
`On Zagier-Hoffman's conjectures in positive characteristic`, Annals of Math, 194 (1) 2021.

## Implementation Details

Throughout the definitions and statements, we reindex the `i`'s so that they run from `0`
to `r - 1` rather than from `1` to `r`.
-/

set_option autoImplicit false

namespace ZagierHoffmanPositiveChar

open NNReal Polynomial RatFunc

variable (F : Type*) [Field F] [Finite F] [DecidableEq (RatFunc F)]

/-- The set of `r`-tuples `(a_1,..., a_r)` of monic polynomials over the finite field `F`, such that
`deg a_1 > deg a_2 > ... > deg a_r`. -/
abbrev monicStrictAntiNatDegree (r : ℕ) :=
  {a : Fin r → Polynomial F // StrictAnti (Polynomial.natDegree ∘ a) ∧ ∀ i, (a i).Monic}

/-- Multiple zeta value (MZV) `ζ_A (s_1, ..., s_r)` in positive characteristic. -/
noncomputable def ζ_A {r : ℕ} (𝔰 : Fin r → ℕ+) : CompletionAtInfty F :=
  ∑' a : monicStrictAntiNatDegree F r, (∏ i, a.val i ^ (𝔰 i : ℕ))⁻¹

/-- `𝔖_w` is the set of `r`-tuples of positive natural numbers whose sum is `w`. -/
def 𝔖_w (w : ℕ) (r : ℕ) : Set (Fin r → ℕ+) := {𝔰 : Fin r → ℕ+ | ∑ i : Fin r, (𝔰 i : ℕ) = w}

/-- The multiple zeta value function `ζ_A 𝔰` is said to have weight `w` if `∑ i : Fin r, 𝔰 i = w`.
Below, we define the set of multiple zeta values (MZVs) `ζ_A (s_1,..., s_r)` of weight `w`. -/
def ζ_A_weight (w : ℕ) (r : ℕ) : Set (CompletionAtInfty F) := {ζ_A F 𝔰 | 𝔰 ∈ 𝔖_w w r}

/-- For `w ∈ ℕ`, define `𝒵 w` to be the vector space over the field of rational functions over `F`,
spanned by the MZVs of weight `w`. Note that in the paper, `RatFunc F` is denoted by `K`. -/
noncomputable def 𝒵 (w : ℕ) : Submodule (RatFunc F) (CompletionAtInfty F) :=
  Submodule.span (RatFunc F) (⋃ r, ζ_A_weight F w r)

/-- Let `q` be the size of the finite field `F`. `𝒯_aux w r` is the set of `ζ_A(s_1, ..., s_r)` of
weight `w`, with `1 ≤ s_i ≤ q` for `1 ≤ i ≤ r − 1` and `1 ≤ s_r < q`. -/
def 𝒯_aux (w : ℕ) (r : ℕ+) : Set (CompletionAtInfty F) :=
  let q := Nat.card F
  let 𝔖'_w := {𝔰 ∈ 𝔖_w w r | (∀ i : Fin r, i < (r - 1 : ℕ) → 𝔰 i ≤ q) ∧ 𝔰 ⟨r - 1, by simp⟩ < q}
  {ζ_A F s | s ∈ 𝔖'_w}

/-- Let `q` be the size of the finite field `F`. `𝒯_w` is the set of `ζ_A(s_1,..., s_r)` of weight
`w`, with `1 ≤ s_i ≤ q` for `1 ≤ i ≤ r − 1` and `1 ≤ s_r < q`, as `r` varies. -/
def 𝒯 (w : ℕ) : Set (CompletionAtInfty F) := ⋃ r : ℕ+, 𝒯_aux F w r

/-- Let `q` be the size of the finite field `F`. `𝒯0_aux` is the set of `ζ_A(s_1,..., s_r)` of
weight `w`, with `1 ≤ s_i < q` for all `i`. -/
def 𝒯0_aux (w : ℕ) (r : ℕ+) : Set (CompletionAtInfty F) :=
  let q := Nat.card F
  let 𝔖'_w := {𝔰 ∈ 𝔖_w w r | ∀ i, 𝔰 i < q}
  {ζ_A F s | s ∈ 𝔖'_w}

/-- Let `q` be the size of the finite field `F`. `𝒯0 w` is the set of `ζ_A(s_1,..., s_r)` of weight
`w`, with `1 ≤ s_i < q` for all `i`, as `r` varies. -/
def 𝒯0 (w : ℕ) : Set (CompletionAtInfty F) := ⋃ r : ℕ+, 𝒯0_aux F w r

/-- The sequence `d(w)` from Conjecture 1.5 and Theorems A and D. -/
noncomputable def d (w : ℕ) : ℕ :=
  let q := Nat.card F
  if w = 0 then 1
  else if w ≤ q - 1 then 2 ^ (w - 1)
  else if w = q then 2 ^ (w - 1) - 1
  else ∑ i ∈ Finset.range q, d (w - (i + 1))







end ZagierHoffmanPositiveChar
