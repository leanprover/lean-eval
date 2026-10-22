import Lean
import EvalTools.Manifest
import EvalTools.Markers
import EvalTools.Subprocess

/-!
# `lake exe lean-eval check-library-drift`

Driver for the library-drift probe (`EvalTools/LibraryDriftProbe.lean`). It
selects manifest modules, runs the probe executable over them in batches,
parses the JSON it emits, applies the manifest's `probe_exempt` policy, and
fails when a hole that is meant to stay open closes at the pinned toolchain.

The probe is deliberately dumb: a fixed tactic battery, a heartbeat cap, and a
kernel check. A hole it closes is a candidate for human adjudication, not a
verdict; a hole it does not close proves nothing.
-/

open Lean
open Lake
open Lake.Toml
open LeanEvalGenerator.Core

namespace EvalTools

set_option autoImplicit false

/-- A closing term reported by the probe, after the kernel check. -/
structure ProbeClosure where
  /-- Name of the probe in the battery, for example `rfl` or `library_search`. -/
  probe : String
  /-- `true` when the probe ran after `exfalso`, so the hypotheses are
  contradictory rather than the conclusion trivial. -/
  vacuity : Bool
  /-- `kernel_ok`, or the kernel's complaint. -/
  kernel : String
  /-- Axioms of the term, treating definition holes as opaque leaves. -/
  axioms : Array String
  /-- Prop-valued `@[eval_problem]` declarations the term mentions. Any is a
  self-reference. -/
  holeReferences : Array String
  /-- Kernel accepted, standard axioms only, no hole references. -/
  clean : Bool
  /-- Pretty-printed term, truncated by the probe. -/
  proof : String
  deriving Inhabited, Repr, BEq

/-- One JSON line emitted by `eval_library_drift`. -/
inductive ProbeEvent where
  /-- A module was imported; `holes` tagged declarations follow. -/
  | module (name : String) (holes : Nat)
  /-- A tagged declaration, probed only when `isProp`. -/
  | hole (module decl kind : String) (isProp : Bool) (type : String)
  /-- A probe that did not close the hole; `outcome` says why. -/
  | attempt (decl probe outcome : String)
  /-- A probe that produced a term. -/
  | closed (decl : String) (closure : ProbeClosure)
  deriving Inhabited, Repr, BEq

/-- Parse one line of probe output. -/
def parseProbeEvent (line : String) : Except String ProbeEvent := do
  let json ← Json.parse line
  let event ← json.getObjValAs? String "event"
  match event with
  | "module" =>
      return .module (← json.getObjValAs? String "module") (← json.getObjValAs? Nat "holes")
  | "hole" =>
      return .hole (← json.getObjValAs? String "module") (← json.getObjValAs? String "decl")
        (← json.getObjValAs? String "kind") (← json.getObjValAs? Bool "isProp")
        (← json.getObjValAs? String "type")
  | "probe" =>
      let decl ← json.getObjValAs? String "decl"
      let probe ← json.getObjValAs? String "probe"
      let outcome ← json.getObjValAs? String "outcome"
      if outcome != "closed" then
        return .attempt decl probe outcome
      return .closed decl {
        probe
        vacuity := ← json.getObjValAs? Bool "vacuity"
        kernel := ← json.getObjValAs? String "kernel"
        axioms := ← json.getObjValAs? (Array String) "axioms"
        holeReferences := ← json.getObjValAs? (Array String) "holeReferences"
        clean := ← json.getObjValAs? Bool "clean"
        proof := ← json.getObjValAs? String "proof" }
  | other => throw s!"unknown probe event kind {repr other}"

/-- Everything the probe reported about one tagged declaration. -/
structure HoleReport where
  module : String
  decl : String
  kind : String
  isProp : Bool
  type : String
  /-- Closing terms in probe order, clean or not. -/
  closures : Array ProbeClosure := #[]
  /-- Library search found complete proofs, but every one mentioned a hole. -/
  selfReferenceOnly : Bool := false
  /-- Probes that hit their heartbeat cap. -/
  timeouts : Array String := #[]
  /-- Probes that hit a runtime error other than the heartbeat cap, or whose
  tactic could not be parsed in the module's environment, as `probe: message`.
  Ordinary tactic failures are not errors. -/
  errors : Array String := #[]
  deriving Inhabited, Repr

