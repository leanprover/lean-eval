# LeanEval lifecycle overhaul execution runbook

Status: **active companion to the completion plan**  
Scope authority: [`overhaul-completion-plan.md`](overhaul-completion-plan.md)

## 1. Purpose

This runbook is the operational checklist for finishing the lifecycle overhaul.
It is intentionally updateable: check items off, replace stale current-state
values, and keep the next action obvious. Do not use it to add product scope.

Before acting, read the completion plan in full. If an old tracker, branch,
comment, or original-plan clause conflicts with it, the completion plan wins.

## 2. Starting posture

At adoption, the intended safe posture is:

- production intake disabled;
- staging general replay disabled except for bounded isolated work;
- production replay disabled;
- automatic publication disabled;
- public result-owner, maintainer, and model-identity gates disabled;
- the lifecycle-aware leaderboard live with problem statements visible; and
- no FC, disproof, or experimental-kernel work authorized.

Do not trust this paragraph as a live probe. Phase 1 re-verifies it read-only
and updates the current infrastructure inventory in place if necessary.

## 3. Execution rules

### 3.1 Work autonomously inside the allowlist

Repository implementation, tests, PRs, review fixes, merges, ordinary CI, and
automatic disabled-state deployments are autonomous in the repository family
listed in completion-plan section 11.

Standing maintainer authorization covers every remaining in-scope operation,
including infrastructure, credentials, protected environments, production
enablement, canonical data, issue-intake retirement, announcements, and
external non-PR mutations. Complete the applicable impact packet, preconditions,
tests, rollback, and post-change verification before acting; standing approval
does not make an unready operation ready. Do not turn a missing local login
into a permission question: prepare an operator handoff when authenticated
execution is required.

Parallelize independent repository work and use build time productively. Do not
sit polling one workflow while other in-scope tasks can advance.

### 3.2 Standing authorization and remaining stop conditions

Do not request repeated approval for an operation already covered by the
standing authorization in completion-plan section 11. The production-launch,
historical migration/replay, and issue-retirement packets remain mandatory
readiness gates; complete and review them without waiting for another
permission response.

Stop for exact maintainer approval only before:

- opening, updating, or merging a pull request in a repository outside the
  allowlist;
- posting a Zulip message or comment;
- posting a comment or review on another person's pull request; or
- expanding the completion-plan scope.

At any high-impact readiness gate, record the exact mutation, target, user
impact, immutable inputs, rollback, and read-only precondition. A fail-closed
capability disable or credential revocation may proceed immediately, but its
impact and verification requirements are not waived. Other rollback follows
the same rules as its forward change.

### 3.3 Keep changes reviewable

- One coherent purpose per PR.
- Do not mix feature enablement with cleanup or refactoring.
- Preserve unrelated work in dirty worktrees.
- Do not weaken security checks merely to make a smoke pass.
- Do not add a new framework when a bounded script or existing mechanism is
  sufficient.
- Merge only after required checks are green and review threads are resolved.

### 3.4 Record current state, not a narrative

- Check off the item and update the current identifier or state.
- Do not append run-by-run histories or incident prose.
- Keep GitHub run links in the PR or handoff message.
- Retain only canonical machine-readable inputs consumed by later phases.

## 4. Phase 0 — rebaseline and delete overgrowth

Goal: make the repositories describe only the approved remaining program.

- [x] Inventory every open PR, active workflow, remote branch, and relevant
      local worktree in the allowlisted repositories.
- [x] Confirm the already identified escaped external branches are absent and
      the stale LeanEval PRs are closed.
- [x] Review any uncommitted local cleanup attempt as an untrusted candidate
      diff. Keep useful pieces only after comparing them with current upstream.
- [x] Delete the persistent model-identity qualification harness, private
      qualification Workers, workflows, generated types, fixtures, tests, and
      rebuild/recovery instructions.
- [x] Delete experimental-kernel shadow smoke, Arena/Mathgraph assets,
      checker-series and corpus-promotion machinery, wire/attestation protocols,
      candidate adapters, and tests that exist only for them.
- [x] Remove exact-byte solution-export capture hooks that existed only to feed
      the removed experimental-kernel lane.
