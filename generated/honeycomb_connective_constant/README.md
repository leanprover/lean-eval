# `honeycomb_connective_constant`

Connective constant of the honeycomb lattice

- Problem ID: `honeycomb_connective_constant`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: The honeycomb lattice is given explicitly as the standard bipartite graph on `Int x Int x Bool`: a vertex on one side is joined to the three corresponding vertices on the other side at offsets `(0,0)`, `(-1,0)`, and `(0,-1)`, with reverse moves from the other side. An `n`-step walk is encoded by its `n` choices among the three incident edges, and it is self-avoiding exactly when its `n+1` visited vertices are distinct. Consequently `walkCount n` is exactly the usual `c_n`; the theorem states the defining connective-constant limit, not merely a critical generating-function identity.
- Source: H. Duminil-Copin and S. Smirnov, 'The connective constant of the honeycomb lattice equals sqrt(2 + sqrt 2)', Ann. of Math. 175 (2012), 1653-1665, https://doi.org/10.4007/annals.2012.175.3.14.
- Informal solution: Let `x_c = 1 / sqrt(2 + sqrt 2)`. Duminil-Copin and Smirnov introduce a parafermionic observable for self-avoiding walks in finite honeycomb domains, weighted by `x_c` to the walk length and by a complex phase determined by winding. At each lattice vertex the observable satisfies a discrete Cauchy-Riemann-type cancellation. Summing this local identity over strip domains gives an exact relation among boundary partition functions. A bridge decomposition then proves that the self-avoiding-walk generating function converges for `x < x_c` and diverges for `x > x_c`. Since the standard submultiplicative argument gives existence of the exponential growth rate of `walkCount n`, its value is `x_c^-1 = sqrt(2 + sqrt 2)`, which is the limit asserted in Lean.

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
