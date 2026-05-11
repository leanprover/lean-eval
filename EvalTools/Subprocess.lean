import Lean

open Lean

namespace EvalTools

set_option autoImplicit false

/-- Outcome of running a captured subprocess. -/
structure ProcessOutput where
  exitCode : UInt32
  stdout : String
  stderr : String

/-- Run a process to completion in `cwd`, capturing stdout and stderr. -/
def runCmdCaptured (cmd : String) (args : Array String) (cwd : System.FilePath) :
    IO ProcessOutput := do
  let out ← IO.Process.output {
    cmd := cmd
    args := args
    cwd := cwd
  }
  return { exitCode := out.exitCode, stdout := out.stdout, stderr := out.stderr }

/-- Run a process and throw an `IO.userError` if it exits non-zero. The error
message is `errorPrefix` followed by the captured stderr+stdout (whichever is
non-empty), matching `scripts/generate_projects.py`'s `run(...)` helper. -/
def runCmdCheckedCaptured
    (cmd : String) (args : Array String) (cwd : System.FilePath) (errorPrefix : String) :
    IO ProcessOutput := do
  let out ← runCmdCaptured cmd args cwd
  if out.exitCode != 0 then
    let stderr := out.stderr.trimAscii.toString
    let stdout := out.stdout.trimAscii.toString
    let details := [stderr, stdout].filter (! ·.isEmpty) |> String.intercalate "\n"
    if details.isEmpty then
      throw <| IO.userError errorPrefix
    else
      throw <| IO.userError s!"{errorPrefix}:\n{details}"
  return out

/-- Run a process inheriting stdout/stderr/stdin streams, and throw an
`IO.userError` if it exits non-zero. -/
def runCmdCheckedInherit
    (cmd : String) (args : Array String) (cwd : System.FilePath) (errorPrefix : String) :
    IO Unit := do
  let child ← IO.Process.spawn {
    cmd := cmd
    args := args
    cwd := cwd
    stdin := .inherit
    stdout := .inherit
    stderr := .inherit
  }
  let exit ← child.wait
  if exit != 0 then
    throw <| IO.userError s!"{errorPrefix} (exit code {exit})."

end EvalTools
