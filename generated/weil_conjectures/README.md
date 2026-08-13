# `weil_conjectures`

Weil conjectures in terms of point counts

- Problem ID: `weil_conjectures`
- Test Problem: no
- Submitter: Junyan Xu
- Source: P. Deligne, 'La conjecture de Weil. I', Publications Mathématiques de l'Institut des Hautes Études Scientifiques, Volume 43, pages 273–307 (1974), https://www.numdam.org/item/PMIHES_1974__43__273_0.pdf. See also references in the Lean file.
- Informal solution: Deligne's proof of the Riemann hypothesis in Weil I was based upon combining Grothendieck's ℓ-adic cohomological theory of L-functions, the monodromy theory of Lefschetz pencils, and Deligne's own stunning transposition to the function field case of Rankin's method of 'squaring'. Deligne's proof of Weil II is generally regarded as being much deeper and more difficult than his proof of Weil I, but in the spring of 1984, Laumon found a significant simplification based upon Fourier transform ideas. Katz's lectures present a further simplification of Laumon's simplification of Deligne's proof of Weil II. A purely p-adic proof using rigid cohomology is available from the paper by Kedlaya.

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
