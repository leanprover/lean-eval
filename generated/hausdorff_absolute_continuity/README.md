# `hausdorff_absolute_continuity`

Hausdorff moment problem: absolute-continuity criterion

- Problem ID: `hausdorff_absolute_continuity`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A positive probability measure μ supported on the unit cube (μ ((cube d)ᶜ) = 0) is uniformly absolutely continuous w.r.t. Lebesgue measure iff its iterated moment differences are dominated by those of Lebesgue measure (∃ C, (Δᵏμ)ₙ ≤ C·(Δᵏν)ₙ for k ≤ n). Trusted helpers (cube, monomial, momentOf, multiChoose, diff, UniformlyAbsolutelyContinuous) are non-holes. Companion of the §115 realizability and positivity criteria (already submitted). Mathlib has SignedMeasure and set integrals but no moment-problem machinery. Candidate from §115 (additional 2).
- Source: F. Hausdorff (1921–1923); see Shohat–Tamarkin, *The Problem of Moments*. Knill, *Some fundamental theorems in mathematics*, §115.
- Informal solution: Hausdorff's absolute-continuity criterion for the cube moment problem. Forward: if μ ≤ C·ν then the Bernstein/difference functionals satisfy (Δᵏμ)ₙ = ∫ x^{n−k}(1−x)ᵏ dμ ≤ C ∫ x^{n−k}(1−x)ᵏ dν = C·(Δᵏν)ₙ since the kernels are nonnegative. Converse: the dominated-difference condition says the Bernstein polynomials approximating dμ/dν are uniformly bounded, so the Radon–Nikodym density is essentially bounded by C; pass to the weak-* limit of the Bernstein densities (Helly) to conclude μ ≤ C·ν. The Bernstein-density machinery for the cube is not in Mathlib.

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
