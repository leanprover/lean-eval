# `dehn_sommerville`

Dehn–Sommerville equations for simplicial spheres

- Problem ID: `dehn_sommerville`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The h-vector of a finite simplicial (d-1)-sphere is symmetric: h_j = h_{d-j}. Trusted helpers (FiniteSimplicialSphere, faceCount, extendedFaceCount, hVector) are non-holes. Mathlib has simplicial complexes but no f/h-vector or Dehn–Sommerville theory. The companion upper-bound theorem for simplicial spheres is already in lean-eval. Candidate from §142 of the Knill survey.
- Source: M. Dehn (1905); D. M. Y. Sommerville (1927); see Stanley, *Combinatorics and Commutative Algebra*. Knill, *Some fundamental theorems in mathematics*, §142.
- Informal solution: The Dehn–Sommerville relations follow from Poincaré duality / the Euler relations on the face lattice of a simplicial sphere. Encode the f-vector in the h-polynomial h(t) = ∑ h_j t^j defined by ∑ f_{i-1}(t-1)^{d-i} = ∑ h_i t^{d-i}; the Euler–Poincaré relation for a (d-1)-sphere (each face's link is a sphere, χ matches) translates into the functional equation h(t) = t^d h(1/t), i.e. h_j = h_{d-j}. Requires the face-ring/Euler-relation machinery absent from Mathlib.

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
