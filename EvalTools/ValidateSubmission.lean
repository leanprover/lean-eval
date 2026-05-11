import Lean
import EvalTools.Manifest
import EvalTools.Subprocess

open Lean

namespace EvalTools

set_option autoImplicit false

/-- Mirrors the git change record from `git diff --name-status -z`. For
copies (`C`) and renames (`R`), `paths` is a two-element array `[old, new]`;
for the remaining statuses it is a single-element array. -/
structure SubmissionChange where
  status : String
  paths : Array String
  deriving Inhabited

namespace SubmissionChange

def toJson (change : SubmissionChange) : Json :=
  Json.mkObj [
    ("status", change.status),
    ("paths", Json.arr (change.paths.map (Json.str ·)))
  ]

end SubmissionChange

/-- Verdict for a forbidden change: the status + paths plus the human-readable
reasons it was rejected. -/
structure ForbiddenChange where
  status : String
  paths : Array String
  reasons : Array String
  deriving Inhabited

namespace ForbiddenChange

def toJson (entry : ForbiddenChange) : Json :=
  Json.mkObj [
    ("status", entry.status),
    ("paths", Json.arr (entry.paths.map (Json.str ·))),
    ("reasons", Json.arr (entry.reasons.map (Json.str ·)))
  ]

end ForbiddenChange

/-- The five whitelist rules from `scripts/validate_submission.py`. Each rule
matches a normalized POSIX path against a predicate and yields the set of
allowed git statuses for matched paths. -/
private def matchesSolutionLean (parts : List String) : Bool :=
  match parts with
  | ["generated", _, "Solution.lean"] => true
  | _ => false

private def matchesSubmissionLean (parts : List String) : Bool :=
  match parts with
  | ["generated", _, "Submission.lean"] => true
  | _ => false

/-- `generated/<id>/Submission/.+\.lean` -/
private def matchesSubmissionSubtreeLean (parts : List String) : Bool :=
  match parts with
  | "generated" :: _ :: "Submission" :: rest =>
      match rest.getLast? with
      | some last => last.endsWith ".lean" && rest.length ≥ 1
      | none => false
  | _ => false

/-- `generated/<id>/(?!README\.md$).+\.md` — anywhere under
`generated/<id>/`, but not a top-level `README.md`. -/
private def matchesMarkdown (parts : List String) : Bool :=
  match parts with
  | "generated" :: _ :: rest =>
      match rest.getLast? with
      | some last =>
          if last.endsWith ".md" then
            !(rest.length == 1 && last == "README.md")
          else false
      | none => false
  | _ => false

private def matchesLicence (parts : List String) : Bool :=
  match parts with
  | ["generated", _, "LICENCE"] | ["generated", _, "LICENSE"] => true
  | _ => false

private def applyPatternRules (normalized : String) : Std.HashSet String := Id.run do
  let parts := normalized.splitOn "/"
  let mut allowed : Std.HashSet String := {}
  if matchesSolutionLean parts then
    allowed := allowed.insert "M"
  if matchesSubmissionLean parts then
    allowed := allowed.insert "M"
  if matchesSubmissionSubtreeLean parts then
    allowed := allowed.insert "A"
    allowed := allowed.insert "C"
    allowed := allowed.insert "D"
    allowed := allowed.insert "M"
    allowed := allowed.insert "R"
  if matchesMarkdown parts then
    allowed := allowed.insert "A"
  if matchesLicence parts then
    allowed := allowed.insert "A"
  return allowed

def allAllowedStatuses : Std.HashSet String :=
  (["A", "C", "D", "M", "R"] : List String).foldl (·.insert ·) {}

/-- Reject paths the Python script would reject in `normalize_submission_path`:
absolute paths, paths containing `..`, paths with empty components from a
leading/trailing/duplicate `/`, and the bare repo root. -/
def normalizeSubmissionPath (path : String) : Except String String := do
  if path.startsWith "/" then
    throw s!"Submission path must be relative to the repo root: {path}"
  let parts := path.splitOn "/"
  if parts.any (fun p => p == ".." || p.isEmpty) then
    throw s!"Submission path is not a clean relative repo path: {path}"
  let normalized := "/".intercalate parts
  if normalized == "." then
    throw "Submission path cannot be the repository root."
  return normalized

/-- Returns `none` when the path is acceptable for the given status, otherwise
the rejection reason (text-equivalent to the Python original). -/
private def pathPolicyError
    (normalized : String) (statusCode : String) (validProblemIds : Std.HashSet String) :
    Option String := Id.run do
  let matching := applyPatternRules normalized
  if matching.isEmpty then
    return some "path is outside the submission whitelist"
  let parts := normalized.splitOn "/"
  let problemId? := parts.toArray[1]?
  match problemId? with
  | none => return some "path does not belong to a known generated problem workspace"
  | some problemId =>
    if parts.length < 3 || !validProblemIds.contains problemId then
      return some "path does not belong to a known generated problem workspace"
  if !matching.contains statusCode then
    let sorted := matching.toArray.qsort (· < ·)
    let asList := "[" ++ String.intercalate ", " (sorted.toList.map (s!"'{·}'")) ++ "]"
    return some s!"change status '{statusCode}' is not allowed for this path; allowed: {asList}"
  return none

