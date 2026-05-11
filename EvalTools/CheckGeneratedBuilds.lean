import Cli
import Std.Data.HashSet

open Cli Std

namespace EvalTools

set_option autoImplicit false

structure GeneratedWorkspace where
  name : String
  path : System.FilePath

/-- List subdirectories of `generated/` that look like Lake workspaces (i.e.
contain a `lakefile.toml`), sorted by directory name to match the Python
script's `sorted(...)` traversal. -/
def generatedWorkspaces (root : System.FilePath) : IO (Array GeneratedWorkspace) := do
  let generatedRoot := root / "generated"
  if !(← generatedRoot.isDir) then
    return #[]
  let entries ← generatedRoot.readDir
  let mut workspaces : Array GeneratedWorkspace := #[]
  for entry in entries.qsort (fun a b => a.fileName < b.fileName) do
    if !(← entry.path.isDir) then continue
    let lakefile := entry.path / "lakefile.toml"
    -- Match Python's `(path / "lakefile.toml").is_file()`: regular file, not
    -- a directory named `lakefile.toml`.
    let isFile ← (do
      let info ← lakefile.metadata
      return info.type == .file) <|> pure false
    unless isFile do continue
    workspaces := workspaces.push { name := entry.fileName, path := entry.path }
  return workspaces

/-- Implementation of `lake exe lean-eval check-generated-builds`: run
`lake build` in each generated workspace and fail if any returns a non-zero
exit code. -/
def runCheckGeneratedBuilds (root : System.FilePath) (selected : Array String) :
    IO UInt32 := do
  let allWorkspaces ← generatedWorkspaces root
  let workspaces ←
    if selected.isEmpty then
      pure allWorkspaces
    else
      let selectedSet : HashSet String := selected.foldl (·.insert ·) {}
      let availableNames : HashSet String :=
        allWorkspaces.foldl (fun acc ws => acc.insert ws.name) {}
      -- De-duplicate the user-supplied list (Python used `set(args.problem)`)
      -- before reporting unknowns, so passing `--problem foo --problem foo`
      -- emits one error line, not two.
      let missing := (selectedSet.toArray.filter (!availableNames.contains ·)).qsort (· < ·)
      if !missing.isEmpty then
        for name in missing do
          IO.eprintln s!"Unknown generated workspace: {name}"
        return 1
      pure <| allWorkspaces.filter fun ws => selectedSet.contains ws.name
  if workspaces.isEmpty then
    IO.eprintln "No generated workspaces found."
    return 1
  for workspace in workspaces do
    IO.println s!"==> Building generated workspace `{workspace.name}`"
    let child ← IO.Process.spawn {
      cmd := "lake"
      args := #["build"]
      cwd := workspace.path
      stdin := .inherit
      stdout := .inherit
      stderr := .inherit
    }
    let exit ← child.wait
    if exit != 0 then
      IO.eprintln s!"Command failed with exit code {exit}: lake build"
      return 1
  IO.println s!"Built {workspaces.size} generated workspace(s)."
  return 0

end EvalTools
