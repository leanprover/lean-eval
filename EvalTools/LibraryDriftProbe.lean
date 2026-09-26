import Lean
import EvalTools.Markers

/-!
# Library-drift probe

Executable root for `lake exe eval_library_drift`, the worker behind
`lake exe lean-eval check-library-drift`.

A catalog problem is meant to stay open until somebody proves it. A Mathlib
bump can quietly close one: the statement is unchanged, but the pinned library
now contains the lemma, and the hole becomes a one-line lookup. Nothing else in
CI notices, because the problem module still builds and its `sorry` warning is
expected.

For every Prop-valued `@[eval_problem]` hole in the given modules, this
executable states a fresh goal with the hole's exact type and attacks it with a
fixed tactic battery under a heartbeat cap, then with the same battery after
`exfalso` (contradictory hypotheses), then with library search. A probe counts
as closing the hole only if

* the kernel accepts the resulting term through `addDecl`;
* its axioms, computed while treating definition holes as opaque leaves, lie in
  `{propext, Classical.choice, Quot.sound}`; and
* the term mentions no Prop-valued `@[eval_problem]` hole, of any declaration
  kind. The sorried hole has exactly the goal's type, so it is always the first
  candidate library search finds, and a Prop-valued instance hole proving
  itself is no more a proof than a theorem hole is. Data holes (a `def` of a
  number or a type) may appear in a term, since the statement itself mentions
  them; only their axioms are hidden.

Output is one JSON object per line on stdout: a `module` line per module, a
`hole` line per tagged declaration, and a `probe` line per tactic run. Probing
of a hole stops at its first clean closure. The command-line wrapper applies
the manifest's `probe_exempt` policy and decides the exit code; this executable
only reports.

Usage: `lake env .lake/build/bin/eval_library_drift <Module.Name> ...`
-/

open Lean Meta Elab Tactic
open LeanEvalGenerator.Core

namespace EvalTools

set_option autoImplicit false

/-- One tactic in the battery. -/
structure ProbeSpec where
  name : String
  tactic : String
  /-- Heartbeat cap for this probe, in the units of the `maxHeartbeats` option
  (thousands of raw heartbeats; the option's default is 200000). -/
  heartbeats : Nat
  /-- `true` when the tactic runs after `exfalso`, so success means the
  hypotheses are contradictory rather than the conclusion trivial. -/
  vacuity : Bool := false

/-- The fixed battery, cheapest first. Library search runs last and is handled
separately because the stock `exact?` returns the sorried hole itself. -/
def probeBattery : Array ProbeSpec := #[
  ⟨"rfl", "(intros; rfl)", 100000, false⟩,
  ⟨"trivial", "(intros; trivial)", 100000, false⟩,
  ⟨"decide", "(intros; decide)", 100000, false⟩,
  ⟨"simp", "(intros; simp)", 200000, false⟩,
  ⟨"simp_all", "(intros; simp_all)", 200000, false⟩,
  ⟨"norm_num", "(intros; norm_num)", 200000, false⟩,
  ⟨"omega", "(intros; omega)", 100000, false⟩,
  ⟨"positivity", "(intros; positivity)", 100000, false⟩,
  ⟨"linarith", "(intros; linarith)", 200000, false⟩,
  ⟨"aesop", "(intros; aesop)", 300000, false⟩,
  ⟨"grind", "(intros; grind)", 300000, false⟩,
  ⟨"contradiction", "(intros; contradiction)", 100000, false⟩,
  ⟨"vac_simp_all", "(intros; exfalso; simp_all)", 200000, true⟩,
  ⟨"vac_omega", "(intros; exfalso; omega)", 100000, true⟩,
  ⟨"vac_linarith", "(intros; exfalso; linarith)", 200000, true⟩,
  ⟨"vac_norm_num", "(intros; exfalso; norm_num at *)", 200000, true⟩,
  ⟨"vac_decide", "(intros; exfalso; decide)", 100000, true⟩,
  ⟨"vac_aesop", "(intros; exfalso; aesop)", 300000, true⟩,
  ⟨"vac_grind", "(intros; exfalso; grind)", 300000, true⟩
]

/-- Name of the library-search probe in the output. -/
def librarySearchProbeName : String := "library_search"

/-- Heartbeat cap for library search, in the units of the `maxHeartbeats` option. -/
def librarySearchHeartbeats : Nat := 400000

/-- Axioms a closing term may use. -/
def standardAxioms : Array Name := #[``propext, ``Classical.choice, ``Quot.sound]

/-- Axioms reachable from `root`, not descending into constants satisfying
`skip` (definition holes, whose bodies are `sorry` by construction). -/
partial def collectAxiomsSkipping (env : Environment) (skip : Name → Bool) (root : Name) :
    Array Name := Id.run do
  let mut visited : NameSet := {}
  let mut out : Array Name := #[]
  let mut stack : List Name := [root]
  while true do
    match stack with
    | [] => break
    | c :: rest =>
      stack := rest
      if visited.contains c then continue
      visited := visited.insert c
      match env.find? c with
      | none => continue
      | some info =>
        if info matches .axiomInfo _ then
          out := out.push c
        if c != root && skip c then continue
        let mut cs : Array Name := #[]
        for n in info.type.getUsedConstants do cs := cs.push n
        if let some v := info.value? then
          for n in v.getUsedConstants do cs := cs.push n
        for n in cs do
          if !visited.contains n then stack := n :: stack
  return out

