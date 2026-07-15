# `wiener_atom_detection`

Wiener's atom-detection formula

- Problem ID: `wiener_atom_detection`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §66 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. Wiener's atom-detection formula states that for a probability measure μ on the circle ℝ/2πℤ, the Cesàro averages (1/N) ∑_{k=1}^N |μ̂_k|² of the squared Fourier coefficients converge to ∑_x μ({x})², the total squared mass of the atoms. Thus the asymptotic behavior of the Fourier coefficients detects exactly the pure-point part of the measure. Mathlib provides AddCircle, the Fourier characters fourier, and related Fourier theory for functions, but it does not currently package Fourier coefficients of measures or this Wiener atom-detection theorem.
- Source: N. Wiener, The Fourier Integral and Certain of its Applications (1933). Listed as §66 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Expand |μ̂_k|² = μ̂_k · conj(μ̂_k) = ∫∫ e^{ik(x−y)} dμ(x) dμ(y) by Fubini. Averaging over k = 1, …, N gives (1/N) ∑_{k=1}^N |μ̂_k|² = ∫∫ D_N(x−y) dμ(x) dμ(y), where D_N(t) = (1/N) ∑_{k=1}^N e^{ikt} is a Cesàro/Fejér-type kernel with |D_N| ≤ 1 and D_N(t) → 1 if t = 0 and → 0 if t ≠ 0. By dominated convergence (against the finite product measure μ × μ) the double integral converges to (μ × μ){(x, y) : x = y} = ∑_x μ({x})², the mass the diagonal carries, which is exactly the sum of squared atomic masses. The right-hand side is summable because the atoms of a finite measure are at most countable with masses bounded by μ(𝕋) = 1.

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
