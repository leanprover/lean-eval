# `annulus_theorem_high_dim`

The Annulus Theorem in dimension ≥ 5 (Kirby)

- Problem ID: `annulus_theorem_high_dim`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The closed region between two disjoint, nested, locally flat embedded (n-1)-spheres in ℝⁿ (n ≥ 5) is homeomorphic to Sⁿ⁻¹ × [0,1]. Local flatness is essential (the Alexander horned sphere is a counterexample without it). This was the hard core of Kirby's stable-homeomorphism work, via the torus trick. The 'inside' of a sphere is defined via bounded complementary components rather than the Jordan–Brouwer theorem, which Mathlib lacks; for locally flat nested spheres the inside of g is automatically inside f, so it is not assumed. Paired with annulus_theorem_dim_four, the much harder n = 4 case (Quinn).
- Source: R. C. Kirby, *Stable homeomorphisms and the annulus conjecture*, Ann. of Math. 89 (1969).
- Informal solution: No formalization is feasible today: there is no Jordan–Brouwer separation, no theory of locally flat embeddings, and none of Kirby's torus-trick / stable-homeomorphism machinery in Mathlib.

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