/-- A tagged declaration of one module. -/
structure HoleInfo where
  decl : Name
  /-- `"theorem"`, `"def"`, or `"instance"`, as in the problem inventory. -/
  kind : String
  isProp : Bool

/-- The `@[eval_problem]` declarations of `moduleName`, sorted by name. -/
def holesOfModule (env : Environment) (moduleName : Name) : MetaM (Array HoleInfo) := do
  match env.getModuleIdx? moduleName with
  | none => return #[]
  | some idx =>
    let mut out := #[]
    for (declName, info) in env.constants do
      if env.getModuleIdxFor? declName == some idx && hasEvalProblemTag env declName then
        let kind := match info with
          | .thmInfo _ | .opaqueInfo _ => "theorem"
          | .defnInfo _ => if isInstanceCore env declName then "instance" else "def"
          | _ => "other"
        let isProp ← Meta.isProp info.type
        out := out.push ⟨declName, kind, isProp⟩
    return out.qsort (fun a b => Name.lt a.decl b.decl)

private def emit (fields : List (String × Json)) : IO Unit :=
  IO.println (Json.mkObj fields).compress

/-- Outcome of one probe: the outcome label and, on success, the proof term. -/
abbrev ProbeResult := String × Option Expr

/-- Run `act` under a heartbeat cap. An ordinary tactic failure is the
`failed` outcome; a heartbeat exception is `timeout`; any other runtime
exception (recursion depth, interrupt) is `error`. The cap is installed on the
context directly because the option is read only when a context is created. -/
private def underHeartbeats (heartbeats : Nat) (act : TermElabM ProbeResult) :
    TermElabM ProbeResult := do
  let now ← IO.getNumHeartbeats
  let guarded : TermElabM ProbeResult :=
    withTheReader Core.Context
      (fun c => { c with
        maxHeartbeats := heartbeats * 1000
        initHeartbeats := now }) do
      try act catch e =>
        let msg ← e.toMessageData.toString
        pure (s!"failed: {(msg.take 200).toString}", none)
  tryCatchRuntimeEx guarded fun e => do
    let msg ← e.toMessageData.toString
    if msg.contains "heartbeats" then pure ("timeout", none)
    else pure (s!"error: {(msg.take 200).toString}", none)

