# `ckmrv_fourier_interpolation`

Fourier interpolation in dimensions 8 and 24

- Problem ID: `ckmrv_fourier_interpolation`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: This is the full bijectivity content of Theorem 1.9, simultaneously in dimensions 8 and 24. `RadialSchwartz n` is Mathlib's complex Schwartz space restricted to radial functions. `RapidSampleData k0` consists of four complex sequences indexed by `k >= k0`, each rapidly decreasing. Coordinates `0`, `1`, `2`, and `3` respectively sample `f`, its Fourier transform, the radial derivative of `f`, and the radial derivative of its Fourier transform at `sqrt(2*k)`. The transform is explicitly Mathlib's Schwartz-space `FourierTransform.fourierCLM`; Mathlib and the paper both use the kernel `exp(-2*pi*i*inner(x,y))`. The coordinate-axis restriction computes the radial derivative because every sampled radius is positive. The equivalence is pinned to this sampling map, bundles the underlying bijection rather than its additional linear and topological structure, and introduces no trusted interpolation basis.
- Source: H. Cohn, A. Kumar, S. D. Miller, D. Radchenko, and M. Viazovska, 'Universal optimality of the E8 and Leech lattices and interpolation formulas', Ann. of Math. 196 (2022), 983-1082, Theorem 1.9, https://doi.org/10.4007/annals.2022.196.3.3.
- Informal solution: The authors construct four families of radial Schwartz interpolation basis functions in each of dimensions 8 and 24 using integral transforms of quasimodular forms. Their values, radial derivatives, Fourier-transform values, and Fourier-transform radial derivatives at the radii `sqrt(2*k)` form the four Kronecker-delta patterns. Polynomial bounds for all Schwartz seminorms of the basis functions imply that arbitrary rapidly decreasing coefficient sequences yield convergent sums in radial Schwartz space. The interpolation identity proves that sampling followed by this reconstruction is the identity, while the delta identities prove the converse. Thus the sampling map is an isomorphism onto four rapidly decreasing sequences, starting at `k = 1` in dimension 8 and `k = 2` in dimension 24.

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