- [x] Retain the existing official Lean build and nanoda replay path, its
      generic checker identity/revision fields, and its focused tests.
- [x] Preserve source-bound agent sessions, authorization boundaries,
      idempotency, CAS conflict handling, and other generally useful security
      hardening.
- [x] Remove superseded run narratives, diagnostic artifacts, and tests whose
      only purpose is preserving those narratives.
- [x] Retain canonical replay inventories, final plans, exact toolchain/source
      maps, unavailable-candidate data, current rollback contracts, and current
      infrastructure identifiers.
- [x] Retain an older canonical input set only while a live execution profile
      references it; delete the whole linked set after replacement.
- [x] Rewrite the submissions tracker, rollout runbook, and infrastructure
      inventory to current state and remaining gates, without a chronology.
- [x] Run repository tests, typechecks, linters with zero warnings, workflow
      validation, action-pin audit, and all relevant dry-runs.
- [x] Merge the cleanup in coherent repository-local PRs.

Exit condition: no tracked instruction tells a future agent to implement FC,
disproofs, experimental kernels, or the persistent qualification harness.

## 5. Phase 1 — read-only disabled-state reconciliation

Goal: establish one exact safe baseline before launch work resumes.

### 5.1 Repositories and automation

- [x] Record current protected `main` commits for every allowlisted repository.
- [x] List open PRs and cross-referenced work; close or classify stale overhaul
      PRs.
- [x] Confirm no unplanned workflow dispatch is queued or running.
- [x] Confirm required checks, protected branches, and immutable dispatch-tag
      protections match current operating needs.

The table records the repository-family operational baseline verified at this
reconciliation checkpoint. Documentation-only descendants, including updates
to this runbook, do not by themselves change deployed-service versions or
effective flags; Section 5.2 and the current operational ledgers record those.

| Repository | Commit | Protection state |
| --- | --- | --- |
| `lean-eval` | `9625d5f290ca70c293ed73e8ea91fd40e61480e2` | Required `verify` |
| `lean-eval-submissions` | `81e94fe2f4fc819300fd7d4e036f00124166784f` | Required `verify` |
| `lean-eval-leaderboard` | `bf534c149e204a286a5cd9bbaff449449567834b` | Required `build` |
| `lean-eval-state` | `c6a4bb67b55609ae7215bdd3cac2378b2db42a0a` | Required `validate`; append-only |
| `lean-eval-state-staging` | `e4b9316dd8d3db17751feae1b66d005c28ef02c8` | Required `validate`; append-only |
| `lean-eval-releases` | `071a52e2095d47ae4684ee983a7e08520f3c808a` | Required `validate` |
| `lean-eval-generator` | `010b01634cccda2db538cf9b09e6f26ddc453743` | Required `check` |
| `lean-eval-audit` | `eadf24b2b4a99c56ef59a43811eab9d54ae013ac` | Reviewed changes; non-rewritable linear history |

### 5.2 Deployed services

The production and staging submission units are deployed from
`34ea521927a34f81458fbaad4528cefc6ef7039b`; protected submissions `main` is
the workflow-only descendant
`f73caa718dcd3d4fdd8d7facee6116b4ac1a5ac2`. Production health reports ready,
with intake, ordinary and historical replay, staging acceptance, every
lifecycle API, model
consolidation, the promotion canary, and publication all disabled. Staging
intake, ordinary and historical replay, every lifecycle API, model
consolidation, and publication are disabled, while bounded staging acceptance
and the promotion canary are enabled. The deployed contract pins are production State
`c6a4bb67b55609ae7215bdd3cac2378b2db42a0a` and staging State
`8ae11456f0a439f91ec5822ec36adb93b76b0d96`; current protected staging State
head `7a14c2e29a7a47b040eb4eac6a4d95fedd129d6c` is an append-only descendant of
its contract pin.

- [x] Read staging and production intake health.
- [x] Read staging and production broker/replay health and current versions.
- [x] Verify production intake is configured and effectively disabled.
- [x] Verify general and production replay are disabled.
- [x] Verify publication is disabled.
- [x] Verify public lifecycle feature gates are disabled before their launch
      smoke and approval.
- [x] Verify the final deployed commits, container image digests, and protected
      State pins form one coherent unit.

