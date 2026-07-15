# `fraser_kakeya_fourier_decay`

Fraser: Fourier decay for finite-field Kakeya sets is q^{-1} and sharp

- Problem ID: `fraser_kakeya_fourier_decay`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For every d ≥ 2, every finite-field Kakeya set K ⊆ F_q^d (a subset containing a line in every direction) supports a probability measure μ whose finite-field Fourier transform `μ̂(ξ) = ∑_x χ(-ξ·x) μ(x)` satisfies `‖μ̂(ξ)‖ ≤ q^{-1}` at every nonzero frequency, and this exponent is sharp in every dimension: for every κ ∈ (0, 1) some threshold Q makes the bound `κ · q^{-1}` saturated by every probability measure on a suitable Kakeya set, for every finite field of cardinality ≥ Q. Headline Theorem 2.4 of Fraser, *Fourier analytic properties of Kakeya sets in finite fields*, arXiv:2505.09464.
- Source: J.M. Fraser, 'Fourier analytic properties of Kakeya sets in finite fields', Bull. London Math. Soc. 58(5) (2026); DOI 10.1112/blms.70367; arXiv:2505.09464.
- Informal solution: For the upper bound, Fraser builds μ as an incidence-weighted measure: choose one affine line through each direction (a `(d, 1)`-set realising the Kakeya property), and weight the resulting union by the appropriate normalised line-counting measure. Expanding `μ̂(ξ)` and applying orthogonality of additive characters along each line — `∑_{a ∈ F_q} χ(a · ⟨ξ, x⟩) = 0` whenever `⟨ξ, x⟩ ≠ 0` — collapses the sum at every nonzero frequency to the residual contribution from directions parallel to `ξ`, yielding the `q^{-1}` bound. For sharpness, Fraser starts with a small planar Kakeya set `K₀ ⊆ F_q²` (an O(q²)-size configuration with the Kakeya property), lifts it to `K = K₀ ⊕ F_q^{d−2} ⊆ F_q^d`, and projects an arbitrary probability measure on `K` down to `F_q²`. A support-size Plancherel argument on the projected measure produces a nonzero frequency at which the Fourier coefficient is at least `(1 − o(1)) · q^{-1}`. Mathlib has `AddChar`, the primitive-character lift `AddChar.FiniteField.primitiveChar_to_Complex`, finite vector-space arithmetic via `Fin d → F`, and `Fintype.card` / finite-sum integration over a finite type, but no finite-field Kakeya theorem, no Salem-set API, no Plancherel for finite abelian groups in the form Fraser uses, and no formalisation of arXiv:2505.09464.

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
