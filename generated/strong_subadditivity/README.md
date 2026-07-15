# `strong_subadditivity`

Strong Subadditivity of von Neumann Entropy

- Problem ID: `strong_subadditivity`
- Test Problem: no
- Submitter: Alex Meiburg
- Notes: This fact is 'equivalent' to other facts such as the joint convexity of quantum relative entropy. First proved in 1973 by E.H. Lieb and M.B. Ruskai, but at least half-a-dozen alternate proofs have been published, with varied techniques. This formulation states the problem for all PSD matrices (over non-empty, finite index types) instead of restricting to normalized matrices of trace one. This is because `S(t·σ) = t·S(σ) − t·log t` (for any t including negatives and zero, actually, under Mathlib's conventions). Since all entropies are of matrices of the same trace, all can be rescaled to unit trace by the same t, and the constant shifts `−t·log t` cancel out.
- Source: E. H. Lieb and M. B. Ruskai, 'Proof of the strong subadditivity of quantum-mechanical entropy', J. Math. Phys. 14(12), 1938–1941 (1973), doi:10.1063/1.1666274.
- Informal solution: First establish the joint convexity or quantum relative entropy, then the data processing inequality for quantum relative entropy (also known as monotonicity). Apply DPI to the relative entropy between states ρABC and the tensor product state ρAB ⊗ ρC, where the applied channel is partial tracing out the A subsystem. Then expanding out relative entropy in terms of logs and cancelling terms gives the desired inequality.

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