### 5.3 State, credentials, and presentation

- [x] Verify protected State heads and validation status.
- [x] Inventory credential names, owners, scopes, expiry, rotation, and
      revocation without exposing values.
- [x] Confirm production State contains no unexpected accepted server
      submission or due release work.
- [x] Confirm the live leaderboard root, group tabs, stable problem URLs,
      problem statements, and representative solution metadata.

Exit condition: current documentation states one coherent disabled baseline.
Any mismatch becomes a separate repository fix or a reviewed infrastructure
correction under the standing authorization.

## 6. Phase 2 — repository launch preparation

These lanes can proceed in parallel after Phase 1.

### 6.1 No-DNS submission entry

- [x] Add `https://lean-lang.org/eval/submit/` to the leaderboard site.
- [x] Explain that authentication continues on the LeanEval Worker origin.
- [x] Link to the production `workers.dev` application.
- [x] Verify navigation, accessibility, mobile layout, and return path to the
      leaderboard.
- [x] Keep OAuth callback and session handling on the Worker origin.

### 6.2 Release and archive repository preparation

- [x] Reconfirm the exact staging release OIDC trust mismatch.
- [x] Prepare the smallest reviewed infrastructure patch or operator command;
      do not apply it yet.
- [x] Reconfirm the production archive Wrap-only role requirement and prove the
      desired policy excludes unwrap.
- [x] Verify the release controller reconstructs deterministically with
      publication disabled using credential-free fixtures.
- [x] Verify submitter-facing license, release delay, and opt-out language.

### 6.3 Lifecycle API launch surface

- [x] Confirm feature flags exist independently for the route families being
      launched.
- [x] Keep model consolidation disabled or remove it.
- [x] Run all existing repository tests.
- [x] Prepare the bounded success and authorization/validation fixtures required
      by the completion plan for each launch route family:
  - [x] metadata backfill;
  - [x] repair/retraction request;
  - [x] maintainer decision;
  - [x] model alias/rename; and
  - [x] release opt-out success.
- [x] Verify every launch gate can be returned to disabled and health reports
      the effective state.
- [x] Do not build a persistent staging harness.

### 6.4 Exact-version lifecycle rehearsal

The operational-baseline table in section 5.1 records the current executable
repository family. The submission units are deployed from
`5612d62f2d97c9b5521d5f761be7c4bb5c78d5d3` in the state described in section
5.2. Bind every remaining case to the exact final candidate selected for the
staging acceptance gate.

- [x] Select the exact candidate commits across the repository family.
- [x] Use a synthetic private source repository owned for staging.
- [x] Move the final source fixture to a temporary, non-default fixture branch
      in private allowlisted `lean-eval-state-staging`.
- [ ] Preflight both contents-read source Apps against that branch, use a
      runtime-unique tag, and remove the branch/tag/App access after the
      terminal run.
- [ ] Retain the exact secret-Gist proof because it binds the headless request
      to the individual GitHub login. Apply only the exact runtime-generated
      Gist file CAS write/restore under standing authorization.
- [x] Prepare one browser and one source-bound headless submission.
- [x] Include one deliberate invalid or unauthorized case.
- [x] Confirm archive-before-evaluation and schema-version-3 binding.
- [x] Confirm the accepted path produces an immutable Result, append-only State,
      release scheduling, and a redacted leaderboard projection.
- [ ] Confirm the bounded rejection and authorization-denial cases against the
      final candidate.
- [x] Prepare the rollback/disable steps for the same exact version.

Exit condition: repository changes and staging fixtures are ready; bounded
external mutations occur only at their exact runtime step.

## 7. Autonomous credential-boundary preparation

The staging boundary has been exercised with production and publication
authority absent:

- [x] Apply only the reviewed staging trust change.
- [x] Run one credentialed staging release unwrap and reconstruction.
- [x] Verify consume-before-unwrap and identical reuse refusal.
- [x] Remove AWS authority before reconstruction execution.
- [x] Verify source allowlist, no plaintext artifact, no State/Git mutation,
      and cleanup.
- [x] Confirm the one-use grant was consumed and workflow AWS credentials were
      cleared before reconstruction.