/-- The first closure the kernel accepted with standard axioms and no hole
references, if any. -/
def HoleReport.cleanClosure? (report : HoleReport) : Option ProbeClosure :=
  report.closures.find? (·.clean)

/-- Group probe events by declaration. Returns the modules the probe reported
on and one report per tagged declaration, in probe order. A probe event for a
declaration no `hole` event introduced is an error: the probe's output is the
only evidence this check has, so it must be internally consistent. -/
def collectHoleReports (events : Array ProbeEvent) :
    Except String (Array String × Array HoleReport) := do
  let mut modules : Array String := #[]
  let mut holes : Array HoleReport := #[]
  let mut index : Std.HashMap String Nat := {}
  let lookup (index : Std.HashMap String Nat) (decl : String) : Except String Nat :=
    match index[decl]? with
    | some i => pure i
    | none => throw s!"probe reported on `{decl}` before introducing it"
  for event in events do
    match event with
    | .module name _ =>
        modules := modules.push name
    | .hole module decl kind isProp type =>
        index := index.insert decl holes.size
        holes := holes.push { module, decl, kind, isProp, type }
    | .attempt decl probe outcome =>
        let i ← lookup index decl
        let report := holes[i]!
        let report :=
          if outcome == "timeout" then
            { report with timeouts := report.timeouts.push probe }
          else if outcome == "self_reference_only" then
            { report with selfReferenceOnly := true }
          else if outcome.startsWith "error" || outcome.startsWith "parse_error" then
            { report with errors := report.errors.push s!"{probe}: {outcome}" }
          else
            report
        holes := holes.set! i report
    | .closed decl closure =>
        let i ← lookup index decl
        let report := holes[i]!
        holes := holes.set! i { report with closures := report.closures.push closure }
  return (modules, holes)

/-- A manifest entry's problem id and module, with some of its hole names:
either the entry's `holes` or its `probe_exempt`, the holes the maintainers
expect to close, such as anti-vacuity guards. -/
structure ManifestHoles where
  problemId : String
  moduleName : String
  holes : Array String
  deriving Inhabited, Repr, BEq

private structure ExemptionRow where
  id : String
  moduleName : String
  holes : Array String
  probeExempt : Array String

