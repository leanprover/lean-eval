# `brauer_splitting_field`

Brauer's splitting field theorem

- Problem ID: `brauer_splitting_field`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a finite group G of exponent n, the cyclotomic field ℚ(ζₙ) is a splitting field for G: every finite-dimensional complex representation ρ of G descends to ℚ(ζₙ). Concretely, there exists an embedding φ : CyclotomicField n ℚ →+* ℂ, a ℚ(ζₙ)-representation (W, σ) of G, and a ℂ-linear G-equivariant isomorphism ℂ ⊗[ℚ(ζₙ)] W ≃ V (with ℂ viewed as a ℚ(ζₙ)-algebra via φ). The G-equivariance is expressed against the base-changed action `(σ g).baseChange ℂ`. Strictly stronger than the character-value statement `brauer_character_in_cyclotomic`, which follows by taking traces and is in fact elementary.
- Source: R. Brauer, On the representation of a group of order g in the field of g-th roots of unity, Amer. J. Math. 67 (1945), 461–471.
- Informal solution: Pick any embedding φ : ℚ(ζₙ) ↪ ℂ. By Maschke's theorem ρ decomposes as a direct sum of irreducible complex representations, so it suffices to descend each irreducible ρᵢ separately. Brauer's induction theorem expresses the character of each ρᵢ as a ℤ-combination of characters induced from one-dimensional characters of elementary subgroups; these one-dimensional characters take values in ℚ(ζₙ), so each induced representation is realised on a ℚ(ζₙ)-module. The Schur index of each ρᵢ over ℚ(ζₙ) is therefore 1, meaning ρᵢ itself descends to ℚ(ζₙ): there exists a ℚ(ζₙ)[G]-module Wᵢ with ℂ ⊗_{ℚ(ζₙ)} Wᵢ ≃ Vᵢ as ℂ[G]-modules. Assemble the Wᵢ into W and the isomorphisms into f to conclude.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
