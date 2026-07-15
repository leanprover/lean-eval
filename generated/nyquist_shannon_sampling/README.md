# `nyquist_shannon_sampling`

Nyquist–Shannon sampling theorem

- Problem ID: `nyquist_shannon_sampling`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Whittaker–Shannon interpolation: a Schwartz function f whose Fourier transform is supported in the Nyquist band [-1/2, 1/2] (mathlib's e^{-2π i x ξ} convention) is reconstructed from its integer samples by the cardinal series f(t) = ∑_{n : ℤ} f(n) · sinc(π(n - t)), with the series summable. Trusted helpers (sinc, FourierSupportedInNyquist) are non-holes; the Summable conjunct records convergence rather than relying on Lean's total tsum. Mathlib has Schwartz space, the Fourier transform, inversion, Plancherel and Poisson summation, but not the sampling theorem. Candidate from §179 of the Knill survey.
- Source: C. E. Shannon, *Communication in the presence of noise*, Proc. IRE 37 (1949); H. Nyquist (1928); E. T. Whittaker (1915). Knill, *Some fundamental theorems in mathematics*, §179.
- Informal solution: Let g = 𝓕 f, supported in [-1/2, 1/2]. Extend g periodically with period 1 and expand it in a Fourier series on [-1/2, 1/2]; the Fourier coefficients are exactly the samples f(n) (up to sign), by Fourier inversion ∫ g(ξ) e^{2π i n ξ} dξ = f(n) since g is band-limited. Substituting this Fourier series for g into the inversion formula f(t) = ∫ g(ξ) e^{2π i t ξ} dξ and integrating term by term (justified by Schwartz decay, giving the Summable claim) produces f(t) = ∑_{n} f(n) ∫_{[-1/2,1/2]} e^{2π i (t - n) ξ} dξ = ∑_{n} f(n) · sinc(π(n - t)), since the band-limited indicator integrates to a cardinal sine. Equivalently this is Poisson summation applied to the band-limited f. Not in Mathlib.

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
