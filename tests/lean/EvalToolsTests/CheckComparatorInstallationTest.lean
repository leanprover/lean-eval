import EvalTools.CheckComparatorInstallation

open EvalTools

set_option autoImplicit false

private def assertEq {α : Type} [BEq α] [Repr α] (label : String)
    (actual expected : α) : Option String :=
  if actual == expected then none
  else some s!"{label}: expected {repr expected}, got {repr actual}"

private def assertContains (label : String) (haystack needle : String) :
    Option String :=
  if (haystack.find? needle).isSome then none
  else some s!"{label}: expected substring {repr needle} in {repr haystack}"

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

def main : IO UInt32 := do
  let passes ← IO.mkRef 0
  let fails ← IO.mkRef 0


  check "solveTwoPlusTwo replaces only the first placeholder" passes fails do
    let tmp ← IO.FS.createTempDir
    let submission := tmp / "Submission.lean"
    let body :=
      "namespace Submission\n\n" ++
      "theorem two_plus_two_eq_four : (2 : Nat) + 2 = 4 := by\n" ++
      "  sorry\n\n" ++
      "end Submission\n"
    IO.FS.writeFile submission body
    solveTwoPlusTwo tmp
    let result ← IO.FS.readFile submission
    IO.FS.removeDirAll tmp
    pure <| assertContains "has norm_num" result "  norm_num\n" |>.or
      (assertEq "has no sorry" (result.find? "  sorry\n").isNone true)

  let passCount ← passes.get
  let failCount ← fails.get
  IO.println s!"\n{passCount} passed, {failCount} failed."
  return if failCount == 0 then 0 else 1
