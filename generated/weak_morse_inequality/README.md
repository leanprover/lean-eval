# `weak_morse_inequality`

Weak Morse inequalities

- Problem ID: `weak_morse_inequality`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §40 of Knill's 'Some Fundamental Theorems in Mathematics' (additional statement; the boxed main theorem is the strong Morse inequality). For a Morse function f on a closed smooth finite-dimensional Hausdorff manifold M, b_k(M) ≤ c_k(f) for every k. The Hausdorff (T2Space) hypothesis is essential, as the split-circle counterexample shows. Follows from the strong Morse inequality but is often proved directly via the Morse-Smale CW structure. Mathlib has the smooth-manifold framework, mfderiv, higher Fréchet derivatives, and singularHomologyFunctor but no Morse functions, Morse index, critical-point counts, Betti numbers as a named definition, or the weak Morse inequality. The Challenge ships seven helper definitions.
- Source: M. Morse, The Calculus of Variations in the Large, AMS Colloq. Publ. 18 (1934). Listed as §40 additional statement in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Direct corollary of the strong Morse inequality: the alternating partial sums of c_k(f) dominate those of b_k(M); take the difference of consecutive partial sums and use that successive partial sums differ by 2·b_k − 2·c_k (with signs), to extract b_k ≤ c_k. Alternatively, prove directly via the Morse-Smale CW structure: the cellular boundary maps ∂_k : ℤ^{c_k} → ℤ^{c_{k−1}} give H_k = ker ∂_k / im ∂_{k+1}, and dim H_k ≤ c_k − rank ∂_k − rank ∂_{k+1} ≤ c_k. The weak inequality is sharper than counting: it asserts the Betti number bound for each k independently, not just the alternating sum.

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