/-- Run one tactic string on a fresh goal of type `ty`. -/
def runProbe (ty : Expr) (spec : ProbeSpec) : TermElabM ProbeResult := do
  let env ← getEnv
  let stx ← match Parser.runParserCategory env `tactic spec.tactic with
    | .ok s => pure s
    | .error e => return (s!"parse_error: {e}", none)
  let mvar ← mkFreshExprMVar ty
  underHeartbeats spec.heartbeats do
    let remaining ← Tactic.run mvar.mvarId! (evalTactic stx)
    unless remaining.isEmpty do return ("failed_goals_remain", none)
    let pf ← instantiateMVars mvar
    if pf.hasMVar || pf.hasSorry then return ("failed_open_or_sorry", none)
    return ("closed", some pf)

/-- Library search in collect-all mode, keeping the first complete solution
whose proof term references none of `holeNames`. This is `exact?` minus the
self-reference: the sorried hole has exactly the goal's type and would
otherwise always be the first candidate. -/
def runLibrarySearch (ty : Expr) (holeNames : NameSet) : TermElabM ProbeResult := do
  let mvar ← mkFreshExprMVar ty
  underHeartbeats librarySearchHeartbeats do
    let (_, g) ← mvar.mvarId!.intros
    let res ← g.withContext do
      LibrarySearch.librarySearch g (collectAll := true)
    match res with
    | none =>
      let pf ← instantiateMVars mvar
      if pf.hasMVar || pf.hasSorry then return ("failed_open_or_sorry", none)
      if pf.getUsedConstants.any holeNames.contains then return ("self_reference_only", none)
      return ("closed", some pf)
    | some sols =>
      let mut sawSelf := false
      for (goals, mctx) in sols do
        unless goals.isEmpty do continue
        setMCtx mctx
        let pf ← instantiateMVars mvar
        if pf.hasMVar || pf.hasSorry then continue
        if pf.getUsedConstants.any holeNames.contains then
          sawSelf := true
          continue
        return ("closed", some pf)
      return (if sawSelf then "self_reference_only" else "failed_goals_remain", none)

/-- Names of the Prop-valued holes: any term mentioning one of these is a
self-reference, whatever the hole's declaration kind. -/
private def propHoleNames (holes : Array HoleInfo) : NameSet :=
  holes.foldl (fun s x => if x.isProp then s.insert x.decl else s) {}

/-- Kernel-check a closing term and report it. Returns `true` when the closure
is clean, in which case the caller stops probing the hole. The environment is
restored afterwards so that the checked declaration cannot be found by a later
probe of the same hole. -/
private def reportClosure (holes : Array HoleInfo) (h : HoleInfo) (spec : ProbeSpec)
    (levelParams : List Name) (ty pf : Expr) : TermElabM Bool := do
  let isDefHole (n : Name) : Bool := holes.any fun x => x.decl == n && x.kind != "theorem"
  let probeName := h.decl ++ Name.mkSimple s!"probe_{spec.name}"
  let holeReferences := (pf.getUsedConstants.filter (propHoleNames holes).contains).map toString
  let env ← getEnv
  let mut kernel := "unchecked"
  let mut axioms : Array String := #[]
  try
    addDecl (.thmDecl { name := probeName, levelParams, type := ty, value := pf })
    kernel := "kernel_ok"
    axioms := (collectAxiomsSkipping (← getEnv) isDefHole probeName).map toString
  catch e =>
    let m ← e.toMessageData.toString
    kernel := s!"kernel_error: {(m.take 200).toString}"
  setEnv env
  let proof := ((← Meta.ppExpr pf).pretty.take 2000).toString
  let clean := kernel == "kernel_ok" && holeReferences.isEmpty &&
    axioms.all fun a => standardAxioms.any fun s => s.toString == a
  emit [("event", "probe"), ("decl", toString h.decl), ("probe", spec.name),
        ("vacuity", spec.vacuity), ("outcome", "closed"), ("kernel", kernel),
        ("axioms", toJson axioms), ("holeReferences", toJson holeReferences),
        ("clean", clean), ("proof", proof)]
  return clean

/-- Report a hole and, if it is Prop-valued, run the battery against it. -/
def probeHole (moduleName : Name) (holes : Array HoleInfo) (h : HoleInfo) : TermElabM Unit := do
  let some info := (← getEnv).find? h.decl
    | throwError "hole `{h.decl}` vanished from the environment"
  let ty := info.type
  let tyStr := (← Meta.ppExpr ty).pretty
  emit [("event", "hole"), ("module", toString moduleName), ("decl", toString h.decl),
        ("kind", h.kind), ("isProp", h.isProp), ("type", tyStr)]
  -- Prop-valued definition and instance holes are theorems in disguise: comparator
  -- checks only their type, so any proof of that type is accepted.
  unless h.isProp do return
  let holeNames := propHoleNames holes
  let specs := probeBattery.push
    ⟨librarySearchProbeName, "<librarySearch collectAll>", librarySearchHeartbeats, false⟩
  for spec in specs do
    let (outcome, pf?) ←
      if spec.name == librarySearchProbeName then runLibrarySearch ty holeNames
      else runProbe ty spec
    match pf? with
    | none =>
      emit [("event", "probe"), ("decl", toString h.decl), ("probe", spec.name),
            ("vacuity", spec.vacuity), ("outcome", outcome)]
    | some pf =>
      if ← reportClosure holes h spec info.levelParams ty pf then
        break

/-- Probe every hole of `moduleName` in a fresh `CoreM` context over `env`. -/
def probeModule (env : Environment) (moduleName : Name) : IO Unit := do
  let opts : Options := ({} : Options).insert `linter.all (.ofBool false)
  let coreCtx : Core.Context := {
    fileName := "<eval_library_drift>"
    -- Positional tactic errors need a file map with somewhere to point.
    fileMap := FileMap.ofString (String.ofList (List.replicate 512 ' '))
    maxHeartbeats := 0
    maxRecDepth := 8192
    options := opts.insert `maxRecDepth (.ofNat 8192) }
  let act : MetaM Unit := do
    let holes ← holesOfModule (← getEnv) moduleName
    emit [("event", "module"), ("module", toString moduleName), ("holes", holes.size)]
    for h in holes do
      (probeHole moduleName holes h).run'
  let _ ← (act.run' {} {}).toIO coreCtx { env }

end EvalTools

/-- Import the requested modules once and probe each. Tactics live in the
imported environment, so extensions must be loaded and initializers enabled. -/
unsafe def main (args : List String) : IO UInt32 := do
  if args.isEmpty then
    IO.eprintln "eval_library_drift expects at least one module name."
    return 1
  initSearchPath (← findSysroot)
  enableInitializersExecution
  let moduleNames := args.map LeanEvalGenerator.Core.parseModuleName
  -- Trust level 1024 is the `lean` command line's default; the kernel still
  -- checks every term this executable adds.
  let env ← Lean.importModules
    (moduleNames.toArray.map fun m => ({ module := m } : Lean.Import)) {}
    (trustLevel := 1024) (loadExts := true)
  let mut failed := false
  for moduleName in moduleNames do
    try
      EvalTools.probeModule env moduleName
    catch e =>
      IO.eprintln s!"eval_library_drift failed on {moduleName}: {e}"
      failed := true
  return if failed then 1 else 0
