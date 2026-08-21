# `ten_martini_problem`

Avila-Jitomirskaya Ten Martini Problem

- Problem ID: `ten_martini_problem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: The theorem constructs the almost Mathieu operator as an actual Mathlib continuous linear endomorphism of `lp (fun _ : Int => Complex) 2`; `IsAlmostMathieuOperator` fixes it by the standard coordinate formula, rather than hiding it in trusted spectral scaffolding. For irrational frequency `alpha`, nonzero coupling `lambda`, and arbitrary phase `theta`, its complex spectrum is asserted to be nonempty, compact, perfect, and totally disconnected, i.e. a Cantor set. Including operator existence in the conclusion prevents vacuity through an uninhabited formula predicate.
- Source: A. Avila and S. Jitomirskaya, 'The Ten Martini Problem', Ann. of Math. 170 (2009), 303-342, https://doi.org/10.4007/annals.2009.170.303.
- Informal solution: Aubry duality relates the almost Mathieu operators at couplings `lambda` and `1/lambda`, so the proof can combine localization information in one regime with reducibility information in the dual regime. Avila and Jitomirskaya establish nonperturbative localization estimates and analyze the associated quasiperiodic `SL(2,R)` cocycles. For every irrational frequency and nonzero coupling, these estimates rule out intervals in the spectrum and also rule out isolated spectral points. Standard self-adjoint spectral theory supplies nonemptiness and compactness. Thus the spectrum is compact and perfect with no nontrivial connected subsets, which is precisely the Cantor-set conclusion stated in Lean.

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
