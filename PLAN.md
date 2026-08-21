# LeanEval overhaul plan

Status: **accepted for staged implementation**. The original RFC was reviewed
and merged in [lean-eval#536](https://github.com/leanprover/lean-eval/pull/536).
Written 2026-08-19; status updated 2026-08-20.

This file preserves the original design discussion. Resolved decisions and
implementation sequencing live in the
[public implementation program](https://gist.github.com/kim-em/cd6ac1c049f459ef9aa37d6cf551d9e4)
and the [implementation tracker](https://github.com/leanprover/lean-eval/issues/541);
where they differ from an unresolved proposal below, the recorded decision is
authoritative.

This document plans a coordinated overhaul across the LeanEval repositories:

- [leanprover/lean-eval](https://github.com/leanprover/lean-eval), the problem set,
  generator, and comparator integration;
- [leanprover/lean-eval-submissions](https://github.com/leanprover/lean-eval-submissions),
  the submission pipeline and results store;
- [leanprover/lean-eval-leaderboard](https://github.com/leanprover/lean-eval-leaderboard),
  the public site at <https://lean-lang.org/eval/>;
- [leanprover/lean-eval-audit](https://github.com/leanprover/lean-eval-audit) (private),
  the encrypted archive of every evaluated submission.

It also proposes two new repositories (a submission state repo and an extracted
generator), and one new service (a submission server).

The [Workstreams](#workstreams) section records the original decomposition;
current ownership and completion state are maintained in the implementation
tracker.

Relevant discussion:
[#Model comparisons for Lean > LeanEval](https://leanprover.zulipchat.com/#narrow/channel/583341-Model-comparisons-for-Lean/topic/LeanEval),
[#Formal conjectures > Quality of life improvements](https://leanprover.zulipchat.com/#narrow/channel/524981-Formal-conjectures/topic/Quality.20of.20life.20improvements),
and [lean-eval#533 formal-conjectures integration](https://github.com/leanprover/lean-eval/issues/533).

## Where things stand

The repo currently ships 235 problems, including the 50 AnnalsChallenge
statements that landed in
[lean-eval#532 feat: add 50 AnnalsChallenge problems](https://github.com/leanprover/lean-eval/pull/532).
Submissions arrive as GitHub issues on lean-eval-submissions, are evaluated by
comparator (with nanoda as an independent kernel) in GitHub Actions, and land as
sticky `(user, model, problem)` records in the append-only results store. The
leaderboard regenerates from that store daily.

The system works, but it's showing strain:

- Progress has been much faster than expected. Single prompts to frontier
  models are now clearing previously unsolved problems in about a day, and the
  question "which problems still resist 24 hours of autonomous work?" is more
  interesting than raw solve counts.
- We collect almost no data about how solutions were produced, so the
  leaderboard can't answer the comparison questions people actually ask.
- Several recently discovered kernel soundness bugs require accepted results
  to be corroborated by more than one checker.
- Solutions leak, get copied, and get resubmitted, and we have no policy or
  tooling for any of that.
- Metadata mistakes (wrong model name, mis-filed submissions) currently require
  my manual intervention to fix.
- The leaderboard frontend is failing at scale (Lean macro recursion limits, as
  the problem count grows).
- The Formal Conjectures project wants to integrate, and is offering real labor
  to do it.

## Goals at a glance

1. Declare a fixed **v1 problem set**, curated from the current catalog.
2. Replace issue-based intake with a **submission server** that collects
   structured metadata and gives submitters self-service tools.
3. Introduce a **publication policy** for the evaluation groups: submissions
   are private, and released automatically after two months unless the
   submitter opts out.
4. Validate submissions against **additional independent kernels** from the
   [Lean Kernel Arena](https://arena.lean-lang.org), and promote checkers that
   meet the required-validation criteria.
5. Build a **replay queue** that backfills soundness verdicts, re-checking
   every historical accepted submission under the expanded kernel set as it
   grows, and computes public per-solution statistics (instruction counts,
   build cost, size) for all accepted submissions, past and future.
6. Rebuild the **leaderboard** with tabs, unique-solve emphasis, a recent
   solutions feed, and per-problem comparison pages.
7. Open a **software verification** problem group, initially all-draft.
8. Add an **open conjectures** group, with content and ownership from the
   Formal Conjectures project, and a single shared generator across the
   projects.
9. Keep submission intake live throughout, then replace the old leaderboard
   rather than maintaining long-term compatibility with it.

Each goal gets a section below. The
[Staging and migration](#staging-and-migration) section explains ordering and
dependencies.

## 1. Problem groups and lifecycle

Five properties classify every problem: group, current status, frozen-set
membership, visibility, and tags.

**Group** is the subject-matter dimension, and there are three: formalization
evaluation (the current benchmark), software verification, and open
conjectures. Groups differ in audience and submission policy (embargoed release
for the first two, public submissions for open conjectures), and each gets its
own leaderboard tab.

**Current status** is orthogonal to group. A problem is **draft**, **active**,
or **archived**. For open conjectures, an archived problem that was proved or
disproved is displayed as **resolved**; retracted or misformalised statements
remain distinguishable from genuine resolutions.

- Draft problems are solvable and listed, but outside any frozen set. New
  problems always enter as draft.
- Active problems belong to the group's current flagship set.
- Archived problems no longer belong to the flagship set. They remain in the
  repository and keep permanent problem pages.

**Frozen-set membership** is a separate, immutable relation. A problem may
belong to more than one named set. v1 is the first set in the formalization
evaluation group; software verification may freeze its own first set later;
open conjectures will likely take sets directly from FC releases (FC100 Open
Set 1, and so on). Publishing a new set does not change any earlier set.
Problems selected for the new set become active; other draft problems move to
archive, and members of the previous flagship set either join the new set or
become archived. In all cases their earlier memberships remain intact.

A resolved conjecture therefore remains in every frozen set to which it
belongs, and its solves remain in those standings. Resolution changes its
current status, not its set membership.

A problem's group is fixed for its lifetime. Visibility is a further boolean
property: the existing `test = true` manifests and Sandbox examples become
hidden problems rather than acquiring another lifecycle status.

**Tags** are the free dimension: zero or more labels per problem, displayed
and filterable, with no effect on policy, standings, or validation. Tags live
in the problem manifest (`tags = ["annals"]`) and are validated by CI against
a small registry file (tag name, display label, one-line description), so
spelling variants can't drift; adding a tag to the registry is a one-line PR.
Tag edits are metadata, freeze-compatible like docstring changes. Topic-area
tags (number theory, topology, and so on) are derived automatically from the
module path rather than hand-maintained. The first hand-applied tag is
`annals` on the 50 AnnalsChallenge problems, a mechanical backfill.

The leaderboard's site-data schema records group, current status, status
history, visibility, tags, and frozen-set memberships. Result records remain
immutable. Standings for a named set are computed from its problem membership,
so neither a status change nor the publication of a later set rewrites a
result.

## 2. The v1 problem set

The current catalog grew by accretion. v1 is the first named frozen set in
the formalization evaluation group: a curated subset that stays fixed, so
that results are comparable over a meaningful window.

**Curation.** v1 does not exist yet: curation decides what *enters* it, and
once declared, its membership never changes. Nothing is ever removed from a
frozen set; if v1 turns out too easy, the correction is a harder v2. An
LLM-assisted audit of the full catalog produces a candidate list, which I'll
review and decide on. The principles:

- A problem that many people have already solved does not enter v1. Saturated
  problems tell us nothing.
- A leaked or published solution is evidence against inclusion, but not
  determinative on its own.
- Known or suspected misformalisation risk excludes a problem until fixed.

**Problems not selected for v1.** They stay in the repository and keep
accepting submissions, but carry archive status and don't count toward v1
standings. Existing solve records are never removed.

**Draft.** Problems added after the freeze enter draft status: solvable and
listed, but outside v1 standings, promoted into v2 or archived at the next
release.

**Freeze semantics.** For problems in v1:

- Set membership is frozen permanently. v2 is a separate set and may overlap
  v1.
- Statements are frozen. Docstring-only clarifications remain allowed (as in
  [lean-eval#501](https://github.com/leanprover/lean-eval/pull/501) and
  [lean-eval#502](https://github.com/leanprover/lean-eval/pull/502)).
- Toolchain and Mathlib bumps are allowed; statements re-elaborate against the
  new pins. A bump that changes a statement's meaning is treated as a
  misformalisation incident.
- New solves continue to enter the v1 standings.

**Statement revisions.** A frozen-set entry identifies both a problem and its
statement revision. Docstring changes do not create a revision. If a frozen
statement must change meaningfully, the old revision is marked retracted and
the corrected revision returns as draft; existing solves remain attached to
the old revision and do not count as solves of the corrected statement. A
retracted set entry remains visible in set history but contributes neither a
problem nor its solves to current standings. This is the common incident
procedure for every group, including upstream fixes to Formal Conjectures
problems. A logically unchanged source migration may keep the revision only
after CI verifies that the generated challenge is unchanged.

**Flavour text review.** Alongside the audit, a thorough review of the prose
attached to every existing problem, bringing it to a uniform standard with
three parts:

- an informal statement of the problem;
- citations and literature background;
- hints for solving the problem. These will remain highly variable, and
  **no LLM-generated text goes in the hints**.

The freeze permits docstring changes, so this review can run before or after
the v1 declaration.

**Versioning.** Result records already carry `benchmark_commit`. Frozen-set
membership belongs to problems, not results: a solve may count in several
sets, including a set declared after the solve was accepted. Statement-changing
fixes use the incident procedure above rather than overloading set membership.

I expect v1 to remain the flagship set for at least a couple of months, and to
be succeeded only by an equally deliberate v2.

## 3. The submission server

Issue-based intake has served us, but it can't carry what we now need:
structured metadata, post-hoc amendment, self-service repair, and enforcement
of the publication policy. The replacement is a small Cloudflare Worker in the
style of the Palomar submission server.

**Architecture principles:**

- The Worker holds **no mutable application state between requests**. Every
  durable public fact is an append-only JSON event committed to a new repository (working name:
  `leanprover/lean-eval-state`), and every transition is a commit. Source,
  credentials, and one-time challenges are excluded. Event IDs make retries
  idempotent, and writers update against the current repository head so two
  transitions cannot silently overwrite each other. An operator CLI can
  reconstruct the current view and drive any submission to a terminal state.
- **Identity is GitHub.** A person signs in with GitHub OAuth so the server can
  learn the login; the token is checked and discarded, never stored. Private
  source access uses a read-only GitHub App installation scoped to the
  submission repository, not a long-lived user token. An agent path (a tag at
  the submitted commit plus a secret gist owned by the submitting account,
  carrying an expiring challenge)
  supports headless submission without a browser. Acceptance of a challenge
  records its nonce, preventing reuse.
- **Evaluation uses an immutable snapshot.** At intake, the GitHub App fetches
  `Submission.lean` and `Submission/` at the declared commit and stores an
  encrypted snapshot in the audit archive. Evaluation and later release use
  that snapshot, so neither requires continuing access to the submitter's
  repository.
- **Evaluation stays in GitHub Actions.** The server does intake, validation,
  and record-keeping; comparator runs where it runs today, in public workflows
  with public logs containing no submission source.
- **Base results remain in lean-eval-submissions.** Accepted results still land
  there as immutable records. Amendments, retractions, release events, and
  replay results live in the state repo. The site-data build materializes the
  current public view from both repositories; neither event stream is rewritten.

**Repository privacy.** The audit archive should remain the **only** private
repository. In particular the state repo is designed to be public: submission
records, amendments, and queue state aren't confidential (acceptances appear
on the leaderboard anyway, and the results store already publishes submission
repo names). One-time challenges are signed by the Worker and never committed.
Public repositories also keep us on GitHub's free Actions minutes. Every flow
that handles embargoed content, including initial evaluation and replay, must
ensure that public logs and artifacts contain only verdicts and statistics.
Steps that cannot guarantee this run in the private audit repository.

**Structured metadata at intake.** Replacing today's free-form "how this was
produced" box:

- one leaderboard credit identity: the primary model for a single-model run,
  or an explicit ensemble identity when several models contributed materially;
- component model names and versions, plus orchestrator/harness if any;
- level of human involvement (fully autonomous / human-directed / human-written
  with AI assistance / other);
- web access during the run (none / search with blocklist / unrestricted /
  unknown), self-reported;
- compute: wall-clock time, token counts, and estimated cost, with
  subscription vs API noted;
- the prompt(s) used, optional but encouraged: shared prompts are how
  techniques spread;
- free-form notes.

All of this is self-reported and displayed as such. We standardize the
questions, not the enforcement; see the publication policy section for why I
think enforcement of web-access rules isn't realistic for us.

**Amendments.** The state repo records amendments as first-class, append-only
events, authenticated as the GitHub login that owns the base result. A
maintainer can handle renamed or deleted accounts, with the intervention
recorded publicly.

- **Backfill**: add the structured metadata above to any of your existing
  submissions. Backfilled data is permanently marked "backfilled on date", as
  distinct from "declared at submission", so consumers of the data know which
  numbers were recorded at the time and which were recalled later.
- **Model rename/consolidation**: rename or merge model labels within your own
  account, self-service. The rename history is public on the affected entries;
  `solved_at`, `benchmark_commit`, and submission references are immutable
  through a rename. Site data maps declared labels to canonical credit
  identities using a public alias table. Mapping to an existing identity is
  self-service; a maintainer checks a new identity for duplicates, so spelling
  variants cannot change unique-solve counts. A merge that collides with an
  existing `(user, model, problem)` record preserves both base records but
  contributes only one solve to standings.
- **Repair**: correct intake metadata, including the problem ID, only when the
  immutable comparator record already identifies the corrected challenge.
  Group follows from the problem and is not independently repairable. A repair
  cannot turn an evaluation for one challenge into a solve of another.

**Deprecation of issue intake.** The issue path keeps working through a
deprecation window after the server launches (proposal: four weeks), then
closes. During the window both paths write the same base-results store, so the
site-data build handles them identically. Amendments and the new publication
policy are available only through the server path.

## 4. Publication policy

Today submitters self-declare one of three publication tiers with no
enforcement. Two recurring complaints are solution leakage and permanently
private solutions. The new policy applies to submissions made through the
server. Submissions through the issue path during its deprecation window remain
under the old policy because that path does not collect the new acknowledgement.

- **Evaluation-group submissions must come from private sources.** This
  applies to the formalization evaluation and software verification groups.
  (We can't stop simultaneous publication elsewhere, but we ask.) Open
  conjecture submissions instead must be public from the start; see the open
  conjectures section.
- **Solutions are released automatically two months after acceptance**,
  published by us from the accepted snapshot in the audit archive. Publication
  contains the exact evaluated `Submission.lean` and `Submission/` files, plus
  public metadata; it excludes repository metadata, credentials, generated
  challenge files, and unrelated files. Submitting includes an acknowledgement
  that the submitter has authority to license those files and grants a license
  (proposal: Apache 2.0) that takes effect at release.
- **Submitters may opt out** at submission time or any time before release.
  Opt-outs are recorded and displayed on the leaderboard entry ("solution
  withheld"). The default is release; opting out is visible.
- **Existing submissions are grandfathered.** Their declared tiers stand. The
  backfill mechanism includes an invitation to opt in to release.

The proposed two-month delay should outlast most evaluation runs while releasing
proofs soon enough to remain useful. I'm open to argument about the duration.
The append-only event order resolves an opt-out racing with release: an opt-out
recorded before the release transition prevents publication. Release jobs are
idempotent, record failures, and retry without changing the scheduled date.

**Audit-archive key management.** The archive is currently encrypted to a
single key that only I hold, which is incompatible with automatic release.
Part of this work is a one-off re-encryption of the historical archive. The
release job should be able to decrypt only the submission due for release, not
the whole archive; its credentials must not enter a public workflow. At least
two maintainers should be able to recover or rotate the release keys. The exact
key scheme is an implementation decision subject to a security review.

On web search and training-data contamination: several people have proposed
standardized blocklists or verified clean-run protocols. I don't think we can
referee that from here; we can't observe anyone's harness. Instead we collect
the structured self-report above and display it, so consumers of the
leaderboard can filter by claimed methodology. If a lab wants to demonstrate a
clean run, the methodology fields give them a place to say so.

Release also permits downstream reuse in Mathlib,
[LeanPool](https://github.com/vasnesterov/LeanPool), and TauCeti. This plan does
not assign that downstream work.

## 5. Copycat detection (deferred)

We've had submissions that were substantially copies of already-public
solutions, and I've handled them by hand. An automated rejection scheme
(normalized compression distance against all prior submissions, calibrated on
the corpus) was drafted for this plan and cut after review feedback: short
proofs legitimately converge on near-identical text, a determined cheater can
rewrite around any similarity measure, and the manual workload so far doesn't
justify the machinery.

What remains instead: the publication policy makes copying harder to begin
with (submissions are private, releases are delayed), and the leaderboard's
emphasis on unique solves means a copied solution earns nothing distinctive.
Egregious cases keep being handled by hand: an accepted copy receives an
append-only retraction event and stops counting in standings; the base result
is not deleted. Building on public prior work (reusing lemmas, following a
published proof strategy) was never in question; it's what released solutions
are for.

If wholesale copying becomes a practical problem again, the drafted scheme is
in this document's history and can be revived.

## 6. Independent kernel validation

After the recent soundness discoveries, this is a priority: as well as the
standard kernel and nanoda, test submissions against a selection of the
experimental kernels at the
[Lean Kernel Arena](https://arena.lean-lang.org), collecting both acceptance
and performance data. A checker is eligible for **required validation** when it
has no incorrect arena verdicts, supports every construct used by the current
corpus, agrees with the adjudicated corpus verdicts, and runs in reasonable
time. Timeouts and explicitly unsupported tests are recorded separately from
incorrect acceptance or rejection.

**Where the arena stands** (snapshot 2026-08-18, 19 checkers, 193 tests):

- Only `official-nightly` is clean on every test. The stable official kernel
  fails three soundness tests (fixed in nightly); this is exactly why we want
  checker diversity.
- `lean4lean` has no soundness failures (its one failure is a performance
  test) and runs the full Mathlib export in about 1.6x the official-nightly
  wall time. It's the leading promotion candidate today.
- The fast Rust checkers (`sokonanoda`, `zignodamus`, `mathgraph`, `nanoclo`,
  10x to 40x faster than official on the Mathlib export) each fail exactly one
  soundness test (`extra-rec`). Each is one fix away from candidacy, and we
  should tell their authors so.
- `nanoda`, which we already require, has zero incorrect results but declines
  nine tests. Note also that the arena pins a different nanoda fork and
  revision than we do; the pins should be reconciled.

**Plan.**

- **Close known holes first.** Before the broader replay, check each known
  stable-kernel failure against the current official-plus-nanoda required
  checks. If a
  known exploit passes both, update the required pin or temporarily reject the
  affected construct before accepting more submissions.
- **Backtest immediately.** I'll decrypt the audit archive; the replay queue
  (next section) exports each historical submission once and fans the export
  out to candidate checkers. This yields acceptance and performance data over
  the whole corpus right away, and doubles as the historical re-validation
  under patched kernels that several people have asked for.
- **Shadow mode for new submissions.** Candidate checkers run on every new
  submission after acceptance, recording verdicts without affecting them. Any
  disagreement between checkers on a real submission triggers a soundness
  investigation. A rejection may indicate either a bad submission or an
  incomplete checker; raw agreement with comparator is not the criterion.
- **Adjudication.** Each disagreement gets a recorded resolution with checker,
  exporter, and toolchain revisions. A historical result found invalid receives
  a retraction event, stops counting in standings, and remains visible with the
  reason. A corrected submission may be evaluated as a new result.
- **Promotion.** A checker becomes required when it satisfies the eligibility
  conditions above and runs within budget (roughly: up to 3x the official
  kernel is acceptable).
- **Required-checker failures.** Every required checker must accept a new
  submission. A rejection, decline, crash, or timeout blocks automatic
  acceptance and opens an incident. A checker that no longer supports the
  allowed submission language is demoted until fixed rather than silently
  narrowing the benchmark.
- **Pinning.** We build candidate checkers from source at pinned revisions
  under the SECURITY.md regime and run them sandboxed, the same discipline as
  the existing tools. We use the arena's published results to select
  candidates, but we don't trust its binaries or its unsandboxed runs for our
  validation path.

**Export-format caveat.** The lean4export NDJSON format is
[still in flux](https://github.com/leanprover/lean4export/issues/3), and every
checker was written against some version of it. The plan pins an exporter and
checker revision matrix, not just checker revisions. A format mismatch is
reported separately from a checker verdict.

All candidate checkers currently share lean4export, so checker diversity does
not cover bugs in the exporter or comparator's Challenge/Solution comparison.
That common dependency remains in the trust base and is versioned in every
verdict. An independent export path would reduce this residual risk, but is not
a prerequisite for the first checker promotions.

## 7. The replay queue and solution statistics

One harness serves both the kernel work above and the comparison data below.

**Mechanics.** The queue contains versioned tasks keyed by accepted submission
and measurement configuration. Queue events are files in the state repo, and a
GitHub Actions cron processes them. Retries have the same task ID and cannot
create a second result. For each submission, the harness:

1. checks out the trusted generated workspace at `benchmark_commit`;
2. overlays only the accepted `Submission.lean` and `Submission/` snapshot from
   the audit archive;
3. restores the original pinned toolchain and dependencies;
4. builds and exports through the same sandboxed path used for intake, with no
   credentials and no network available to submitter code;
5. fans the export out to each candidate checker, recording verdict,
   wall-clock, and retired-instruction counts;
6. records build cost and size statistics.

The archive is not treated as a trusted Lake workspace. Historical toolchains,
source dependencies, and required binary artifacts must be retained or mirrored;
otherwise a replay is marked unavailable rather than silently moved to newer
pins.

**Public statistics.** For every solution, the leaderboard will show:

- **Checker replay instructions**: instruction count of a designated reference
  checker replaying the export. Retired instructions are less noisy than
  wall-clock time on shared runners, but are not machine-independent.
- **Build cost**: instructions and wall-clock for building the submission
  workspace, i.e. elaboration cost.
- **Size**: lines of code and file count across `Submission.lean` and
  `Submission/`.

Every measurement records the toolchain, exporter and checker revisions,
runner architecture, measurement command, cache state, and attempt number.
Reference measurements use a pinned runner class; if its performance counters
are unavailable, instruction counts are omitted rather than estimated. A new
reference-checker or runner revision creates a new measurement series and does
not overwrite the old one.

Each workspace replays under its original toolchain. Measurements are most
comparable within one measurement series and toolchain era, and only
approximately comparable across toolchain bumps. The toolchain is displayed as
a field, but comparison tables remain flat unless the corpus replay shows a
material toolchain effect. Problems with submissions spanning toolchains give
an empirical estimate of that effect. Old submissions may require
toolchain-specific lean4export builds.

The queue isn't one-shot: when a new candidate checker joins or an existing one
is re-pinned, the corpus receives new tasks for that checker configuration.
Historical measurements remain available, while the current view uses the
latest completed configuration.

Some very early submissions may predate the audit archive; we replay what we
can and mark the rest.

## 8. The leaderboard

The frontend needs both new features and a sturdier architecture. The current
site generates pages from Lean macros, and has twice hit recursion limits as
the catalog grew (patched both times by Vasily, thank you).

**Architecture.** Keep Verso for the site shell, navigation, and prose pages,
so we stay consistent with lean-lang.org. Move the data-heavy surfaces
(problem tables, solution lists, comparison views) to client-side rendering
from JSON. `site-data/` already exists as the derived-data layer; it becomes
the interface. Its schema is versioned and split into a small index plus
per-group and per-problem files, so the browser need not load the full corpus.
The client-side tables support sorting and filtering.

**Features:**

- **Tabs are groups.** Top-level navigation is the three groups
  (formalization evaluation, software verification, open conjectures), each
  stating its submission policy on the tab.
- **A scope selector within each tab, defaulting to the flagship set.** On the
  formalization evaluation tab: `v1 | draft | archive`, defaulting to v1.
  Named sets and current-status views may overlap: for example, a resolved
  conjecture remains in its FC100 set and also appears under `resolved`.
  Standings and problem tables apply to the selected scope. When v2 exists it
  becomes the default and v1 remains available. A selector with a single
  option is not rendered.
- **Tag chips and filters.** Problem rows show their tag chips; a tag filter
  narrows the tab's problem list and recomputes the standings table for the
  filtered subset client-side. The filter persists in the URL, so "just the
  Annals problems" is a shareable link, and the tab already supplies the
  context, so a filtered view doesn't restate the group. Internally the
  frontend treats a tab as a pinned filter, letting tab and tag views share
  rendering code; the data model keeps group as its own required field.
- **Unique-solve emphasis.** Model standings are computed per (group,
  selected scope). The default leaderboard lists models ordered by number of
  unique solves (problems where that canonical credit identity is the only one
  with an accepted, unretracted solve), with a toggle to switch the ordering
  to total solves. Component models of an ensemble do not separately receive
  the solve. Each model's card shows unique, first, and total solve counts (a
  first solve is the earliest accepted solve of a problem, by acceptance-event
  order), leading with whichever the current sort uses. There is no combined
  cross-group leaderboard: the groups have different submission policies, so
  their standings are not comparable. The front page shows headline numbers
  per tab instead.
- **Recent solutions feed**: a chronological page of new solves (problem,
  model, submitter, date, first-solve flag), from the materialized result and
  amendment view. It is global across groups, with group badges and a filter.
  It also has an RSS feed.
- **Per-problem comparison pages**: all solutions to a problem side by side
  with model, metadata, statistics from the replay harness, and links to
  released solutions. These pages support fixed-problem comparisons of models
  and harnesses.
- **Metadata display** with provenance: declared-at-submission vs backfilled,
  self-reported throughout, opt-out status visible.
- **Stable URLs**: existing problem URLs (`/eval/problems/<id>`) keep
  working. A problem's page is permanent and status-agnostic: it shows the
  problem's group, current status, status history, and all solutions, so
  archived and resolved problems keep first-class pages. Meaningful statement
  revisions and retractions are visible on the same page.

## 9. Software verification

A new problem group, alongside formalization evaluation. It launches with
every problem in **draft status**: no frozen set, problems added and revised
freely. Standings shown but explicitly provisional; the group can freeze its
own first set later, on its own schedule.

In scope, in rough order of arrival:

1. **Theory-of-programs theorems**: deep results about formal systems, in
   standard comparator shape. Two seed problems are drafted, posted as gists
   for comment:
   [strong normalization and consistency for a calculus of constructions with
   a universe hierarchy](https://gist.github.com/kim-em/ede78934812e777e75836f6c5509f769),
   and
   [quantifier elimination and a decision procedure for real closed
   fields](https://gist.github.com/kim-em/5c2b7d45dbcc13970b13e49bf2251165).
2. **Verified software artifacts**: correctness theorems about executable
   programs (compilers, data structures, protocols), still
   comparator-checkable.
3. **Verified calculations**: performance-ranked verified implementations
   ("fastest verified X"). This needs
   execution and timing infrastructure that comparator doesn't have, so it's
   in scope but phased last; the draft group permits prototyping before a
   frozen set is defined. Before accepting these submissions we need a separate
   specification of trusted inputs, sandboxing, runner hardware, repetitions,
   resource limits, and anti-specialization rules.

## 10. The open conjectures group

The third group is **open conjectures**: statements with no known proof. This
group is **not an evaluation set**, and the site displays and describes it
differently from the evaluation groups, keeping claims about model capability
and claims about progress on open problems clearly separate. The
tab is not branded around any one source, but the content is expected to come
overwhelmingly from the
[Formal Conjectures](https://github.com/google-deepmind/formal-conjectures)
project, which has offered to integrate its problem sets, starting with the
frozen FC100 open list (one hundred open conjectures). The FC contributors
are interested in owning this part of lean-eval. I propose giving them merge
rights for problem PRs in the group. Coordination:
[lean-eval#533](https://github.com/leanprover/lean-eval/issues/533) and
[formal-conjectures#4930](https://github.com/google-deepmind/formal-conjectures/issues/4930).

**Submission policy.** Open conjectures differ from problems with known
informal solutions:

- **Public submissions required from the start.** A claimed solution to an
  open conjecture must be inspectable, especially because misformalisation is
  a risk. No embargo, no opt-out; the submission URL and exact commit must be
  public. We still archive the accepted snapshot, so later repository changes
  cannot change the evaluated source.
- **Only open conjectures go in this group.** FC's research-solved statements
  (formalized theorems without a recorded formal proof) don't get their own
  policy or tab; the only role for them here is as a future source of
  candidate problems for the benchmark's draft group.
- **Resolution.** A conjecture becomes resolved when it is proved or disproved.
  It leaves the current open-problem view but remains in every frozen set to
  which it belongs, and its solves remain in those standings. Retraction as
  misformalised is recorded separately from resolution. Resolved conjectures
  may continue to accept independent submissions.
- **Disproofs allowed.** A proof of the negation is as
  valuable as a proof. This needs the comparator disproof support in
  [Auguste's branch](https://github.com/augustepoiroux/comparator/tree/upstream/disproofs)
  to be upstreamed; there are known universe-level subtleties (Eric Wieser has
  thought about these). The FC integration motivates this comparator
  workstream.

**One generator.** The projects use one workspace generator. The generator
core currently inside `EvalTools`
(the part that turns a marked-up Lean module plus a manifest into a Challenge /
Solution / Submission workspace, with all the import- and scope-fidelity work
from [lean-eval#531](https://github.com/leanprover/lean-eval/pull/531)) gets
extracted into its own repository (working name:
`leanprover/lean-eval-generator`), consumed as a pinned dependency by lean-eval
and by the FC importer. The FC importer does not fork the generation logic.

**Hosting: vendored, FC-owned importer.** FC problems are vendored into
lean-eval like every other problem. LeanEval remains the trusted statement
repository and supplies the pin regime and CI. The FC side owns an importer
(evolving their existing
[formal-conjectures#4951](https://github.com/google-deepmind/formal-conjectures/pull/4951)
adapter) that maps FC declarations and metadata to LeanEval modules and
manifests, and emits PRs to lean-eval that our CI validates like any other
problem PR. Each manifest records the FC source commit and declaration ID. When
FC fixes a misformalisation upstream, the importer regenerates and PRs the
corrected revision. The statement-revision policy above determines the
treatment of existing solves.

**Technical extensions needed**, in dependency order:

1. generator extraction (above);
2. definition holes / `answer(sorry)`: already supported;
3. disproof support: comparator upstreaming, then generator and manifest
   support for "prove or disprove" problems;
4. multi-file Challenge support (imports between trusted files), which the
   generator partially has via `ChallengeDeps` and comparator constrains;
   scope this with the FC folks against the actual FC100 statements rather
   than in the abstract.

Several FC contributors have said they have time for this now, with more
available around the September workshop.

## Staging and migration

Submission intake remains live throughout. The old leaderboard may temporarily
omit or misclassify new statuses, amendments, and groups during the short
migration; it will be taken offline after the new site replaces it. We do not
maintain a compatibility layer for it.

Two interfaces support the migration:

- Immutable base results remain in lean-eval-submissions. The new site-data
  build combines them with the append-only state events; the old site may
  continue to read only the base results until replacement.
- New validators start in shadow. The replay queue and extra checkers run on
  accepted submissions before either affects a verdict.

**Phase 0, immediately (independent of everything else):**

- Create the state repo and event/materialization skeleton. Stand up the replay
  harness; decrypt and replay the audit archive.
- Kernel backtesting uses the replay output.
- Output: corpus-wide soundness report, candidate-checker evidence, and the
  first statistics dataset.

**Phase 1, before the switchover (problem-set side):**

- v1 audit, cut decisions, freeze declared in the repo, with current statuses
  and v1 membership established alongside it.
- Software verification seed problems merge (draft status needs no freeze).
- Generator extraction can start any time; it must land before FC import PRs.

**Phase 2, the submission server:**

- Build the Worker and operator CLI against the state repo; new intake goes live
  alongside issue intake, both writing the base-results store.
- The publication policy takes effect for submissions through the server (the
  server is what collects the acknowledgements and runs the release
  countdown). Backfill, rename, and repair open here too.
- After a four-week deprecation window, issue intake closes.

**Phase 3, the leaderboard:**

- Build the new site (tabs, client-side tables, unique solves, recent feed,
  comparison pages) against the extended site-data schema, deployed to a
  preview URL while the current site keeps its daily deploys.
- Deploy once the new site renders the full materialized view correctly. Keep
  the previous deployment available for rollback during the switchover. Old
  problem URLs keep working on the new site; other old-site compatibility is
  not a goal.

**Phase 4, open conjectures:**

- Policy and importer design settle in the coordination issues; the first
  FC100 import appears as the open-conjectures tab.
- Disproof support follows comparator upstreaming and need not block the
  first import (open conjectures can launch proof-only and gain disproofs).

**Checker promotion** is not a phase; it happens whenever the evidence from
Phase 0 justifies it, independent of everything else.

These phases are a dependency order, not a calendar, and much of the work can
run concurrently. The target leaderboard migration window is about one week;
the issue-intake deprecation may continue after the site replacement.
Submission intake stays open, and the new site replaces the old one after
full-store validation.

## Workstreams

Separable pieces, in no particular order. None of these are assigned. Volunteer
on
[lean-eval#533](https://github.com/leanprover/lean-eval/issues/533) for FC
work or on the Zulip threads above for everything else.

The default, for anything nobody claims: I'll point Sol at the bulk of this
list. The exceptions are 8 and 9, which belong with the Formal Conjectures
and comparator contributors respectively, and 12, which is human-written by
design. Human hands also stay on the key ceremony in 5 and on final review of
trusted problem statements in 10.

1. **Replay harness**: audit-archive restore, original-pin builds, export,
   checker fan-out, statistics capture, queue mechanics.
2. **Kernel backtesting**: run candidates over the corpus, chase
   disagreements, reconcile our nanoda pin with the arena's, report
   `extra-rec` status to the fast-checker authors, assemble promotion cases.
3. **v1 audit**: LLM-assisted catalog review producing the candidate list
   with evidence (solve counts, known leaks, misformalisation risk).
4. **Problem metadata**: group, status, visibility, statement revisions,
   frozen-set membership and history, tags and the tag registry (including
   auto-derived topic-area tags and the `annals` backfill), validation, and
   migration of the current catalog.
5. **Submission server**: Worker, state repo and materializer, operator CLI,
   OAuth and agent paths, GitHub App snapshots, amendment/repair records,
   release countdown, archive publication, and the audit-archive key changes
   that automatic release requires.
6. **Leaderboard v2**: extended site-data schema, canonical model identities,
   client-side tables, tabs, unique-solve standings, recent feed, comparison
   pages.
7. **Generator extraction**: factor the generator core out of `EvalTools`
   into its own repo, consumed by lean-eval and the FC importer.
8. **FC importer**: FC-side, evolving
   [formal-conjectures#4951](https://github.com/google-deepmind/formal-conjectures/pull/4951)
   to emit lean-eval problem PRs through the shared generator.
9. **Comparator disproof support**: upstream
   [Auguste's branch](https://github.com/augustepoiroux/comparator/tree/upstream/disproofs),
   resolve the universe questions, then generator/manifest support.
10. **Software verification problems**: author and review problems for the
    draft group; design the verified-calculations execution infrastructure.
11. **Policy text**: the submitter-facing versions of the publication policy,
    license acknowledgement, and metadata forms.
12. **Flavour text review**: uniform informal statements and
    citations/literature background across the catalog, plus hints where
    authors have them (human-written only).

## Open questions

Feedback is particularly welcome on:

1. Is two months the right embargo length?
2. Which comparison statistics matter to you beyond instruction counts, build
   cost, and size?
3. Is there appetite among the fast-checker authors to fix `extra-rec` and
   join the required-validation set?
