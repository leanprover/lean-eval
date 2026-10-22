import EvalTools.CheckLibraryDrift
import EvalTools.RepoRoot

open EvalTools
open LeanEvalGenerator.Core

set_option autoImplicit false

private def assertEq {α : Type} [BEq α] [Repr α] (label : String)
    (actual expected : α) : Option String :=
  if actual == expected then none
  else some s!"{label}: expected {repr expected}, got {repr actual}"

private def assertContains (label haystack needle : String) : Option String :=
  if (haystack.find? needle).isSome then none
  else some s!"{label}: expected to contain {repr needle}, got {repr haystack}"

private def check (label : String) (passes fails : IO.Ref Nat)
    (f : IO (Option String)) : IO Unit := do
  match ← f.toBaseIO with
  | .ok none => IO.println s!"PASS: {label}"; passes.modify (· + 1)
  | .ok (some reason) =>
      IO.eprintln s!"FAIL: {label} — {reason}"
      fails.modify (· + 1)
  | .error err =>
      IO.eprintln s!"FAIL: {label} — unexpected exception: {err}"
      fails.modify (· + 1)

private def expectErrorContaining (action : IO Unit) (needle : String) :
    IO (Option String) := do
  match ← action.toBaseIO with
  | .ok _ => pure <| some s!"expected failure containing {repr needle}"
  | .error err => pure <| assertContains "error" (toString err) needle

private def moduleLine (name : String) (holes : Nat) : String :=
  s!"\{\"event\": \"module\", \"module\": \"{name}\", \"holes\": {holes}}"

private def holeLine (moduleName decl : String) (isProp : Bool := true) : String :=
  s!"\{\"event\": \"hole\", \"module\": \"{moduleName}\", \"decl\": \"{decl}\", " ++
  s!"\"kind\": \"theorem\", \"isProp\": {isProp}, \"type\": \"True\"}"

private def attemptLine (decl probe outcome : String) : String :=
  s!"\{\"event\": \"probe\", \"decl\": \"{decl}\", \"probe\": \"{probe}\", " ++
  s!"\"vacuity\": false, \"outcome\": \"{outcome}\"}"

private def closedLine (decl probe : String) (clean : Bool)
    (holeReferences : String := "[]") : String :=
  s!"\{\"event\": \"probe\", \"decl\": \"{decl}\", \"probe\": \"{probe}\", " ++
  "\"vacuity\": false, \"outcome\": \"closed\", \"kernel\": \"kernel_ok\", " ++
  s!"\"axioms\": [\"propext\"], \"holeReferences\": {holeReferences}, " ++
  s!"\"clean\": {clean}, \"proof\": \"rfl\"}"

private def assertParsed (label line : String) (expected : ProbeEvent) : Option String :=
  match parseProbeEvent line with
  | .ok event => assertEq label event expected
  | .error err => some s!"{label}: parse failed: {err}"

private def parseAll (lines : List String) : Except String (Array ProbeEvent) :=
  lines.foldlM (fun acc line => do return acc.push (← parseProbeEvent line)) #[]

private def manifestEntry (id moduleName : String) (holes : List String)
    (probeExempt? : Option (List String) := none) : String :=
  let quote (s : String) := s!"\"{s}\""
  s!"id = \"{id}\"\n" ++
  s!"title = \"{id}\"\n" ++
  "group = \"formalization-evaluation\"\n" ++
  "status = \"draft\"\n" ++
  "visible = true\n" ++
  "statement_revision = 1\n" ++
  "tags = []\n" ++
  s!"module = \"{moduleName}\"\n" ++
  s!"holes = [{", ".intercalate (holes.map quote)}]\n" ++
  "submitter = \"tester\"\n" ++
  (match probeExempt? with
    | some names => s!"probe_exempt = [{", ".intercalate (names.map quote)}]\n"
    | none => "")

