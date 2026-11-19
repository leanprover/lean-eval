# `hopf_s6_complex_structure`

The Hopf problem: a complex structure on the 6-sphere

- Problem ID: `hopf_s6_complex_structure`
- Group: `formalization-evaluation`
- Status: `active`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Jack McCarthy
- Holes (2): `instChartedSpaceS6` (def), `instIsManifoldS6` (theorem)
- Notes: The Hopf problem asks whether S⁶ admits a complex structure. An affirmative construction has been claimed (Alpöge 2026); its correctness is not assumed by this benchmark. Two holes: ChartedSpace data into ℂ³ (the plain function type Fin 3 → ℂ; the model norm is immaterial) on the topological 6-sphere, and the IsManifold 𝓘(ℂ, Fin 3 → ℂ) ω proof that the atlas is holomorphic. No compatibility with the standard smooth atlas is demanded; by Smale's h-cobordism theorem and Θ₆ = 0 (Kervaire–Milnor) this is equivalent to a complex structure on the standard smooth S⁶. Known constraints: S² and S⁶ are the only spheres with almost complex structures (Borel–Serre); no complex structure on S⁶ is orthogonal for the round metric (LeBrun 1987).
- Source: H. Hopf, 'Zur Topologie der komplexen Mannigfaltigkeiten', Studies and Essays Presented to R. Courant, Interscience, 1948. Survey: I. Agricola, G. Bazzoni, O. Goertsches, P. Konstantis, S. Rollenske, 'On the history of the Hopf problem', Differ. Geom. Appl. 57 (2018). https://arxiv.org/abs/1708.01068

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
