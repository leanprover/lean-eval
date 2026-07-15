# `space_groups_230`

230 space groups (Fedorov 1891 / Schoenflies 1891)

- Problem ID: `space_groups_230`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: In dimension 3 there are exactly 230 space groups (orientation-preserving affine equivalence), 219 if enantiomorphic pairs are identified (general affine equivalence), and 65 of the 230 are Sohncke groups — those whose isometries are all orientation-preserving. The three counts come from two equivalences on crystallographic groups: AffinelyEquivalent (Aff(ℝ³)-conjugacy) vs AffOPEquivalent (orientation-preserving Aff(ℝ³)-conjugacy), and a subfamily restriction to crystallographic groups whose elements are all orientation-preserving. For a reference, see §94 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: E. Fedorov, 'Симметрія правильныхъ системъ фигуръ' (Symmetry of regular systems of figures), Trans. Min. Soc. St. Petersburg 28 (1891) 1–146; A. Schoenflies, *Krystallsysteme und Krystallstructur*, Teubner 1891, independently. Listed as §94 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The classification extends the wallpaper-group structure to dimension 3: (1) Bieberbach gives every 3-dimensional crystallographic group G a finite-index translation subgroup Λ of rank 3 (the **Bravais lattice**, 14 inequivalent types in ℝ³: triclinic P; monoclinic P, C; orthorhombic P, C, I, F; tetragonal P, I; trigonal/rhombohedral R; hexagonal P; cubic P, I, F). (2) The **point group** G / Λ embeds into O(3) and is one of the 32 crystallographic point groups — finite subgroups of O(3) preserving some 3D Bravais lattice. (3) For each (Bravais lattice, point group) pair, classify group extensions of the point group by Λ up to affine conjugacy: of the 32 point groups, the 230 space groups arise. (4) The 219 count identifies the 11 chiral pairs of enantiomorphic space groups (e.g. P3₁ ↔ P3₂); the 65 count restricts to point groups inside SO(3) (the **Sohncke groups**). Mathlib has the basic affine-isometry infrastructure but no Bravais-lattice classification, no crystallographic point groups, no extension cohomology in this dimension, no Sohncke subfamily.

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
