import EvalTools.RepoRoot
import EvalTools.ValidateSubmission

open EvalTools

set_option autoImplicit false

/-- Run a single test case. `f` returns `none` on success, `some reason` on
failure. The returned action increments either `passes` or `fails` so the
caller can report a tally. -/
private def check (label : String) (passes fails : IO.Ref Nat)
    (f : IO (Option String)) : IO Unit := do
  match ← (f.toBaseIO) with
  | .ok none =>
      IO.println s!"PASS: {label}"
      passes.modify (· + 1)
  | .ok (some reason) =>
      IO.eprintln s!"FAIL: {label} — {reason}"
      fails.modify (· + 1)
  | .error err =>
      IO.eprintln s!"FAIL: {label} — unexpected exception: {err}"
      fails.modify (· + 1)

private def assertEq {α : Type} [BEq α] [Repr α] (label : String)
    (actual expected : α) : Option String :=
  if actual == expected then none
  else some s!"{label}: expected {repr expected}, got {repr actual}"

private def assertContains (label : String) (haystack needle : String) :
    Option String :=
  if (haystack.find? needle).isSome then none
  else some s!"{label}: expected substring {repr needle} in {repr haystack}"

private def runChecks (root : System.FilePath)
    (changes : Array SubmissionChange) :
    IO (Array SubmissionChange × Array ForbiddenChange) :=
  validateChangedFiles root changes

