import Mathlib.Algebra.Field.ZMod
import Mathlib.InformationTheory.Hamming
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.Probability.ProbabilityMassFunction.Basic
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Good Locally Testable Codes

We formalise the statement of the main result from I. Dinur, S. Evra, R. Livne,
A. Lubotzky, and S. Mozes, `Good Locally Testable Codes`, Annals of Math, 203 (2) 2026.
-/

set_option autoImplicit false

namespace GoodLTC

open NNReal

variable (n : ℕ)

local notation "𝔽₂ⁿ" => Fin n → ZMod 2

/-- A binary code of length `n` is a subspace of `(𝔽₂)ⁿ`. -/
abbrev BinaryCode : Type := Submodule (ZMod 2) 𝔽₂ⁿ

variable {n} (C : BinaryCode n)

/-- The dimension of a binary code is its dimension as an `𝔽₂` subspace. -/
noncomputable def dim : ℕ := Module.finrank (ZMod 2) C

/-- The rate of a binary code is its dimension divided by its length. -/
noncomputable def rate : ℝ := dim C / n

/-- The distance of a binary code `C` is the minimum of the Hamming distances between distinct
codewords. -/
noncomputable def distance : ℕ :=
  sInf {d | ∃ c ∈ C, c ≠ 0 ∧ hammingNorm c = d}

/-- The normalised distance of a binary code `C` is its distance divided by its length. -/
noncomputable def normalisedDistance : ℝ := distance C / n

/-- The distance from a word `f` to a binary code `C` is the Hamming distance from `f` to the
closest codeword in `C`. -/
noncomputable def distanceFrom (f : 𝔽₂ⁿ) : ℕ :=
  sInf {d | ∃ c ∈ C, hammingNorm (f - c) = d}

/-- The normalised distance from a word `f` to a binary code `C` is the Hamming distance from `f`
to the closest codeword in `C` divided by its length. -/
noncomputable def normalisedDistanceFrom (f : 𝔽₂ⁿ) : ℝ≥0 := ⟨distanceFrom C f / n, by positivity⟩

/-- A family of codes `{Cᵢ}_{i ∈ ℕ}` of lengths `nᵢ → ∞` is called good if there exists `ε > 0`
such that the rate and normalised distance of each `Cᵢ` are bounded from below by `ε`. -/
def IsGood {n : ℕ → ℕ} (𝒞 : (i : ℕ) → BinaryCode (n i)) : Prop :=
  Filter.Tendsto n Filter.atTop Filter.atTop ∧
    ∃ ε > 0, ∀ i, ε ≤ rate (𝒞 i) ∧ ε ≤ normalisedDistance (𝒞 i)

variable (n) in
/-- The type of all `q`-element (or less) subsets `S ⊆ Fin n`. -/
abbrev cardLE (q : ℕ) : Type :=
  {S : Set (Fin n) // S.ncard ≤ q}

/-- A binary code `C ⊆ (𝔽₂)ⁿ` is `κ`-locally testable with `q` queries if there is a distribution
over a collection of `q`-element (or less) subsets `S ⊆ Fin n` such that each subset `S` is
associated with a set `V_S ⊆ 𝔽₂^S` of allowed local views, and such that the following hold:
* If `f ∈ C` then for every `S`, `f|_S ∈ V_S`.
* For every `f ∈ (𝔽₂)ⁿ`, `ℙ_S[f|_S ∉ V_S] ≥ κ * dist(f, C)`.

This is Definition 2.3 in `Locally Testable Codes with constant rate, distance, and locality` by
the same authors. This probability distribution formulation is also mentioned immediately after
Definition 1.1 in the original paper `Good Locally Testable Codes`. -/
structure LTC (q : ℕ) (κ : ℝ≥0) (C : BinaryCode n) where
  /-- The probability distribution on the collection of `q`-element (or less) subsets of `Fin n`. -/
  prob : PMF (cardLE n q)
  /-- The set `V_S ⊆ 𝔽₂^S` of allowed local views associated to a given subset `S ⊆ Fin n`. -/
  views (S : cardLE n q) : Set (S.val → ZMod 2)
  cond1 (f : 𝔽₂ⁿ) (hf : f ∈ C) (S : cardLE n q) : Set.domRestrict S f ∈ views S
  cond2 (f : 𝔽₂ⁿ) :
    prob.toMeasure {S | Set.domRestrict S f ∉ views S} ≥ κ * normalisedDistanceFrom C f



end GoodLTC
