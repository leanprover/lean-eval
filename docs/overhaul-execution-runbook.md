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
- staging general replay disabled except for explicitly approved isolated work;
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

Parallelize independent repository work and use build time productively. Do not
sit polling one workflow while other in-scope tasks can advance.

### 3.2 Stop at these gates

Obtain explicit maintainer approval before:

- changing AWS or Cloudflare resources or permissions;
- changing DNS, OAuth Apps, GitHub Apps, credentials, deploy keys, rulesets, or
  protected environments;
- enabling production intake, replay, publication, or public lifecycle APIs;
- acting in any repository outside the allowlist; or
- expanding the completion-plan scope.

At an approval gate, present the exact mutation, target, reason, rollback, and
read-only precondition. Do not bundle several approvals into an open-ended
request.

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

- [ ] Inventory every open PR, active workflow, remote branch, and relevant
      local worktree in the allowlisted repositories.
- [ ] Confirm the already identified escaped external branches are absent and
      the stale LeanEval PRs are closed.
- [ ] Review any uncommitted local cleanup attempt as an untrusted candidate
      diff. Keep useful pieces only after comparing them with current upstream.
- [ ] Delete the persistent model-identity qualification harness, private
      qualification Workers, workflows, generated types, fixtures, tests, and
      rebuild/recovery instructions.
- [ ] Delete experimental-kernel shadow smoke, Arena/Mathgraph assets,
      checker-series and corpus-promotion machinery, wire/attestation protocols,
      candidate adapters, and tests that exist only for them.
- [ ] Remove exact-byte solution-export capture hooks that existed only to feed
      the removed experimental-kernel lane.
- [ ] Retain the existing official Lean build and nanoda replay path, its
      generic checker identity/revision fields, and its focused tests.
- [ ] Preserve source-bound agent sessions, authorization boundaries,
      idempotency, CAS conflict handling, and other generally useful security
      hardening.
- [ ] Remove superseded run narratives, diagnostic artifacts, and tests whose
      only purpose is preserving those narratives.
- [ ] Retain canonical replay inventories, final plans, exact toolchain/source
      maps, unavailable-candidate data, current rollback contracts, and current
      infrastructure identifiers.
- [ ] Retain an older canonical input set only while a live execution profile
      references it; delete the whole linked set after replacement.
- [ ] Rewrite the submissions tracker, rollout runbook, and infrastructure
      inventory to current state and remaining gates, without a chronology.
- [ ] Run repository tests, typechecks, linters with zero warnings, workflow
      validation, action-pin audit, and all relevant dry-runs.
- [ ] Merge the cleanup in coherent repository-local PRs.

Exit condition: no tracked instruction tells a future agent to implement FC,
disproofs, experimental kernels, or the persistent qualification harness.

## 5. Phase 1 — read-only disabled-state reconciliation

Goal: establish one exact safe baseline before launch work resumes.

### 5.1 Repositories and automation

- [ ] Record current protected `main` commits for every allowlisted repository.
- [ ] List open PRs and cross-referenced work; close or classify stale overhaul
      PRs.
- [ ] Confirm no unplanned workflow dispatch is queued or running.
- [ ] Confirm required checks, protected branches, and immutable dispatch-tag
      protections match current operating needs.

### 5.2 Deployed services

- [ ] Read staging and production intake health.
- [ ] Read staging and production broker/replay health and current versions.
- [ ] Verify production intake is configured and effectively disabled.
- [ ] Verify general and production replay are disabled.
- [ ] Verify publication is disabled.
- [ ] Verify public lifecycle feature gates are disabled before their launch
      smoke and approval.
- [ ] Verify deployed commits, container image digests, and protected State pins
      form one coherent current unit.

### 5.3 State, credentials, and presentation

- [ ] Verify protected State heads and validation status.
- [ ] Inventory credential names, owners, scopes, expiry, rotation, and
      revocation without exposing values.
- [ ] Confirm production State contains no unexpected accepted server
      submission or due release work.
- [ ] Smoke the live leaderboard root, group tabs, stable problem URLs,
      problem statements, and representative solution metadata.

Exit condition: current documentation states one coherent disabled baseline.
Any mismatch becomes a separate repository fix or an approval-gated
infrastructure correction.

## 6. Phase 2 — repository launch preparation

These lanes can proceed in parallel after Phase 1.

### 6.1 No-DNS submission entry

- [ ] Add `https://lean-lang.org/eval/submit/` to the leaderboard site.
- [ ] Explain that authentication continues on the LeanEval Worker origin.
- [ ] Link to the production `workers.dev` application.
- [ ] Verify navigation, accessibility, mobile layout, and return path to the
      leaderboard.
- [ ] Keep OAuth callback and session handling on the Worker origin.

### 6.2 Release and archive repository preparation

- [ ] Reconfirm the exact staging release OIDC trust mismatch.
- [ ] Prepare the smallest reviewed infrastructure patch or operator command;
      do not apply it yet.
- [ ] Reconfirm the production archive Wrap-only role requirement and prove the
      desired policy excludes unwrap.
- [ ] Verify the release controller reconstructs deterministically with
      publication disabled using credential-free fixtures.
- [ ] Verify submitter-facing license, release delay, and opt-out language.

### 6.3 Lifecycle API launch surface

- [ ] Confirm feature flags exist independently for the route families being
      launched.
- [ ] Keep model consolidation disabled or remove it.
- [ ] Run all existing repository tests.
- [ ] Prepare one success and one authorization/validation denial fixture for
      each launch route family:
  - [ ] metadata backfill;
  - [ ] repair/retraction request;
  - [ ] maintainer decision;
  - [ ] model alias/rename; and
  - [ ] release opt-out.