/-- A repository root holding only the given manifest files. -/
private def withManifests (files : Array (String × String))
    (f : System.FilePath → IO (Option String)) : IO (Option String) := do
  let root ← IO.FS.createTempDir
  try
    let manifestDir := root / "manifests" / "problems"
    IO.FS.createDirAll manifestDir
    for (name, contents) in files do
      IO.FS.writeFile (manifestDir / name) contents
    f root
  finally
    try IO.FS.removeDirAll root catch _ => pure ()

private def exemption (problemId moduleName : String) (holes : List String) :
    ManifestHoles :=
  { problemId, moduleName, holes := holes.toArray }

private def fakeReport (holes : Array HoleReport) (exemptions : Array ManifestHoles) :
    DriftReport :=
  { modules := #["LeanEval.Demo"], problems := #[], holes, exemptions }

private def closure (probe : String) (clean : Bool := true) : ProbeClosure :=
  { probe, vacuity := false, kernel := "kernel_ok", axioms := #[], holeReferences := #[],
    clean, proof := "rfl" }

/-- The catalog's hidden test problems. Their holes close by design, which
makes them the positive control for the check. -/
private def controlModules : Array String := #[
  "LeanEval.EasyProblems",
  "LeanEval.Sandbox.DefHoleExample",
  "LeanEval.Sandbox.InstanceHoleExample",
  "LeanEval.Sandbox.MultiHoleHelpersExample",
  "LeanEval.Sandbox.NoncomputableHoleExample",
  "LeanEval.Sandbox.VariableBinderExample"]

/-- Holes of the control modules that must close. -/
private def controlClosures : Array String := #[
  "Helpers.second_eq",
  "Helpers.third_eq",
  "LeanEval.Sandbox.variable_binder_example",
  "LeanEval.ci_regenerate_main_check",
  "LeanEval.list_append_singleton_length",
  "LeanEval.two_plus_two_eq_four"]

