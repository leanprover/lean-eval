# `ising_2d_phase_transition`

Onsager's 2D Ising phase transition

- Problem ID: `ising_2d_phase_transition`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The thermodynamic-limit free energy of the zero-field ferromagnetic square-lattice Ising model exists for every inverse temperature and is non-analytic at a positive critical βc (Onsager 1944). Trusted helpers (isingEnergy, isingPartitionFunction, finiteIsingFreeEnergy, …) are non-holes; the ∀β limit clause pins F to the genuine infinite-volume free energy so βc must be a real non-analyticity point. Mathlib has no statistical-mechanics machinery. Candidate from §158 of the Knill survey.
- Source: L. Onsager, *Crystal statistics I*, Phys. Rev. 65 (1944). Knill, §158.

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