def main : IO UInt32 := do
  let root ← requireRepoRoot
  let passes ← IO.mkRef 0
  let fails ← IO.mkRef 0

  check "explicit submission paths are treated as modifications" passes fails do
    let changes := parseExplicitFileChanges
      #["generated/two_plus_two/Submission.lean",
        "generated/two_plus_two/Submission/Helpers.lean"]
    pure <| assertEq "changes.size" changes.size 2 |>.or
      (assertEq "changes[0].status" changes[0]!.status "M") |>.or
      (assertEq "changes[1].status" changes[1]!.status "M") |>.or
      (assertEq "changes[1].paths" changes[1]!.paths
        #["generated/two_plus_two/Submission/Helpers.lean"])

  check "top-level Solution.lean only allows modifications" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "D", paths := #["generated/two_plus_two/Solution.lean"] }]
    pure <| assertEq "allowed.size" allowed.size 0 |>.or
      (assertEq "forbidden.size" forbidden.size 1) |>.or
      (assertContains "reason"
        ((forbidden[0]!.reasons[0]?).getD "") "not allowed for this path")

  check "markdown file addition outside top-level README is allowed" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "A", paths := #["generated/two_plus_two/NOTES.md"] }]
    pure <| assertEq "forbidden.size" forbidden.size 0 |>.or
      (assertEq "allowed.size" allowed.size 1)

  check "markdown inside Submission/ subtree A is allowed" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "A", paths := #["generated/two_plus_two/Submission/notes.md"] }]
    pure <| assertEq "forbidden.size" forbidden.size 0 |>.or
      (assertEq "allowed.size" allowed.size 1)

  check "README.md modification is rejected" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "M", paths := #["generated/two_plus_two/README.md"] }]
    pure <| assertEq "allowed.size" allowed.size 0 |>.or
      (assertEq "forbidden.size" forbidden.size 1) |>.or
      (assertContains "reason"
        ((forbidden[0]!.reasons[0]?).getD "") "outside the submission whitelist")

  check "non-README markdown modification is rejected" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "M", paths := #["generated/two_plus_two/NOTES.md"] }]
    pure <| assertEq "allowed.size" allowed.size 0 |>.or
      (assertEq "forbidden.size" forbidden.size 1) |>.or
      (assertContains "reason"
        ((forbidden[0]!.reasons[0]?).getD "") "not allowed for this path")

  for filename in ["LICENCE", "LICENSE"] do
    check s!"{filename} addition is allowed" passes fails do
      let (allowed, forbidden) ← runChecks root
        #[{ status := "A", paths := #[s!"generated/two_plus_two/{filename}"] }]
      pure <| assertEq "forbidden.size" forbidden.size 0 |>.or
        (assertEq "allowed.size" allowed.size 1)

  check "LICENCE deletion is rejected" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "D", paths := #["generated/two_plus_two/LICENCE"] }]
    pure <| assertEq "allowed.size" allowed.size 0 |>.or
      (assertEq "forbidden.size" forbidden.size 1) |>.or
      (assertContains "reason"
        ((forbidden[0]!.reasons[0]?).getD "") "not allowed for this path")

  check "R100 within Submission/ subtree is allowed" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "R100",
          paths := #["generated/two_plus_two/Submission/Helpers.lean",
                     "generated/two_plus_two/Submission/ExtraHelpers.lean"] }]
    pure <| assertEq "forbidden.size" forbidden.size 0 |>.or
      (assertEq "allowed.size" allowed.size 1) |>.or
      (assertEq "paths.size" allowed[0]!.paths.size 2)

  check "rename into Challenge.lean is rejected" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "R100",
          paths := #["generated/two_plus_two/Submission/Helpers.lean",
                     "generated/two_plus_two/Challenge.lean"] }]
    pure <| assertEq "allowed.size" allowed.size 0 |>.or
      (assertEq "forbidden.size" forbidden.size 1) |>.or
      (assertContains "reason"
        (String.intercalate "\n" forbidden[0]!.reasons.toList)
        "outside the submission whitelist")

  check "unknown problem id is rejected" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "M", paths := #["generated/not_a_problem/Submission.lean"] }]
    pure <| assertEq "allowed.size" allowed.size 0 |>.or
      (assertEq "forbidden.size" forbidden.size 1) |>.or
      (assertContains "reason"
        ((forbidden[0]!.reasons[0]?).getD "") "known generated problem workspace")

  check "non-Lean Submission addition is rejected" passes fails do
    let (allowed, forbidden) ← runChecks root
      #[{ status := "A", paths := #["generated/two_plus_two/Submission/data.json"] }]
    pure <| assertEq "allowed.size" allowed.size 0 |>.or
      (assertEq "forbidden.size" forbidden.size 1) |>.or
      (assertContains "reason"
        ((forbidden[0]!.reasons[0]?).getD "") "outside the submission whitelist")

  check "absolute path rejected by normalizeSubmissionPath" passes fails do
    match normalizeSubmissionPath "/tmp/Submission.lean" with
    | .error err =>
        pure <| assertContains "error" err "relative to the repo root"
    | .ok _ => pure (some "expected normalizeSubmissionPath to fail on absolute path")

  check "traversal path rejected by normalizeSubmissionPath" passes fails do
    match normalizeSubmissionPath "../generated/two_plus_two/Submission.lean" with
    | .error err =>
        pure <| assertContains "error" err "clean relative repo path"
    | .ok _ => pure (some "expected normalizeSubmissionPath to fail on .. path")

  check "name-status parser handles rename records" passes fails do
    let payload :=
      "M\x00generated/two_plus_two/Submission.lean\x00" ++
      "R100\x00generated/two_plus_two/Submission/Helpers.lean\x00" ++
      "generated/two_plus_two/Submission/ExtraHelpers.lean\x00"
    match parseNameStatus payload with
    | .error err => pure (some s!"parser raised: {err}")
    | .ok changes =>
        pure <| assertEq "changes.size" changes.size 2 |>.or
          (assertEq "changes[0]" changes[0]!.status "M") |>.or
          (assertEq "changes[0].paths" changes[0]!.paths
            #["generated/two_plus_two/Submission.lean"]) |>.or
          (assertEq "changes[1]" changes[1]!.status "R100") |>.or
          (assertEq "changes[1].paths.size" changes[1]!.paths.size 2)

  let passCount ← passes.get
  let failCount ← fails.get
  IO.println s!"\n{passCount} passed, {failCount} failed."
  return if failCount == 0 then 0 else 1