Complete the production **Wrap-only** connection autonomously while intake
remains disabled:

Current qualification: production Wrap-only preflight run `33245433960`
completed successfully.

- [x] Connect repository environment
      `archive-production` variable `AWS_WRAP_ROLE_ARN` to
      `arn:aws:iam::161072922960:role/lean-eval-archive-wrap-production`.
- [x] Dispatch the immutable-tag preflight that encrypts a synthetic key for the
      exact production archive subject.
- [x] Require that same preflight to prove decrypt is denied.
- [x] Do not accept a production submission during this preflight.

Complete the isolated production release-role trust repair autonomously while
publication remains disabled:

- [ ] Change only the trust on
      `lean-eval-release-unwrap-invoker-production` from the obsolete name-only
      subject to
      `repo:leanprover@7233018/lean-eval-releases@1340741242:environment:release-production`.
- [ ] Run the trust-only production preflight with `PUBLICATION_ENABLED` absent.
- [ ] Confirm the preflight has no archive, State, Git, or artifact write path.
- [ ] Keep `PUBLICATION_ENABLED` absent.

Exit condition: new production submissions can receive safe envelopes and the
release path has passed a credentialed staging boundary.

## 8. Phase 3 — final staging acceptance

Temporary staging feature flags and their all-false recovery are autonomous.
Before the bounded run, tell the maintainer that the browser and headless
canaries permanently add synthetic staging archives, Results, and append-only
State events. The maintainer deliberately performs the browser submission as
an operator handoff; the exact unavoidable secret-Gist CAS mutation for the
headless identity proof is covered by standing authorization.

- [x] Deploy the exact candidate version to staging through the normal
      protected path.
- [ ] Run one successful browser submission.
- [ ] Run one successful source-bound headless submission.
- [ ] Run the bounded lifecycle route-family cases from Phase 2.
- [ ] Run one deliberate rejection or authorization failure.
- [x] Reconstruct one accepted archive through the credentialed staging release
      path with publication disabled.
- [x] Verify no source or credential appears in public logs or artifacts.
- [ ] Exercise the reviewed disable/rollback path after the final-candidate
      cases.
- [ ] Confirm staging State validates after the final rehearsal.

Do not rerun broad historical matrices merely to obtain newer timestamps.

## 9. Production launch readiness gate

Prepare the compact launch readiness packet specified by completion-plan
section 7.5.

Standing authorization for these operations is recorded in completion-plan
section 11. The packet must still show these launch components separately:

- [ ] enable automatic release controller;
- [ ] enable the approved public lifecycle APIs;
- [ ] enable production intake and create one named production canary, with
      permanent archive, Result, State, release-schedule, and opt-out records;
      and
- [ ] publish the overlap announcement.

Do not launch until every packet item and precondition is satisfied. Standing
authorization removes another permission interruption; it does not allow a
green staging run to substitute for launch readiness.

## 10. Phase 4 — launch

After the launch packet is complete:

### 10.1 Release controller

- [ ] Confirm no release is currently due.
- [ ] Enable the controller in a single-purpose change.
- [ ] Verify configuration, protected State access, and publication posture.

### 10.2 Lifecycle APIs

- [ ] Enable only backfill, repair/retraction, maintainer decisions,
      alias/rename, and release opt-out.
- [ ] Keep model consolidation disabled.
- [ ] Verify effective public health and one non-mutating authorization denial.

### 10.3 Intake

- [ ] Enable production intake through the finite-lease controller.
- [ ] Verify the exact active version, lease transition, durable state, and
      protected State coherence.
- [ ] Submit one tightly controlled production canary only if it was part of
      the reviewed launch packet.
- [ ] Verify archive completion, evaluation dispatch, State, Result,
      leaderboard presentation, and release scheduling.

### 10.4 Announcement

- [ ] Publish the server entry path and four-week overlap dates.
- [ ] State that issue intake remains available during the overlap.
- [ ] Give at least two weeks' notice before eventual issue-intake closure.

Exit condition: new production submissions traverse the promised lifecycle and
the system can be paused through the documented path.

## 11. Phase 5 — four-week overlap

