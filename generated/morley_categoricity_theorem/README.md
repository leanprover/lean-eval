# `morley_categoricity_theorem`

Morley's categoricity theorem

- Problem ID: `morley_categoricity_theorem`
- Test Problem: no
- Submitter: A. M. Berns
- Notes: A complete theory in a countable language with only infinite models that is categorical in some uncountable cardinal is categorical in every uncountable cardinal.
- Source: M. Ramsey, *Morley's Categoricity Theorem* (UChicago VIGRE REU 2010), Corollary 7.3. https://www.math.uchicago.edu/~may/VIGRE/VIGRE2010/REUPapers/RamseyN.pdf
- Informal solution: Show that categoricity in an uncountable cardinal forces the theory to be ω-stable, and then use Vaughtian pairs to prove that any two models of the same uncountable size are isomorphic and categoricity transfers to all uncountable cardinals.

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
