# Security model: lean-eval

This repository owns the problem set and the integration between the trusted
evaluation harness and the pinned toolchain's `lake comparator`. Intake,
fetching, credentials, archiving, and result publication are documented in
[lean-eval-submissions/SECURITY.md](https://github.com/leanprover/lean-eval-submissions/blob/main/SECURITY.md).

## Reporting a vulnerability

If a submission can receive credit without proving its statement, read another
submission's private source, or execute code outside the sandbox, email the
maintainers through the Lean organization contacts with details and a reproduction.
Do not disclose a vulnerability in a public issue.

## Submission boundary

Submitters control only `Submission.lean` and files under `Submission/`.
The pipeline copies Challenge, Solution, config, toolchain, Lake configuration,
and the test driver from the trusted benchmark revision. It checks paths and
dependency pins before overlaying permitted files. Problem helpers and statements
cannot import the solution-only Lean Pool dependency.

Challenge expresses the trusted statement. Solution imports Submission and exposes
the declarations named in the trusted comparator config. Definition holes are
explicitly named separately from theorem targets. Neither successful elaboration
nor a submission's printed output is evidence of acceptance.

## Verifier and kernel policy

The trusted `WorkspaceTest` driver invokes the toolchain's absolute Lake
executable with `comparator --config <temporary-config>`. It unconditionally
registers the toolchain's bundled NanoDa, regardless of the on-disk
`enable_nanoda` flag or `external_kernels` map. Every acceptance requires
NanoDa and the default Lean checker. Missing tools or failed checkers cannot
produce acceptance. `--paranoid` is not enabled.

Lake builds and exports Challenge before building/exporting Solution. Its trusted
supervisor parses the exports, compares target statements and their constant
graphs (with the configured definition holes), checks the allowed axioms, and runs
the checkers in separate processes. The solution exporter is untrusted: the design
must remain sound even if it fabricates its output. Exporter behavior alone is
not a soundness guarantee.

The permitted axioms are `propext`, `Quot.sound`, and `Classical.choice`.
The trust assumptions include the comparator's graph/axiom checks, the trusted
challenge, the export parser, kernel implementations, and the operating system's
sandbox isolation. Extra axioms, mismatched statements, and uses of sorry must be
rejected. A native computation that introduces an unpermitted axiom is not a
substitute for a checked proof.

## Where submitted code runs

| Operation | Trust and execution boundary |
| --- | --- |
| Root dependency restoration and benchmark build | Trusted pinned sources, on the runner before submission extraction |
| Building the generated test driver | Trusted source; it must not import Submission |
| Driver config enforcement and launching comparator | Trusted supervisor on the runner |
| Comparator workspace resolution/build/export | Lake's bubblewrap sandboxes; solution build/imports execute submitted code |
| Export comparison and axiom checking | Trusted supervisor parsing untrusted export data |
| NanoDa and Lean checker | Separate sandboxed processes reading the solution export |

Do not add an unsandboxed `lake build Solution`, `lake build Submission`, or a
test-driver import of submitted modules. `lake env` itself does not build project
libraries, but it is unnecessary for starting this driver. Challenge preparation
must use trusted source and dependencies only.

The driver filters executable and library search paths to remove the workspace,
its writable cache, relative/empty entries resolving there, symlink aliases, and
nonexistent directories. It uses Lake's supplied `LAKE` and `LEAN_SYSROOT`
paths outside writable roots. Keep this filtering: supervisor tool lookups must
not execute a program planted in a workspace build directory. The bundled
exporter and Lean checker are selected by Lake from its own toolchain.

## Sandbox and caches

Linux bubblewrap 0.12.0 is installed from a checksum-verified release using
`scripts/install_bwrap.sh`. Ubuntu's user-namespace restriction is handled by an
AppArmor profile granting userns permission to that executable. Failure to create
a sandbox is an error; there is no unsandboxed fallback.

Lake binds the host filesystem read-only, masks home and temporary paths, clears
the child environment, provides private writable temporary directories, and
grants writes to the workspace's private `.lake` for builds. Network isolation,
PID namespaces, parent-death cleanup, and new sessions are configured by Lake.
A successful write to sandbox-private HOME or /tmp is allowed; it must not change
the corresponding host file.

Scoring creates a trusted temporary `COMPARATOR_BWRAP` wrapper to bind the root's
canonical shared package directory read-only after Lake's masking mounts. The
wrapper embeds the real bubblewrap and cache paths because Lake launches it with
an empty environment. It preserves Lake's other arguments and settings.
Mounts come from trusted root state, never submission input. Private local
workspaces do not need this visibility adapter.

Existing trusted root builds finish dependency setup before evaluation, including
ProofWidgets metadata that cannot be updated in a read-only cache. Shared source
and cached artifacts remain read-only during submission builds. The submissions
adapter gives Lean Pool its own writable build outputs in each workspace while
sharing its pinned source read-only; one submission must never supply writable
artifacts to another.

The former Landrun setup allowed detached build descendants to survive between
phases. Lake's PID namespaces tear down descendants; the descendant-cleanup probe
checks that the heartbeat stops. Historical replay images keep their recorded
legacy tools and are not covered by this current-path migration.

## Trusted dependencies and pin policy

The Lean release in `lean-toolchain` pins Lake comparator, exporter, Lean checker,
and bundled NanoDa together. Mathematics and generator revisions are in
`lakefile.toml` and `lake-manifest.json`. Bubblewrap's release and SHA256 are
in `scripts/install_bwrap.sh`. Workflow actions use immutable commit SHAs;
`scripts/action_pin_audit.py` checks mutable selectors.

When changing the Lean toolchain, update compatible mathematics pins and generated
workspaces together, restore their exact caches, and run the normal CI and
sandbox/scoring checks. When changing bubblewrap, update the release and checksum
in both benchmark and submission installers. Review the actual sandbox behavior,
not just the reported version. No standalone comparator/exporter/NanoDa build or
Landrun pin is required by this benchmark.

The generator rejects Lean Pool imports in trusted statements and helpers while
making its pinned source available to solutions. Maintain that separation.
Historical replay locks and instrumentation are versioned independently; do not
silently change their verifier or metric semantics.

## Validations done at evaluation time

Before unpacking submitted source, the production job runs the benchmark's
sandbox and environment probes. Benchmark CI also runs these through the same
`lake test` driver used for scoring:

- `scripts/sandbox_engaged_probe.py`: source/host writes denied, host marker
  hidden, private build/temp writes work, and no IPv4 routes appear.
- `scripts/security_probes/env_dump_probe.py`: a synthetic parent secret is
  absent during submission elaboration.
- `scripts/security_probes/tool_path_probe.py`: workspace helper stand-ins do
  not displace the trusted supervisor/kernel commands.
- `scripts/security_probes/artifact_tamper_probe.py`: a detached build
  descendant stops before comparator returns.
- `scripts/security_probes/comparator_probe.py`: valid/invalid proofs,
  definition holes, dependent holes, mandatory NanoDa, and missing sandbox.
- `check-comparator-installation` and `check-eval-workflow`: a real generated
  Mathlib workspace, shared cache visibility, Lean Pool import, and exact counts.

The `run-eval` command can exit successfully while reporting rejected proofs.
Consumers must inspect per-problem JSON. Exit 2 from the driver denotes setup
failure and aborts scoring; exit 1 can include runtime infrastructure failures, so
retain raw diagnostics. Resource exhaustion is not evidence of an invalid theorem.

## Limits

This boundary does not make arbitrary benchmark changes safe: changing the
trusted statement, Solution adapter, config, driver, dependency source, or
executable paths changes what is trusted. Reviews must preserve those assumptions.
A flaw shared by the checkers, comparator comparison/axiom logic, export parser,
or Linux isolation can defeat the system. Keep runner credentials and unrelated
private data out of the evaluation environment even though child environment and
filesystem access are restricted.
