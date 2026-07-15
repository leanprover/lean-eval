# `erdos_unit_distance_conjecture_false`

Erdős's unit-distance conjecture is false

- Problem ID: `erdos_unit_distance_conjecture_false`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Erdős (1946) conjectured ν(n) ≤ n^{1 + C / log log n} for some absolute C and all sufficiently large n. The conjecture stood for 80 years and was widely believed to be true prior to OpenAI's 2026 construction, in part because Alon-Bucić-Sauermann (2025) had proved a matching bound (d/2) n log₂ n for typical norms on ℝ^d (later sharpened by Greilhuber-Schildkraut-Tidor, 2025). The refutation also disproves the stronger Erdős-Falconer (1997) k-equidistant variant: along the refuting sequence the unit-distance graph has average degree n^{Ω(1)}, while Erdős-Falconer predicted at most n^{o(1)}. ν is defined as the number of unordered pairs in P ⊆ ℝ² at Euclidean distance exactly 1; the planar metric is the one from EuclideanSpace ℝ (Fin 2), not the product sup-metric.
- Source: OpenAI, *Planar Point Sets with Many Unit Distances*, 2026. https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-proof.pdf . Original conjecture: P. Erdős, *On sets of distances of n points*, Amer. Math. Monthly 53 (1946), 248-250. k-equidistant variant: P. Erdős, K. Falconer, *Some problems in combinatorial geometry*, 1997.
- Informal solution: Split into an arithmetic and a geometric part. (1) Arithmetic: build an admissible datum (L, K = L(i), t, q₁, …, q_t) where L is a totally real number field of growing degree f, K is its CM extension by i, and each q_b ≡ 1 mod 4 splits completely in L. Use the Hajir-Maire class-field-theoretic tower-cutting trick — start from the cyclic cubic subfield F of ℚ(ζ_{r_1 · … · r_ℓ}) for distinct primes r_i ≡ 1 mod 3, observe M/F is everywhere unramified to get d(G) ≥ ℓ - 1 for the maximal unramified pro-3 tower's Galois group G, kill prescribed Frobenius elements by quotienting G by relations chosen via Chebotarev, and apply Shafarevich's relation-rank estimate r(G) ≤ d(G) + C₀ together with Golod-Shafarevich (r > d²/4 for finite pro-p groups) to keep the quotient tower infinite. Adjoining i preserves bounded root discriminants, so Minkowski gives class numbers at most exponential in the degree: h(K_j) ≤ H^{f_j}. The split primes give m = t · f_j conjugate pairs of prime ideals; pigeonholing 2^m ε-vectors by class gives ≥ 2^m / h(K_j) ≥ exp(γ f_j) elements u ∈ K^× with N_{K/L}(u) = u · c(u) = 1 (hence |σ(u)| = 1 for every complex embedding). (2) Geometric: embed K via the Minkowski map into V = ℂ^f, take a random translate of the lattice Q^{-2} 𝒪_K cut by the polydisc B_R, and project to the first complex coordinate. Lemma 2.4 averages over cosets to find a coset with E_a ≥ exp(γ f / 2) · N_a directed unit-distance pairs; Lemma 2.6 packs the polydisc to bound |P| ≤ exp(B f) uniformly. Combining n_j ≤ exp(B f_j) with ν(P_j) ≥ n_j · exp(γ f_j / 2) / 2 gives ν(P_j) ≥ n_j^{1 + δ} with δ = γ / (4B), refuting any proposed bound n^{1 + C / log log n} once log log n_j < δ.

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
