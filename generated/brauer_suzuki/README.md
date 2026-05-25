# `brauer_suzuki`

Brauer–Suzuki theorem (quaternion Sylow 2-subgroup)

- Problem ID: `brauer_suzuki`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: If a finite group G has generalized quaternion Sylow 2-subgroups, then the unique involution of G maps to a central element of G/O(G), where O(G) is the largest normal odd-order subgroup. R. Brauer and M. Suzuki, 'On finite groups of even order whose 2-Sylow group is a quaternion group', Proc. Nat. Acad. Sci. U.S.A. 45 (1959), 1757-1759. Historical precursor of Glauberman's Z*-theorem (1966) and the local-analysis programme in CFSG. Introduces Defs/OddCore.lean defining O(G) as the supremum of all normal odd-order subgroups (Mathlib has no `oddCore` operation).
- Source: R. Brauer and M. Suzuki, On finite groups of even order whose 2-Sylow group is a quaternion group, Proc. Nat. Acad. Sci. U.S.A. 45 (1959), 1757-1759. https://doi.org/10.1073/pnas.45.12.1757
- Informal solution: The argument is character-theoretic and proceeds via a careful analysis of the principal 2-block of G. In a generalized quaternion 2-Sylow P, the unique involution z = a^{2^{n-2}} is central in P (where a is the generator of the cyclic maximal subgroup of P). Brauer's principal-block reformulation: z lies in the kernel of every ordinary irreducible character not in the principal 2-block, plus an analysis of how the principal block's characters restrict to ⟨z⟩, forces z·O(G) into the center of G/O(G). Modern simplification: Glauberman's Z*-theorem, of which Brauer-Suzuki is the prototypical case, says any isolated involution is in Z*(G); the unique involution of a generalized-quaternion Sylow 2-subgroup is automatically isolated.

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