/-- Validate a list of git changes against the submission whitelist. Returns
the allowed changes (with normalized paths) and the forbidden changes (each
carrying one or more rejection reasons). -/
def validateChangedFiles
    (root : System.FilePath) (changes : Array SubmissionChange) :
    IO (Array SubmissionChange × Array ForbiddenChange) := do
  let entries ← loadManifest root
  let validIds : Std.HashSet String := entries.foldl (fun acc e => acc.insert e.id) {}
  let mut allowed : Array SubmissionChange := #[]
  let mut forbidden : Array ForbiddenChange := #[]
  for change in changes do
    let statusCode := (change.status.take 1).toString
    let mut reasons : Array String := #[]
    let mut normalizedPaths : Array String := #[]
    for path in change.paths do
      match normalizeSubmissionPath path with
      | .error err =>
          reasons := reasons.push err
          normalizedPaths := normalizedPaths.push path
      | .ok normalized =>
          normalizedPaths := normalizedPaths.push normalized
          match pathPolicyError normalized statusCode validIds with
          | some reason => reasons := reasons.push s!"{normalized}: {reason}"
          | none => pure ()
    unless allAllowedStatuses.contains statusCode do
      reasons := reasons.push s!"unsupported git change status '{change.status}'"
    if reasons.isEmpty then
      allowed := allowed.push { status := change.status, paths := normalizedPaths }
    else
      forbidden := forbidden.push
        { status := change.status, paths := normalizedPaths, reasons := reasons }
  return (allowed, forbidden)

/-- Parse the NUL-separated stdout of `git diff --name-status -z`. -/
def parseNameStatus (output : String) : Except String (Array SubmissionChange) := do
  let fields := (output.splitOn "\x00").filter (! ·.isEmpty) |>.toArray
  let mut changes : Array SubmissionChange := #[]
  let mut idx := 0
  while idx < fields.size do
    let status := fields[idx]!
    idx := idx + 1
    if status.isEmpty then continue
    let statusCode := (status.take 1).toString
    let pathCount := if statusCode == "R" || statusCode == "C" then 2 else 1
    if idx + pathCount > fields.size then
      throw s!"Malformed git diff --name-status output near status '{status}'"
    let paths := (fields.extract idx (idx + pathCount))
    idx := idx + pathCount
    changes := changes.push { status := status, paths := paths }
  return changes

/-- Resolve change set via `git diff --find-renames --find-copies --name-status -z`. -/
def changedFilesFromGit
    (root : System.FilePath) (baseRef headRef : String) :
    IO (Array SubmissionChange) := do
  let out ← runCmdCheckedCaptured "git"
    #["diff", "--find-renames", "--find-copies", "--name-status", "-z",
      s!"{baseRef}..{headRef}"]
    root "git diff failed"
  match parseNameStatus out.stdout with
  | .ok changes => pure changes
  | .error err => throw <| IO.userError err

/-- Turn `--file path1 --file path2` arguments into synthetic `M`-status
changes (modifications), mirroring `parse_explicit_file_changes`. -/
def parseExplicitFileChanges (files : Array String) : Array SubmissionChange :=
  files.map fun f => { status := "M", paths := #[f] }

private def flattenTouchedPaths (changes : Array SubmissionChange) : Array String :=
  changes.foldl (fun acc c => acc ++ c.paths) #[]

/-- Implementation of `lake exe lean-eval validate-submission`. -/
def runValidateSubmission
    (root : System.FilePath) (base? head? : Option String) (files : Array String)
    (emitJson : Bool) : IO UInt32 := do
  try
    let changes ← if !files.isEmpty then
        pure (parseExplicitFileChanges files)
      else match base?, head? with
        | some base, some head => changedFilesFromGit root base head
        | _, _ =>
            throw (IO.userError
              "Provide either --base/--head or one or more --file arguments.")
    let (allowed, forbidden) ← validateChangedFiles root changes
    let status : UInt32 := if forbidden.isEmpty then 0 else 1
    if emitJson then
      let payload := Json.mkObj [
        ("status", if status == 0 then "ok" else "forbidden_changes"),
        ("changes", Json.arr (changes.map SubmissionChange.toJson)),
        ("changed_files",
          Json.arr ((flattenTouchedPaths changes).map (Json.str ·))),
        ("allowed_changes", Json.arr (allowed.map SubmissionChange.toJson)),
        ("allowed_files",
          Json.arr ((flattenTouchedPaths allowed).map (Json.str ·))),
        ("forbidden_changes", Json.arr (forbidden.map ForbiddenChange.toJson)),
        ("forbidden_files",
          Json.arr ((forbidden.foldl (fun acc f => acc ++ f.paths) #[]).map (Json.str ·)))
      ]
      IO.println payload.pretty
    else
      if !forbidden.isEmpty then
        IO.eprintln "Forbidden submission changes detected:"
        for entry in forbidden do
          IO.eprintln s!"{entry.status} {" -> ".intercalate entry.paths.toList}"
          for reason in entry.reasons do
            IO.eprintln s!"  - {reason}"
      else
        IO.println "Submission changes are limited to participant-owned files."
    return status
  catch err =>
    if emitJson then
      let payload := Json.mkObj [
        ("status", "error"),
        ("message", toString err)
      ]
      IO.println payload.pretty
    else
      IO.eprintln err
    return 1

end EvalTools
