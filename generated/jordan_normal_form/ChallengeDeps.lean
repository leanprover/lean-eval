import Mathlib

namespace LeanEval.LinearAlgebra.JordanNormalForm

/-!
# Jordan normal form

`jordan_normal_form`: over an algebraically closed field, every endomorphism of
`Kⁿ` has a Jordan-chain basis (equivalently, every `n × n` matrix is similar to
a block-diagonal Jordan matrix). Trusted helpers (`StdSpace`,
`JordanChainBasis`) are non-holes. Mathlib has the Jordan–Chevalley–Dunford
decomposition but not the Jordan-chain-basis / Jordan normal form.
Category-(b) candidate from §165 of the Knill survey.
-/

/-- The vector space underlying `n × n` matrices' action: `Kⁿ`. -/
abbrev StdSpace (K : Type*) [Field K] (n : ℕ) := Fin n → K

/-- A Jordan-chain basis for an endomorphism `f`: blocks indexed by `ι`, block
`i` of size `size i` and eigenvalue `eigenvalue i`, with `f` acting as
`v_j ↦ λ v_j + v_{j-1}` (and `v_0` an eigenvector). -/
structure JordanChainBasis {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
    (f : Module.End K V) where
  ι : Type
  [finite : Fintype ι]
  [decidableEq : DecidableEq ι]
  size : ι → ℕ
  positive_size : ∀ i, 0 < size i
  eigenvalue : ι → K
  basis : Module.Basis (Σ i : ι, Fin (size i)) K V
  chain :
    ∀ (i : ι) (j : Fin (size i)),
      f (basis ⟨i, j⟩) =
        eigenvalue i • basis ⟨i, j⟩ +
          if j.val = 0 then 0
          else basis ⟨i, ⟨j.val - 1, lt_of_le_of_lt (Nat.sub_le j.val 1) j.isLt⟩⟩

attribute [instance] JordanChainBasis.finite JordanChainBasis.decidableEq



end LeanEval.LinearAlgebra.JordanNormalForm