- [ ] Monitor severity-high incidents and readiness failures.
- [ ] Monitor State validation, archive completion, evaluation dispatch,
      release scheduling, and automatic releases.
- [ ] Monitor submitter adoption of the new path.
- [ ] Keep issue intake available.
- [ ] Pause server intake if confidentiality, State consistency, or release
      safety fails.
- [ ] Extend the overlap rather than closing on schedule if a serious incident
      or inadequate adoption remains.
- [ ] Maintain the final append-only Results delta for issue submissions.

Do not turn monitoring output into a permanent incident-history appendix.

## 12. Phase 6 — historical completion

Historical lanes can run in parallel with the overlap.

Old issue intake remains live during the overlap and can append Results-only
commits to submissions `main`. Process the retained baseline now using immutable
dispatch tags; do not demand a quiet protected branch. Maintain an append-only
delta, and treat only the announced issue-intake cutoff as the final corpus.

### 12.1 Final inventory

- [ ] Freeze the final issue-intake cutoff.
- [ ] Generate and validate the append-only inventory delta.
- [ ] Reconcile public, private, and unavailable counts against every accepted
      Result.
- [ ] Ensure no accepted Result disappears or changes identity.

### 12.2 Public source

The current canonical public-source classification aggregate is
`evidence/historical-public-replay-github-evidence-current.json` at
`lean-eval-submissions@617bf711bff8cd34f02a49b7ab1e3de66a0fd86e`, with SHA-256
digest
`7c10dfc3e3d66f6f9ae0107ef2ed94b8f731d7f8410741ed3f5978dc55e149e5`.
It covers 318 requests and 636 Results: 123 requests are resolved and 195 are
classified source-unavailable, with no ambiguous, missing, indeterminate, or
unreviewed classification. The source-unavailable cases still require reviewed
terminal State dispositions.

- [ ] Retain the final canonical public replay plan and exact toolchain/source
      mappings.
- [ ] Review each `source_unavailable` classification for its terminal State
      disposition.
- [x] Build/qualify only images used by replayable results.
- [x] Qualify the final missing image from the retained baseline plan in an
      isolated replay-disabled Worker.
- [x] Commit and validate its generated qualification profile. All 35 retained
      public profiles are frozen at
      `lean-eval-submissions@0bf88bf0e29c6f2abe8fe07aed1ab803ce98f2ec`.

### 12.3 Private archives

The canonical retained-baseline crosswalk accounts for 639 bound Results and
29 archive-not-found dispositions. Exact qualification of the 63 private
images required by that crosswalk is in progress from submissions commit
`0cdcf3f9f66db6d1555c90e976c886c936b8784c`.

- [x] Reconcile exact archive/result bindings and explicit orphans.
- [ ] Prepare a dedicated migration Wrap role and exact OIDC trust.
- [ ] Build and qualify only the exact private replay images used by the
      retained baseline inventory.
- [ ] Complete the pre-mutation portion of one immutable retained-baseline
      historical migration/replay packet. Bind exact public/private profile and
      task-content hashes and counts, rewrap inventory, workflow commit and
      digest, migration role and trust, controller leases and scopes, rollback,
      and exclusions. It must exclude legacy-key destruction, the final intake
      delta, new external actions, and every item absent from those hashes.
- [ ] Bind the rewrap to that exact reviewed pre-mutation packet before
      installing the legacy identity or writing canonical archive envelopes.
      Standing authorization satisfies permission but not this packet gate.
- [ ] Have the custodian install `LEGACY_ARCHIVE_IDENTITY` directly for the
      bounded packet-bound run without exposing its value in chat, files, logs,
      or artifacts.
- [ ] Rewrap recoverable archives without changing ciphertext archive bytes or
      stable IDs.
- [ ] Complete the post-migration readback in the same packet. Bind the
      randomized sidecar/report hashes, exact audit commit and tree, zero
      ciphertext changes, credential cleanup, exact current State head, State
      event IDs and digests, materialized queue hashes and counts, and redacted
      projection before writing production State or enabling replay.
- [ ] Verify and remove temporary authority, credentials, scratch output, and
      plaintext.
- [ ] Keep every legacy identity copy until the final issue-intake delta is
      closed; destroy it only after the documented cutoff, reconciliation, and
      recovery checks are complete.

