# Lean Eval

**[View the leaderboard →](https://lean-lang.org/eval/)** ·
**[Submit a solution →](https://lean-lang.org/eval/submit/)**

This repository is a comparator-based Lean benchmark for formal mathematics.
Benchmark authors write trusted problem statements once in shared Lean modules, and the
tooling generates one comparator workspace per problem under `generated/`.

A submission is scored entirely by comparator results: a problem counts as solved iff
comparator accepts the submitted solution.

The main user-facing entrypoint is:

```bash
lake exe lean-eval --help
```

## Quick Start For Benchmark Problem Contributors

Use this path if you are adding or editing benchmark problems.

### 1. Install and fetch dependencies

```bash
lake exe cache get
cache_env="$(bash scripts/fetch_dependency_caches.sh --restore .)" && eval "$cache_env"
lake build
```

The second line downloads the oleans of
[Tau Ceti](https://github.com/TauCetiProject/TauCeti), which some problems
import, instead of compiling it, and fails if any would have to be compiled.
This requires lean-eval to pin exactly the Lean toolchain and Mathlib revision
of the pinned Tau Ceti commit, which the script checks.

### 2. Add or edit a trusted theorem

Put the statement in one of the shared modules under `LeanEval/` and mark it with
`@[eval_problem]`.

```lean
@[eval_problem]
theorem my_new_problem : ... := by
  sorry
```

Current source modules live in topic folders such as:

- `LeanEval/NumberTheory/`
- `LeanEval/Topology/`
- `LeanEval/ComplexAnalysis/`
- `LeanEval/EasyProblems.lean`

### 3. Add the manifest entry

Each tagged declaration must be listed by exactly one file under
[`manifests/problems/`](manifests/problems/). One file per problem,
named `<id>.toml`, with top-level keys (no `[[problem]]` wrapper). The
filename stem must match the `id` field. The `holes` array names every
`@[eval_problem]`-tagged declaration in the module that the problem
owns; for the common single-theorem case it has one element.

```toml
# manifests/problems/my_new_problem.toml
id = "my_new_problem"
title = "My new problem"
group = "formalization-evaluation"
status = "draft"
visible = true
statement_revision = 1
tags = []
module = "LeanEval.SomeModule"
holes = ["my_new_problem"]
submitter = "Your Name"
notes = "Optional notes."
source = "Optional citation or URL."
informal_solution = "Optional proof sketch or reference."
```

The required fields are:

- `id` (must equal the filename stem)
- `title`
- `group`
- `status`
- `visible`
- `statement_revision`
- `tags`
- `module`
- `holes`
- `submitter`

The one-file-per-problem layout means two PRs adding distinct problems
never conflict on the manifest.

See [Catalog metadata](docs/catalog-metadata.md) for lifecycle history, the tag
registry, append-only named sets, and the deterministic v1 evidence tool.

The manifest is the only entry point CI has into `LeanEval/`, so a module
no manifest names is never built. `validate-manifest` therefore rejects any
`.lean` file under `LeanEval/` that is neither named by some `module` field
nor imported (directly or transitively) by a module that is, and rejects any
file in `manifests/problems/` that is not a `.toml`.

#### Multi-hole problems

A problem may bundle several `def`s, `instance`s and `theorem`s — list
them all in `holes`. Comparator then asks the participant to fill every
listed declaration in their `Submission.lean`. Two conventions:

- **Name every instance.** The generator addresses holes by their
  declaration name, and Lean's auto-generated names for anonymous
  `instance`s (e.g. `instTopologicalSpaceJacobian`) are not stable. Use
  `instance instAddCommGroup : ... := sorry` rather than `instance : ...
  := sorry`.
- **Use `holes` even for one declaration.** There is no `theorem = "..."`
  shorthand; a singleton hole is just `holes = ["my_thm"]`.

See [`LeanEval/Sandbox/DefHoleExample.lean`](LeanEval/Sandbox/DefHoleExample.lean)
and [`LeanEval/Sandbox/InstanceHoleExample.lean`](LeanEval/Sandbox/InstanceHoleExample.lean)
for the smallest working examples, or
[`LeanEval/Geometry/JacobianChallenge.lean`](LeanEval/Geometry/JacobianChallenge.lean)
for a realistic multi-hole problem.

### 4. Validate the authored source of truth (optional)

```bash
lake exe lean-eval validate-manifest
lake exe lean-eval check-problem-build
```

`validate-manifest` checks that `@[eval_problem]` declarations and manifest entries
match, and that no module under `LeanEval/` escapes the manifest's reach.
`check-problem-build` builds the problem modules so warning-producing Lean changes
do not slip through. Both catch the most common mistakes before a CI roundtrip;
on a clean checkout, validating the full problem inventory can take some time.

### 5. Open a PR

That's it — push your branch and open a PR. CI regenerates the comparator workspaces
under `generated/` and verifies they build, so you do not need to commit anything
under `generated/` yourself. Once the PR merges, a separate workflow regenerates
`generated/` on `main` and pushes the result.

If CI fails with a generation or build error, you'll need to fix the source. The
fastest local equivalent is:

```bash
lake exe lean-eval generate --problem my_new_problem
lake exe lean-eval check-generated-builds --problem my_new_problem
```

## Quick Start For Solvers

Use this path if you want to prove benchmark problems without touching the trusted
benchmark files.

### 1. Pick a problem

Generated workspaces live under `generated/`, one directory per problem. The current
catalog is summarized in [`generated/index.json`](/home/kim/lean-evals/generated/index.json).

Examples:

- `generated/two_plus_two/`
- `generated/list_append_singleton_length/`
- `generated/cyclotomic_integer_house_le_two/`

### 2. Create your local workspace

Copy a clean starter workspace:

```bash
lake exe lean-eval start-problem two_plus_two
```

That creates `workspaces/two_plus_two/` by default. You can also pass a destination:

```bash
lake exe lean-eval start-problem two_plus_two /tmp/two_plus_two
```

### 3. Install workspace dependencies

```bash
cd workspaces/two_plus_two
lake update
```

### 4. Write your proof

Solver-owned files are:

- `Submission.lean`
- `Submission/Helpers.lean`
- any additional Lean files you add under `Submission/`

Trusted files you should not edit in the normal solver workflow are:

- `Challenge.lean`
- `Solution.lean`
- `config.json`
- `lakefile.toml`

`Challenge.lean` contains the benchmark statement. `Solution.lean` is the fixed bridge
that tells comparator to check your theorem from the `Submission` namespace.

Solutions may import `LeanPool.*` modules from [Lean Pool](https://github.com/Vilin97/lean-pool)
in `Submission.lean` or `Submission/` helpers. The pinned dependency is included in
all generated workspaces via `solution-dependencies.json`. Problem statements and
their local helpers may not import it; workspace generation rejects these imports.
Comparator and nanoda checks apply as usual.

### 5. Run comparator locally

```bash
lake test
```

The pinned Lean toolchain includes Lake comparator, `leanexport`, the Lean
checker, and NanoDa. The trusted test driver always requires both Lean and NanoDa.
The only additional verifier dependency is bubblewrap on Linux with user namespaces.

Install bubblewrap 0.12.0 using the same checksum-verified installer as CI
(requires Meson, Ninja, libcap development headers, curl, and a C compiler):

```bash
# Run from the lean-eval repository root, outside a problem workspace.
export COMPARATOR_BWRAP="$(bash scripts/install_bwrap.sh "$PWD/.tools/bubblewrap")"
```

On Ubuntu 24.04 the installer loads an executable-specific AppArmor profile using
`sudo` when user namespaces are restricted. On a system where bubblewrap 0.12.0
is already configured, put `bwrap` on PATH or set `COMPARATOR_BWRAP` to its
absolute path.

Check the installation against the starter problem:

```bash
lake exe lean-eval check-comparator-installation
```

Run `lake test` in a problem workspace to invoke the toolchain's
`lake comparator`. It pins the exporter and checker to the same Lean release,
avoiding separate exporter builds and incompatible olean formats. When changing
toolchains, refresh the dependency caches and remove stale workspace build outputs.

The trusted driver uses Lake's `LAKE` and `LEAN_SYSROOT` settings and removes
workspace/cache directories from executable and library search paths before
starting comparator. `LEAN_PATH` remains available for module imports.
Install bubblewrap and the toolchain outside submission-writable directories.
The old `COMPARATOR_BIN`, `COMPARATOR_LANDRUN`, `COMPARATOR_LEAN4EXPORT`,
and `COMPARATOR_NANODA` overrides are no longer used.

Root scoring makes the trusted shared package cache visible read-only inside
Lake's sandboxes. Direct local workspaces can keep their own dependencies; no
cache wrapper is needed for that layout.

### 6. Check your local score

From the repo root:

```bash
lake exe lean-eval run-eval
lake exe lean-eval run-eval --json
```

The scorer prefers `workspaces/<problem-id>/` when present and falls back to
`generated/<problem-id>/` otherwise.

## Submission Rules

For current instructions to **submit a solution**, start at the stable page:

> **[lean-lang.org/eval/submit/](https://lean-lang.org/eval/submit/)**

That page is the primary authenticated submission path from
`2026-09-02T06:57:10Z`. The application itself is at
`https://lean-eval-submission-server.lean-eval.workers.dev/`; this change of
origin is expected.

[Submission issue
intake](https://github.com/leanprover/lean-eval-submissions/issues/new?template=submit.yml)
remains available as a fallback through at least `2026-09-30T06:57:10Z`, four
weeks after the overlap began. Conditional on stable operation, adequate
adoption, no unresolved severity-high incident, and a reconciled final corpus,
that is the planned retirement time. This notice was issued at
`2026-09-02T23:06:35Z`, more than two weeks in advance. Retirement will be
postponed if any gate is not satisfied.

Scheduled release is recommended for authenticated intake, while submitters
may keep accepted source private instead. Once selected, scheduled release
cannot be changed back to private. Accepted source is published under the
Apache License 2.0 exactly two UTC calendar months after acceptance. A
submitter who initially chooses private source may later change that choice
once to scheduled release.

The service takes a problem ID and resolves its group and current statement
revision from the protected LeanEval catalog; clients do not supply those
canonical fields. Formalization problems must be visible and active.
Software-verification problems may be visible and draft or active. Public
source repositories must use scheduled publication; withholding is available
only for private repositories.

Before acceptance, the submitter explicitly authorizes private fetch, archive,
build, and execution of the exact commit, indefinite encrypted retention even
after rejection or failure, and public display of the result and submitted
metadata. Do not submit secrets. Every new request is archived with a fresh
per-submission key envelope before evaluation, and the service evaluates only
the selected problem. Exact resubmissions by the same owner return the original
submission, and each owner may have at most four active submissions.

This repository (`leanprover/lean-eval`) holds only the problem set and the
comparator/sandbox integration.

Participants may use Mathlib freely.

If a proof needs helper code that is not already in Mathlib, that code must be included
inside the submission workspace itself. Multi-file submissions are allowed through
`Submission.lean` and extra local modules under `Submission/`.

For benchmark-repo submissions (a PR that edits a `generated/` workspace in place),
validate changed paths with:

```bash
lake exe lean-eval validate-submission --file generated/two_plus_two/Solution.lean
```

The current validator accepts:

- modifications to `generated/<problem-id>/Solution.lean` and
  `generated/<problem-id>/Submission.lean`
- additions, modifications, deletions, renames, or copies of `.lean` files under
  `generated/<problem-id>/Submission/`
- additions (only) of markdown files anywhere inside
  `generated/<problem-id>/`, other than the generated `README.md`
- additions (only) of a top-level `generated/<problem-id>/LICENCE` or
  `generated/<problem-id>/LICENSE` file

In practice, solvers should normally work in `Submission.lean` and `Submission/`.

## Repository Layout

- [`LeanEval/`](/home/kim/lean-evals/LeanEval): trusted authored problem statements
- [`manifests/problems/`](manifests/problems/): one TOML file per problem, named `<id>.toml`
- [`manifests/tags.toml`](manifests/tags.toml): stable tag registry
- [`manifests/sets/`](manifests/sets/): versioned and optionally frozen named problem sets
- [`generated/`](/home/kim/lean-evals/generated): generated comparator workspaces
- [`scripts/`](/home/kim/lean-evals/scripts): generation, validation, and scoring helpers
- [`PLAN.md`](/home/kim/lean-evals/PLAN.md): deferred design and roadmap notes

## End-To-End Repo Checks

`bash scripts/fetch_dependency_caches.sh --restore .` restores imported TauCeti
modules without permitting compilation. Downloads have bounded retries and
timeouts and use temporary files to keep interrupted transfers out of the
artifact cache. Cache-only restoration is retried once; if it still fails, the
script prints verbose diagnostics before stopping. Verify the pinned versions
and published cache when outputs are missing. The exported cache settings keep
the download wrapper active for subsequent trusted builds.

For a local health pass over the repository:

```bash
lake exe lean-eval validate-manifest
lake exe lean-eval check-problem-build
lake exe lean-eval generate --check
lake exe lean-eval check-generated-builds
lake exe lean-eval run-eval
```

There is also an end-to-end workflow self-check:

```bash
lake exe lean-eval check-eval-workflow
```
