# `landsberg_schaar`

The Landsberg–Schaar relation

- Problem ID: `landsberg_schaar`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: For positive odd integers p, q, S(2q,p) = e^{iπ/4}·S(−p,2q), where S(q,p) = (1/√p) ∑_{x<p} e^{iπ x² q/p} is the normalized quadratic Gauss sum (trusted helper gaussS, a non-hole). Mathlib has the character-theoretic gaussSum (giving |g|²=p) and Jacobi-theta machinery, but neither the quadratic Gauss-sum value nor the Landsberg–Schaar relation. Candidate from §120 of the Knill survey.
- Source: G. Landsberg (1893); M. Schaar (1848). Knill, *Some fundamental theorems in mathematics*, §120.
- Informal solution: Landsberg–Schaar via theta-function reciprocity. Apply the Jacobi theta transformation θ(−1/τ) = √(−iτ) θ(τ) (Poisson summation for the Gaussian) along a path where the modular parameter degenerates to the rationals p/q: take τ → it with the finite quadratic sums appearing as the boundary values of θ at rational points. The modular transformation relates the sum at modulus p (argument 2q) to the sum at modulus 2q (argument −p), and the automorphy factor √(−iτ) contributes the e^{iπ/4} phase. Mathlib has jacobiTheta₂ and its functional equation; assembling the rational-degeneration limit into the finite-sum identity is the missing step.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