- [ ] Verify every launch gate can be returned to disabled and health reports
      the effective state.
- [ ] Do not build a persistent staging harness.

### 6.4 Exact-version lifecycle rehearsal

- [ ] Select the exact candidate commits across the repository family.
- [ ] Use synthetic private source repositories owned for staging.
- [ ] Prepare one browser and one source-bound headless submission.
- [ ] Include one deliberate invalid or unauthorized case.
- [ ] Confirm archive-before-evaluation and schema-version-3 binding.
- [ ] Confirm acceptance/rejection, immutable Result, append-only State, release
      scheduling, and redacted leaderboard projection.
- [ ] Prepare the rollback/disable steps for the same exact version.

Exit condition: repository changes and staging fixtures are ready; all external
mutations remain unapplied until the next gate.

## 7. Approval gate A — staging credential boundary

Present for approval:

1. exact staging AWS trust mutation;
2. exact target role and OIDC subject;
3. proof that publication and production authority remain absent;
4. the single staging archive to be used;
5. expected State/Git non-mutation; and
6. rollback or removal steps.

After approval:

- [ ] Apply only the approved staging trust change.
- [ ] Run one credentialed staging release unwrap and reconstruction.
- [ ] Verify consume-before-unwrap and identical reuse refusal.
- [ ] Remove AWS authority before reconstruction execution.
- [ ] Verify source allowlist, no plaintext artifact, no State/Git mutation,
      and cleanup.
- [ ] Revoke or remove temporary authority that is no longer required.

Then present the production **Wrap-only** role connection separately:

- [ ] Apply only after explicit approval.
- [ ] Prove the role can wrap for the exact production archive subject.
- [ ] Prove it cannot unwrap.
- [ ] Do not accept a production submission during this preflight.

Exit condition: new production submissions can receive safe envelopes and the
release path has passed a credentialed staging boundary.

## 8. Phase 3 — final staging acceptance

- [ ] Deploy the exact candidate version to staging through the normal
      protected path.
- [ ] Run one successful browser submission.
- [ ] Run one successful source-bound headless submission.
- [ ] Run the bounded lifecycle route-family cases from Phase 2.
- [ ] Run one deliberate rejection or authorization failure.
- [ ] Reconstruct one accepted archive through the credentialed staging release
      path with publication disabled.
- [ ] Verify no source or credential appears in public logs or artifacts.
- [ ] Exercise the reviewed disable/rollback path.
- [ ] Confirm staging State validates after the rehearsal.

Do not rerun broad historical matrices merely to obtain newer timestamps.

## 9. Approval gate B — production launch

Prepare one compact go/no-go packet specified by completion-plan section 7.5.

The requested decisions must be explicit and separate:

- [ ] enable automatic release controller;
- [ ] enable the approved public lifecycle APIs;
- [ ] enable production intake; and
- [ ] publish the overlap announcement.

No approval is implied by a green staging run.

## 10. Phase 4 — launch

After explicit approval:

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
      the approved go/no-go packet.
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

### 12.1 Final inventory

- [ ] Freeze the final issue-intake cutoff.
- [ ] Generate and validate the append-only inventory delta.
- [ ] Reconcile public, private, and unavailable counts against every accepted
      Result.
- [ ] Ensure no accepted Result disappears or changes identity.

### 12.2 Public source

- [ ] Retain the final canonical public replay plan and exact toolchain/source
      mappings.
- [ ] Review each `source_unavailable` classification for its terminal State
      disposition.
- [ ] Build/qualify only images used by replayable results.

### 12.3 Private archives

- [ ] Reconcile exact archive/result bindings and explicit orphans.
- [ ] Prepare a dedicated migration Wrap role and exact OIDC trust.
- [ ] Obtain the legacy identity from its custodian only for the approved run.
- [ ] Stop for explicit infrastructure/credential approval.
- [ ] Rewrap recoverable archives without changing ciphertext archive bytes or
      stable IDs.
- [ ] Verify and remove temporary authority and plaintext.

### 12.4 Replay

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

- [ ] Add or verify the neutral open-problems tab.
- [ ] Confirm the empty state is clear and visually intentional.
- [ ] Confirm it has no FC branding, importer, synchronization, or disproof
      dependency.

### 13.2 Software verification and editorial state

- [ ] Verify both reviewed software-verification drafts render correctly.
- [ ] Verify provisional/draft policy text.
- [ ] Complete the maintainer-selected human statement/citation review.
- [ ] Confirm no agent-authored hints were introduced.
- [ ] Leave verified-calculation runner infrastructure unimplemented.

### 13.3 Retire issue intake

- [ ] Confirm at least four weeks of announced overlap.
- [ ] Confirm at least two weeks of closure notice.
- [ ] Confirm no unresolved severity-high incident.
- [ ] Confirm adequate adoption and stable end-to-end operation.
- [ ] Confirm the final historical cutoff/delta is recorded.
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
| 0. Rebaseline cleanup | Not started | Review and merge scoped deletions |
| 1. Disabled baseline | Not started | Phase 0 |
| 2. Repository launch preparation | Not started | Phase 1 |
| Approval A. Staging credentials | Blocked on explicit approval | Exact mutation not yet presented |
| 3. Final staging acceptance | Not started | Approval A |
| Approval B. Production launch | Blocked on explicit approval | Go/no-go packet incomplete |
| 4. Launch | Not started | Approval B |
| 5. Four-week overlap | Not started | Production launch |
| 6. Historical completion | Not started | May begin after Phase 1; infrastructure steps approval-gated |
| 7. Remaining product completion | Not started | Independent lanes; issue closure waits for overlap and final delta |
| Final audit | Not started | All phases |

