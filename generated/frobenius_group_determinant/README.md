# `frobenius_group_determinant`

Frobenius determinant theorem

- Problem ID: `frobenius_group_determinant`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Dedekind's group determinant: the determinant of the group matrix A_{gh} = x_{gh} (over ℂ[x_g : g ∈ G]) factors into irreducible polynomials, each to the power of its own total degree, with factors pairwise non-associated and their number equal to the number of conjugacy classes of G. The helpers groupMatrix and groupDeterminant encode the statement; over ℂ this is the algebraically-closed characteristic-zero form where Frobenius's theorem and the character correspondence d_j = deg p_j live. Mathlib has MvPolynomial, Matrix.det, unique factorization, character theory, and ConjClasses, but not the group determinant or its factorization. Category-(b) candidate.
- Source: Knill, *Some fundamental theorems in mathematics*, §171.
- Informal solution: This is the genesis of representation theory. By Maschke and Wedderburn the group algebra ℂ[G] decomposes as a product of matrix algebras ⨁ⱼ M_{dⱼ}(ℂ), one per irreducible representation ρⱼ of dimension dⱼ. The group matrix is the matrix of left regular multiplication by the generic element ∑_g x_g g, so its determinant is the product over the regular-representation blocks, det = ∏ⱼ det(ρⱼ(∑_g x_g g))^{dⱼ}. Each factor pⱼ = det(ρⱼ(∑_g x_g g)) is an irreducible polynomial of total degree dⱼ, the factors are pairwise non-associated, and the number of irreducibles equals the number of conjugacy classes of G.

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
