# `hausdorff_hildebrandt_schoenberg`

The Hausdorff–Hildebrandt–Schoenberg moment theorem

- Problem ID: `hausdorff_hildebrandt_schoenberg`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A multi-indexed real sequence is the moment sequence of a signed bounded-variation Borel measure on the unit cube Iᵈ = [0,1]ᵈ iff it is Hausdorff bounded (∃ C, ∀ n, ∑_{0≤k≤n} |C(n,k)·(Δᵏa)ₙ| ≤ C). Signed BV measures are encoded by their Jordan decomposition (difference of two finite positive measures); moments are integrated over the cube; Δᵏ is the iterated backward difference in closed form. The helper defs (cube, monomial, momentOf, IsMomentConfiguration, multiChoose, diff, HausdorffBounded, IsPositiveMomentConfiguration) are trusted non-holes. Mathlib has SignedMeasure/Jordan decomposition and set integrals but no moment-problem machinery. Candidate from §115 of the Knill survey.
- Source: F. Hausdorff (1921, 1923); T. H. Hildebrandt and I. J. Schoenberg, *On linear functional operations and the moment problem for a finite interval in one or several dimensions*, Ann. of Math. 34 (1933). Knill, *Some fundamental theorems in mathematics*, §115.
- Informal solution: The d-dimensional Hausdorff moment problem for signed measures. Forward: if aₙ = ∫ xⁿ d(μ−ν), expand the iterated backward differences as (Δᵏa)ₙ = ∫ x^{n−k}(1−x)ᵏ d(μ−ν); the Hausdorff sum ∑_k C(n,k)|(Δᵏa)ₙ| is bounded by the total variation |μ|+|ν| of the cube (the weighted kernels C(n,k)·x^{n−k}(1−x)ᵏ sum to 1 on Iᵈ), giving a uniform bound C. Converse: from Hausdorff boundedness, the finite signed 'Bernstein measures' assigning mass C(n,k)(Δᵏa)ₙ to the Bernstein grid are of uniformly bounded variation; pass to a weak-* limit (Banach–Alaoglu on the dual of C(Iᵈ), Riesz representation) to obtain a signed BV measure whose moments are a. Use the Jordan decomposition for the μ−ν packaging.

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