private instance : DecodeToml ExemptionRow where
  decode v := do
    let t ← v.decodeTable
    let id : String ← t.decode `id
    let moduleName : String ← t.decode `module
    let holes : Array String ← t.decode `holes
    let probeExempt? : Option (Array String) ← t.decode? `probe_exempt
    return { id, moduleName, holes, probeExempt := probeExempt?.getD #[] }

private def parseExemptionRow (contents : String) (fileName : String) :
    IO (Except String ExemptionRow) := do
  let inputCtx := Parser.mkInputContext contents fileName
  let table ←
    match (← Lake.Toml.loadToml inputCtx |>.toBaseIO) with
    | .ok table => pure table
    | .error err => return .error (← Lake.mkMessageLogString err)
  let decoded : EStateM.Result Unit (Array DecodeError) ExemptionRow :=
    (DecodeToml.decode (α := ExemptionRow) (Lake.Toml.Value.table Syntax.missing table)).run #[]
  match decoded with
  | .ok row errors =>
      if errors.isEmpty then return .ok row
      return .error (decodeErrorsToString errors)
  | .error _ errors => return .error (decodeErrorsToString errors)

/-- Read `probe_exempt` from every file in `manifests/problems/`. Entries
without the field, or with an empty one, are omitted. Every exempt name must
also appear in the entry's `holes`; a name that matches nothing would exempt
nothing and is almost certainly a typo. -/
def loadProbeExemptions (root : System.FilePath) : IO (Array ManifestHoles) := do
  let manifestDir := root / defaultManifestRelativePath
  unless ← manifestDir.isDir do
    throw <| IO.userError
      s!"Manifest directory `{manifestDir}` does not exist or is not a directory."
  let files := (← manifestDir.readDir).filter (·.path.extension == some "toml")
    |>.qsort fun a b => a.fileName < b.fileName
  let mut out : Array ManifestHoles := #[]
  for file in files do
    let row ←
      match ← parseExemptionRow (← IO.FS.readFile file.path) file.path.toString with
      | .ok row => pure row
      | .error err => throw <| IO.userError err
    if row.probeExempt.isEmpty then
      continue
    for name in row.probeExempt do
      if name.isEmpty then
        throw <| IO.userError s!"Manifest entry `{row.id}` has an empty string in `probe_exempt`."
      unless row.holes.contains name do
        throw <| IO.userError
          s!"Manifest entry `{row.id}` lists `{name}` in `probe_exempt` but not in `holes`."
    out := out.push { problemId := row.id, moduleName := row.moduleName, holes := row.probeExempt }
  return out

/-- Whether some entry of `sets` names `decl` in `moduleName`. Names match the
way manifest `holes` match tagged declarations: by full name or by last
component. -/
def coversHole (sets : Array ManifestHoles) (moduleName decl : String) : Bool :=
  let declName := parseHierarchicalName decl
  sets.any fun e =>
    e.moduleName == moduleName && e.holes.any (holeMatches declName ·)

/-- Whether `decl` in `moduleName` is covered by an exemption. -/
def isExemptHole (exemptions : Array ManifestHoles) (moduleName decl : String) : Bool :=
  coversHole exemptions moduleName decl

/-- Result of one `check-library-drift` run. -/
structure DriftReport where
  /-- Modules the probe reported on. -/
  modules : Array String
  /-- Every manifest entry's `holes`, to name the problem a hole belongs to. -/
  problems : Array ManifestHoles
  holes : Array HoleReport
  exemptions : Array ManifestHoles

/-- A hole with a clean closure. -/
structure DriftFinding where
  hole : HoleReport
  closure : ProbeClosure
  exempt : Bool
  deriving Inhabited

/-- Every hole with a clean closure, exempt or not. -/
def driftFindings (report : DriftReport) : Array DriftFinding :=
  report.holes.filterMap fun hole =>
    hole.cleanClosure?.map fun closure =>
      { hole, closure, exempt := isExemptHole report.exemptions hole.module hole.decl }

/-- The findings that fail the check. With `applyExemptions := false` every
clean closure fails, which is how the tests confirm the positive controls. -/
def failingFindings (report : DriftReport) (applyExemptions : Bool := true) :
    Array DriftFinding :=
  (driftFindings report).filter fun finding => !(applyExemptions && finding.exempt)

/-- Exempt Prop-valued holes that did not close. The exemption may be stale. -/
def staleExemptions (report : DriftReport) : Array HoleReport :=
  report.holes.filter fun hole =>
    hole.isProp && hole.cleanClosure?.isNone &&
      isExemptHole report.exemptions hole.module hole.decl

/-- Modules per probe process. One process pays one import of the modules'
closure, which is dominated by Mathlib; ten modules keep that cost amortised
without letting a single crash take the whole shard's evidence with it. -/
def probeBatchSize : Nat := 10

/-- Split `items` into consecutive chunks of at most `size`. -/
def chunkArray {α : Type} (items : Array α) (size : Nat) : Array (Array α) := Id.run do
  let size := max size 1
  let mut out : Array (Array α) := #[]
  let mut current : Array α := #[]
  for item in items do
    current := current.push item
    if current.size == size then
      out := out.push current
      current := #[]
  if !current.isEmpty then
    out := out.push current
  return out

/-- Build the probe executable and, unless a preceding trusted step already did
so, each requested problem module separately (see `runInventoryTool` for why
not in one `lake build`). Then run the probe over the modules in batches and
parse every line it prints. Anything the probe writes to stderr is passed
through; anything on stdout that is not a probe event is an error. -/
def runLibraryDriftProbe (root : System.FilePath) (modules : Array String)
    (buildModules : Bool := true) : IO (Array ProbeEvent) := do
  let _ ← runCmdCheckedCaptured "lake" #["build", "eval_library_drift"] root
    "Failed to build the library-drift probe"
  if buildModules then
    for moduleName in modules do
      let _ ← runCmdCheckedCaptured "lake" #["build", moduleName] root
        s!"Failed to build Lean problem module '{moduleName}'"
  let binPath := root / ".lake" / "build" / "bin" / "eval_library_drift"
  let mut events : Array ProbeEvent := #[]
  for batch in chunkArray modules probeBatchSize do
    let out ← runCmdCaptured "lake" (#["env", binPath.toString] ++ batch) root
    let stderr := out.stderr.trimAscii.toString
    unless stderr.isEmpty do
      IO.eprintln stderr
    if out.exitCode != 0 then
      throw <| IO.userError
        s!"Library-drift probe exited with code {out.exitCode} on: {", ".intercalate batch.toList}"
    for line in out.stdout.splitOn "\n" do
      if line.trimAscii.isEmpty then
        continue
      match parseProbeEvent line with
      | .ok event => events := events.push event
      | .error err =>
          throw <| IO.userError s!"Library-drift probe printed an unreadable line ({err}):\n{line}"
  return events

/-- Probe the requested manifest modules (all of them by default). Fails closed:
every requested module must appear in the probe's output. -/
def checkLibraryDrift (root : System.FilePath) (requestedModules : Array String := #[])
    (buildModules : Bool := true) : IO DriftReport := do
  let entries ← loadManifest root
  let modules ← selectManifestModules entries requestedModules
  let exemptions ← loadProbeExemptions root
  let problems := entries.map fun entry =>
    { problemId := entry.id, moduleName := entry.moduleName, holes := entry.holes }
  let events ← runLibraryDriftProbe root modules buildModules
  let (seen, holes) ←
    match collectHoleReports events with
    | .ok result => pure result
    | .error err => throw <| IO.userError s!"Library-drift probe output is inconsistent: {err}"
  let missing := modules.filter (!seen.contains ·)
  unless missing.isEmpty do
    throw <| IO.userError <|
      "Library-drift probe produced no report for module(s): "
        ++ ", ".intercalate missing.toList
  return { modules := seen, problems, holes, exemptions }

private def describeHole (report : DriftReport) (hole : HoleReport) : String :=
  let owners := report.problems.filterMap fun p =>
    if coversHole #[p] hole.module hole.decl then some p.problemId else none
  let problemText := match owners.toList with
    | [] => "no manifest entry"
    | [single] => s!"problem `{single}`"
    | many => s!"problems {", ".intercalate (many.map (s!"`{·}`"))}"
  s!"`{hole.decl}` ({problemText}, module `{hole.module}`)"

private def formatFinding (report : DriftReport) (finding : DriftFinding) : String :=
  let axioms := if finding.closure.axioms.isEmpty then "(none)"
    else ", ".intercalate finding.closure.axioms.toList
  let how := if finding.closure.vacuity then
    "has contradictory hypotheses" else "closes"
  String.intercalate "\n" [
    s!"Hole {describeHole report finding.hole} {how} at the pinned toolchain.",
    s!"  probe:  {finding.closure.probe}",
    s!"  proof:  {finding.closure.proof}",
    s!"  axioms: {axioms}"]

/-- Implementation of `lake exe lean-eval check-library-drift`. Prints one
summary line, every clean closure with its term and axioms, and returns 1 if
any non-exempt hole closed. -/
def runCheckLibraryDrift (root : System.FilePath)
    (requestedModules : Array String := #[]) : IO UInt32 := do
  try
    let report ← checkLibraryDrift root requestedModules
    let probed := report.holes.filter (·.isProp)
    let findings := driftFindings report
    let failing := failingFindings report
    let exempt := findings.size - failing.size
    let selfReferences := (probed.filter (·.selfReferenceOnly)).size
    let timeouts := probed.foldl (fun n hole => n + hole.timeouts.size) 0
    let errors := probed.foldl (fun n hole => n + hole.errors.size) 0
    IO.println <|
      s!"Probed {probed.size} Prop-valued hole(s) in {report.modules.size} module(s): " ++
      s!"{findings.size} closed ({exempt} exempt), {selfReferences} where library search " ++
      s!"reached only a hole, {timeouts} probe timeout(s), {errors} probe error(s)."
    for finding in findings do
      if finding.exempt then
        IO.println <|
          s!"Exempt hole {describeHole report finding.hole} closed by " ++
          s!"`{finding.closure.probe}`, as expected."
    for hole in staleExemptions report do
      IO.println <|
        s!"Exempt hole {describeHole report hole} did not close; the exemption may be stale."
    if failing.isEmpty then
      IO.println "No non-exempt hole closed."
      return (0 : UInt32)
    (← IO.getStdout).flush
    for finding in failing do
      IO.eprintln (formatFinding report finding)
    IO.eprintln <|
      s!"Library drift check failed: {failing.size} hole(s) closed. A hole that is meant to " ++
      "close, such as an anti-vacuity guard, belongs in `probe_exempt` in its manifest; " ++
      "any other closure means the problem is now a library lookup and needs a maintainer decision."
    return (1 : UInt32)
  catch err =>
    IO.eprintln err
    return (1 : UInt32)

end EvalTools
