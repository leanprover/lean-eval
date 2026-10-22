import EvalTools.StartProblem
import EvalTools.Subprocess

namespace EvalTools

open LeanEvalGenerator.Core

set_option autoImplicit false


/-- Replace the first `  sorry\n` in `Submission.lean` with `  norm_num\n`.
This is the maintainer-controlled "happy-path" solution for the
`two_plus_two` workspace. -/
def solveTwoPlusTwo (workspace : System.FilePath) : IO Unit := do
  let submissionPath := workspace / "Submission.lean"
  let content ← IO.FS.readFile submissionPath
  let placeholder := "  sorry\n"
  let parts := content.splitOn placeholder
  if parts.length < 2 then
    throw <| IO.userError s!"Expected a placeholder proof in {submissionPath}"
  -- Replace only the first occurrence, matching Python's
  -- `content.replace("  sorry\n", "  norm_num\n", 1)`.
  let head := parts.head!
  let rest := placeholder.intercalate parts.tail!
  IO.FS.writeFile submissionPath s!"{head}  norm_num\n{rest}"

/-- Run an end-to-end comparator check against the `two_plus_two` workspace. -/
def runCheckComparatorInstallation (root : System.FilePath) : IO UInt32 := do
  try
    let source := root / "generated" / "two_plus_two"
    unless ← source.isDir do
      IO.eprintln s!"Missing generated workspace: {source}"
      return (1 : UInt32)
    let tmp ← IO.FS.createTempDir
    let workspace := tmp / "two_plus_two"
    copyTree source workspace
    solveTwoPlusTwo workspace
    runCmdCheckedInherit "lake" #["update"] workspace "lake update failed"
    runCmdCheckedInherit "lake" #["exe", "cache", "get"] workspace "lake exe cache get failed"
    runCmdCheckedInherit "lake" #["test"] workspace "lake test failed"
    IO.FS.removeDirAll tmp
    IO.println "Comparator check passed."
    return (0 : UInt32)
  catch err =>
    IO.eprintln err
    return (1 : UInt32)

end EvalTools
