# `fourier_dirichlet_fejer`

Pointwise and Cesàro convergence of Fourier series (Dirichlet, Fejér)

- Problem ID: `fourier_dirichlet_fejer`
- Test Problem: no
- Submitter: Kim Morrison
- Holes (2): `LeanEval.Analysis.dirichlet_pointwise` (theorem), `LeanEval.Analysis.fejer` (theorem)
- Notes: §46 of Oliver Knill's 'Some Fundamental Theorems in Mathematics' records two Fourier convergence theorems for complex-valued 2π-periodic functions. Dirichlet's theorem says that if f is C¹, the symmetric Fourier partial sums S_N(f)(x) = ∑_{n=-N}^N f̂_n e^{inx} converge pointwise to f(x). Fejér's theorem says that if f is merely continuous, the Cesàro means (S_0 + ⋯ + S_N)/(N+1) converge uniformly to f. Mathlib has Fourier coefficients, Fourier characters, L² Fourier theory, and uniform convergence from summable coefficients (the C¹ bound |f̂_n| ≤ C/n is not ℓ¹-summable, so that route does not apply), but not the Dirichlet-kernel pointwise theorem, Fejér kernels/Cesàro means, or Fejér's theorem.
- Source: P. G. L. Dirichlet (1829) and L. Fejér (1900). Listed as §46 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Dirichlet: write S_N(f)(x) = (1/2π) ∫ f(x−t) D_N(t) dt with the Dirichlet kernel D_N(t) = ∑_{n=−N}^N e^{int} = sin((N+½)t)/sin(t/2). Then S_N(f)(x) − f(x) = (1/2π) ∫ (f(x−t) − f(x)) D_N(t) dt; for C¹ f the difference quotient (f(x−t)−f(x))/sin(t/2) is bounded and integrable, so by the Riemann–Lebesgue lemma the integral against sin((N+½)t) tends to 0. Fejér: the Cesàro means satisfy σ_N(f)(x) = (1/2π) ∫ f(x−t) F_N(t) dt with the Fejér kernel F_N(t) = (1/(N+1)) (sin((N+1)t/2)/sin(t/2))², which is a nonnegative approximate identity (F_N ≥ 0, total mass 1, mass concentrating at 0). Convolution of a continuous (hence uniformly continuous) periodic f with an approximate identity converges uniformly, giving σ_N(f) → f uniformly.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