def main : IO UInt32 := do
  let passes ← IO.mkRef 0
  let fails ← IO.mkRef 0

  check "parseProbeEvent reads a module line" passes fails do
    pure <| assertParsed "event" (moduleLine "LeanEval.Demo" 2) (.module "LeanEval.Demo" 2)

  check "parseProbeEvent reads a closed probe with its closure" passes fails do
    let expected : ProbeClosure :=
      { probe := "rfl", vacuity := false, kernel := "kernel_ok", axioms := #["propext"],
        holeReferences := #[], clean := true, proof := "rfl" }
    pure <| assertParsed "event" (closedLine "Demo.hole" "rfl" true) (.closed "Demo.hole" expected)

  check "parseProbeEvent reads a failed probe as an attempt" passes fails do
    pure <| assertParsed "event" (attemptLine "Demo.hole" "simp" "timeout")
      (.attempt "Demo.hole" "simp" "timeout")

  check "parseProbeEvent rejects an unknown event kind" passes fails do
    match parseProbeEvent "{\"event\": \"banner\"}" with
    | .ok event => pure <| some s!"unexpectedly parsed {repr event}"
    | .error err => pure <| assertContains "error" err "unknown probe event kind"

  check "parseProbeEvent rejects a closed probe missing its kernel verdict" passes fails do
    let line := "{\"event\": \"probe\", \"decl\": \"Demo.hole\", \"probe\": \"rfl\", " ++
      "\"vacuity\": false, \"outcome\": \"closed\"}"
    match parseProbeEvent line with
    | .ok event => pure <| some s!"unexpectedly parsed {repr event}"
    | .error _ => pure none

  check "collectHoleReports groups probes by hole" passes fails do
    let events ← IO.ofExcept <| parseAll [
      moduleLine "LeanEval.Demo" 2,
      holeLine "LeanEval.Demo" "Demo.open",
      holeLine "LeanEval.Demo" "Demo.shut",
      attemptLine "Demo.open" "rfl" "failed_goals_remain",
      attemptLine "Demo.open" "aesop" "timeout",
      attemptLine "Demo.open" "library_search" "self_reference_only",
      closedLine "Demo.shut" "library_search" false "[\"Demo.shut\"]",
      closedLine "Demo.shut" "rfl" true]
    let (modules, holes) ← IO.ofExcept (collectHoleReports events)
    let openHole := holes[0]!
    let shutHole := holes[1]!
    pure <| assertEq "modules" modules #["LeanEval.Demo"]
      |>.or (assertEq "hole count" holes.size 2)
      |>.or (assertEq "open timeouts" openHole.timeouts #["aesop"])
      |>.or (assertEq "open self-reference" openHole.selfReferenceOnly true)
      |>.or (assertEq "open closure" openHole.cleanClosure?.isNone true)
      |>.or (assertEq "shut closures" shutHole.closures.size 2)
      |>.or (assertEq "shut clean closure"
        (shutHole.cleanClosure?.map (·.probe)) (some "rfl"))

  check "collectHoleReports records probe errors" passes fails do
    let events ← IO.ofExcept <| parseAll [
      moduleLine "LeanEval.Demo" 1,
      holeLine "LeanEval.Demo" "Demo.hole",
      attemptLine "Demo.hole" "norm_num" "parse_error: unknown tactic"]
    let (_, holes) ← IO.ofExcept (collectHoleReports events)
    pure <| assertEq "errors" holes[0]!.errors #["norm_num: parse_error: unknown tactic"]

  check "collectHoleReports rejects a probe for an unknown hole" passes fails do
    let events ← IO.ofExcept <| parseAll [
      moduleLine "LeanEval.Demo" 0,
      closedLine "Demo.ghost" "rfl" true]
    match collectHoleReports events with
    | .ok _ => pure <| some "unexpectedly accepted a probe without a hole"
    | .error err => pure <| assertContains "error" err "before introducing it"

  check "isExemptHole matches by full name and by last component" passes fails do
    let exemptions := #[exemption "demo" "LeanEval.Demo" ["Helpers.guard", "plain"]]
    pure <| assertEq "full name" (isExemptHole exemptions "LeanEval.Demo" "Helpers.guard") true
      |>.or (assertEq "last component"
        (isExemptHole exemptions "LeanEval.Demo" "LeanEval.Demo.plain") true)
      |>.or (assertEq "other module"
        (isExemptHole exemptions "LeanEval.Other" "Helpers.guard") false)
      |>.or (assertEq "other hole"
        (isExemptHole exemptions "LeanEval.Demo" "Helpers.other") false)

  check "failingFindings applies exemptions unless told not to" passes fails do
    let guard : HoleReport :=
      { module := "LeanEval.Demo", decl := "Demo.guard", kind := "theorem", isProp := true,
        type := "True", closures := #[closure "trivial"] }
    let drifted : HoleReport :=
      { module := "LeanEval.Demo", decl := "Demo.drifted", kind := "theorem", isProp := true,
        type := "True", closures := #[closure "aesop" false, closure "library_search"] }
    let stale : HoleReport :=
      { module := "LeanEval.Demo", decl := "Demo.stale", kind := "theorem", isProp := true,
        type := "True" }
    let report := fakeReport #[guard, drifted, stale]
      #[exemption "demo" "LeanEval.Demo" ["guard", "stale"]]
    let names (findings : Array DriftFinding) := findings.map (·.hole.decl)
    pure <| assertEq "all closures" (names (driftFindings report)) #["Demo.guard", "Demo.drifted"]
      |>.or (assertEq "failing" (names (failingFindings report)) #["Demo.drifted"])
      |>.or (assertEq "failing probe"
        ((failingFindings report).map (·.closure.probe)) #["library_search"])
      |>.or (assertEq "failing without exemptions"
        (names (failingFindings report (applyExemptions := false)))
        #["Demo.guard", "Demo.drifted"])
      |>.or (assertEq "stale" ((staleExemptions report).map (·.decl)) #["Demo.stale"])

  check "loadProbeExemptions reads probe_exempt and skips entries without it" passes fails do
    withManifests #[
        ("alpha.toml", manifestEntry "alpha" "LeanEval.Alpha" ["alpha"]),
        ("beta.toml", manifestEntry "beta" "LeanEval.Beta" ["one", "Beta.two"]
          (some ["Beta.two"]))] fun root => do
      let exemptions ← loadProbeExemptions root
      pure <| assertEq "exemptions" exemptions
        #[exemption "beta" "LeanEval.Beta" ["Beta.two"]]

  check "loadProbeExemptions rejects a name absent from holes" passes fails do
    withManifests #[
        ("beta.toml", manifestEntry "beta" "LeanEval.Beta" ["one"] (some ["two"]))]
      fun root =>
        expectErrorContaining (discard <| loadProbeExemptions root)
          "lists `two` in `probe_exempt` but not in `holes`"

  check "loadProbeExemptions rejects an empty name" passes fails do
    withManifests #[
        ("beta.toml", manifestEntry "beta" "LeanEval.Beta" ["one"] (some [""]))]
      fun root =>
        expectErrorContaining (discard <| loadProbeExemptions root)
          "empty string in `probe_exempt`"

  check "chunkArray keeps order and fills batches" passes fails do
    pure <| assertEq "chunks" (chunkArray #[1, 2, 3, 4, 5] 2) #[#[1, 2], #[3, 4], #[5]]
      |>.or (assertEq "empty" (chunkArray (#[] : Array Nat) 3) #[])
      |>.or (assertEq "zero size" (chunkArray #[1, 2] 0) #[#[1], #[2]])

  -- Positive control: the catalog's own hidden test problems close by design.
  -- The check must report every one of them, must fail on them when their
  -- exemptions are ignored, and must pass once the manifests' `probe_exempt`
  -- entries apply. This runs the real probe, so it builds the control modules.
  let root ← requireRepoRoot
  let control ← (checkLibraryDrift root controlModules).toBaseIO

  check "control run reports every requested module" passes fails do
    let report ← IO.ofExcept control
    pure <| assertEq "modules" (report.modules.qsort (· < ·)) (controlModules.qsort (· < ·))

  check "control holes close and fail the check when not exempt" passes fails do
    let report ← IO.ofExcept control
    let closed := (failingFindings report (applyExemptions := false)).map (·.hole.decl)
    pure <| assertEq "closed holes" (closed.qsort (· < ·)) controlClosures

  check "control closures are kernel-checked with standard axioms" passes fails do
    let report ← IO.ofExcept control
    let bad := (driftFindings report).filter fun finding =>
      finding.closure.kernel != "kernel_ok" || !finding.closure.holeReferences.isEmpty
    pure <| assertEq "unclean closures" (bad.map (·.hole.decl)) #[]

  check "control run passes once the manifest exemptions apply" passes fails do
    let report ← IO.ofExcept control
    pure <| assertEq "failing" ((failingFindings report).map (·.hole.decl)) #[]
      |>.or (assertEq "stale exemptions" ((staleExemptions report).map (·.decl)) #[])

  check "a theorem about a def hole reports only a self-reference" passes fails do
    let report ← IO.ofExcept control
    let some fooDef := report.holes.find? (·.decl == "foo_def")
      | pure (some "foo_def was not reported")
    pure <| assertEq "closure" fooDef.cleanClosure?.isNone true
      |>.or (assertEq "self-reference" fooDef.selfReferenceOnly true)

  check "definition and instance holes are listed but not probed" passes fails do
    let report ← IO.ofExcept control
    let some foo := report.holes.find? (·.decl == "foo")
      | pure (some "foo was not reported")
    let some widget := report.holes.find? (·.decl == "instInhabitedWidget")
      | pure (some "instInhabitedWidget was not reported")
    pure <| assertEq "foo kind" foo.kind "def"
      |>.or (assertEq "foo probed" foo.isProp false)
      |>.or (assertEq "instance kind" widget.kind "instance")
      |>.or (assertEq "instance probed" widget.isProp false)

  let passCount ← passes.get
  let failCount ← fails.get
  IO.println s!"\n{passCount} passed, {failCount} failed."
  return if failCount == 0 then 0 else 1
