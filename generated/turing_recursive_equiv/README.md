# `turing_recursive_equiv`

General recursive equals Turing computable

- Problem ID: `turing_recursive_equiv`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The Turing–Kleene equivalence (total form): a total function f : ℕ → ℕ is recursive (Computable) iff it is computed by some Turing machine (mathlib's FinTM2 model, TM2Computable) under the standard binary encoding encodeNat. Both sides are mathlib predicates but no theorem links them; the forward direction is essentially tr_eval plus plumbing, while the backward direction (TM-computable ⇒ recursive) is absent from mathlib. The total reading is used since general recursive is classically the total recursive functions and TM2Computable is total-only. Candidate from §23 of the Knill survey.
- Source: A. M. Turing, *On Computable Numbers* (1936); S. C. Kleene, *General recursive functions of natural numbers* (1936). Knill, *Some fundamental theorems in mathematics*, §23.
- Informal solution: Two inclusions. Recursive ⇒ TM-computable: by Nat.Partrec.Code.exists_code every Computable f is the evaluation of a partial recursive code; mathlib's Turing.PartrecToTM2.tr_eval constructively builds a TM2 machine evaluating any ToPartrec.Code, so composing the translations and verifying the encodeNat input/output encoding yields a TM2Computable witness. TM-computable ⇒ recursive: given a FinTM2 machine, its step relation is primitive recursive in the (finite) state and tape data, so the computation history and its halting time are recursive; running the machine until it halts and decoding the output exhibits f as obtained by composition and unbounded minimization over a primitive recursive predicate, hence Computable. This converse is the half missing from mathlib.

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
