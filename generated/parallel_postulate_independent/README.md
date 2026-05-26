# `parallel_postulate_independent`

Independence of the parallel postulate

- Problem ID: `parallel_postulate_independent`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Theorem #12 on Freek Wiedijk's 'Formalizing 100 Theorems' list (https://www.cs.ru.nl/~freek/100/). Euclid's parallel postulate is independent of the remaining axioms of plane geometry. Stated via Tarski's axiomatization: the `TarskiAbsolute` class bundles betweenness and congruence with axioms A1-A9 and the continuity axiom A11, the Euclidean axiom A10 is a separate Prop, and independence is the conjunction of two existentials (a model satisfying A10, a model refuting it). Cross-checked against the two existing formalizations on Freek's list: John Harrison's HOL Light (Multivariate/tarski.ml + 100/independence.ml) and Tim Makarios's Isabelle/AFP entry Tarskis_Geometry; axioms A1-A10 match Harrison's TARSKI_AXIOM_n character-for-character and A11 is his second-order continuity axiom.
- Source: Independence of Euclid's parallel postulate; the hyperbolic-plane models are due to E. Beltrami (1868) and F. Klein (1871). Tarski's axiomatization: W. Schwabhäuser, W. Szmielew, A. Tarski, Metamathematische Methoden in der Geometrie, Springer (1983). Formalized in HOL Light by John Harrison and in Isabelle by Tim Makarios (T.J.M. Makarios, A Mechanical Verification of the Independence of Tarski's Euclidean Axiom, MSc thesis, Victoria University of Wellington, 2012; Isabelle/AFP entry Tarskis_Geometry).
- Informal solution: Exhibit two models of `TarskiAbsolute` (axioms A1-A9, A11). For the Euclidean existential, take the real coordinate plane ℝ² with `B` the metric betweenness and `C` segment-length equality; it satisfies all of A1-A11 including the Euclidean axiom A10. For the non-Euclidean existential, take the Klein-Beltrami disk model of the hyperbolic plane: points are the open unit disk, betweenness and congruence are defined from cross-ratios / the projective structure; it satisfies A1-A9 and A11 but refutes A10 (through a point not on a line there is more than one parallel). Verifying the axioms for the Klein model is the substantial part — Makarios's Isabelle development and Harrison's HOL Light file both carry it out in full.

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
