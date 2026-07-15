# `mazur_torsion`

Mazur's torsion theorem

- Problem ID: `mazur_torsion`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The torsion subgroup of E(ℚ) for an elliptic curve over ℚ is one of fifteen groups: ℤ/n (n ∈ {1,…,10,12}) or ℤ/2 × ℤ/2m (m ∈ {1,2,3,4}). Trusted helper IsInMazurClass (non-hole). Mathlib has Weierstrass curves and point groups but not Mazur's theorem (which uses the modular curves X₁(N)). Candidate from §139 of the Knill survey.
- Source: B. Mazur, *Modular curves and the Eisenstein ideal*, Publ. IHÉS 47 (1977). Knill, *Some fundamental theorems in mathematics*, §139.
- Informal solution: Mazur's deep theorem. A point of order N on E/ℚ gives a rational point on the modular curve X₁(N); Mazur showed X₁(N) has no non-cuspidal rational points for N = 11 or N ≥ 13 (via the Eisenstein-ideal analysis of J₀(N) and the formal-immersion method), and handled the ℤ/2×ℤ/2m families similarly with X₁(2,2m). Hence only the fifteen listed torsion structures occur. Far beyond current Mathlib.

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