### 12.4 Replay

- [ ] Enable production replay and append canonical dispositions only within
      the exact retained-baseline packet completed in section 12.3. After the
      announced cutoff, process the append-only final delta through a separate
      exact packet; extending the baseline packet by implication is forbidden.
- [ ] Serialize or otherwise bound replay according to the existing controller.
- [ ] Restore exact original source, benchmark, toolchain, comparator,
      lean4export, and nanoda pins.
- [ ] Execute the official Lean kernel path and nanoda only.
- [ ] Record terminal outcomes with bounded retries.
- [ ] Publish redacted verdicts and measurements.
- [ ] Confirm every final-cutoff Result has a replay or reviewed unavailable
      disposition.

No experimental checker or promotion work may be added to close this phase.

## 13. Phase 7 — remaining product completion

### 13.1 Open problems

- [x] Add or verify the neutral open-problems tab.
- [x] Confirm the empty state is clear and visually intentional.
- [x] Confirm it has no FC branding, importer, synchronization, or disproof
      dependency.

### 13.2 Software verification and editorial state

- [x] Verify both reviewed software-verification drafts render correctly.
- [x] Verify provisional/draft policy text.
- [x] Complete the maintainer-selected human statement/citation review.
- [x] Confirm no agent-authored hints were introduced.
- [x] Leave verified-calculation runner infrastructure unimplemented.

### 13.3 Retire issue intake

- [ ] Confirm at least four weeks of announced overlap.
- [ ] Confirm at least two weeks of closure notice.
- [ ] Confirm no unresolved severity-high incident.
- [ ] Confirm adequate adoption and stable end-to-end operation.
- [ ] Confirm the final historical cutoff/delta is recorded.
- [ ] Complete the issue-retirement readiness packet because this removes the
      path used by existing issue-intake users. Standing authorization covers
      closure only after every preceding gate is satisfied.
- [ ] Close issue intake in a single-purpose repository change.
- [ ] Verify the server path remains available and documented.

## 14. Final audit and definition of done

- [ ] Check every completion criterion in completion-plan section 13.
- [ ] Search every allowlisted repository for stale FC, disproof,
      experimental-kernel, model-consolidation-launch, and persistent-harness
      instructions.
- [ ] Confirm remaining mentions are historical context or explicit exclusions,
      not TODOs.
- [ ] Confirm current infrastructure and rollback documents contain current
      facts only.
- [ ] Confirm no unexplained open overhaul PR, active workflow, or local-only
      required change remains.
- [ ] Run final repository validation with no errors or linter warnings.
- [ ] Mark this runbook complete and summarize current operation and ordinary
      maintenance ownership.

The overhaul is not complete merely because a token budget, agent session, or
calendar period ends. It is complete only when the completion-plan criteria are
actually satisfied.

## 15. Compact status table

Update this table in place; do not append a history beneath it.

| Phase | State | Current blocker |
| --- | --- | --- |
| 0. Rebaseline cleanup | Complete | — |
| 1. Disabled baseline | Complete | — |
| 2. Repository launch preparation | In progress | Preflight the temporary allowlisted source fixture and complete the exact-version bounded lifecycle rehearsal |
| Credential boundary | Staging and production Wrap-only complete; release trust pending | Apply the reviewed production trust repair in authenticated CloudShell, then complete the write-free preflight |
| 3. Final staging acceptance | In progress | Complete the browser, headless, lifecycle, and rejection cases, then return every staging gate to disabled |
| Production launch readiness | Standing approval recorded; packet incomplete | Finish the exact final staging packet and current launch readbacks |
| 4. Launch | Not started | Complete the production launch packet |
| 5. Four-week overlap | Not started | Production launch |
| 6. Historical completion | In progress | Finish exact private image qualification and the packet-bound rewrap/replay; the final delta waits for cutoff |
| 7. Remaining product completion | In progress | Issue closure waits for stable operation, adequate adoption, the final delta, four weeks of overlap, two weeks of notice, and its readiness packet; catalog lifecycle cutover, open-problems, and editorial work are complete |
| Final audit | Preparatory cleanup complete; final audit pending | Classify remaining local work, then repeat the audit after all phases |
