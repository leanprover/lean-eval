import Lean

open Lean

/-- Compare canonical paths on directory boundaries. -/
private def withinWorkspace (roots : Array System.FilePath) (path : System.FilePath) : Bool :=
  roots.any fun root => path == root ||
    path.toString.startsWith (root.toString ++ System.FilePath.pathSeparator.toString)

/-- Drop workspace/cache search directories, including relative paths and symlink aliases.
Nonexistent directories are omitted rather than allowing a build to create them later. -/
private def trustedSearchPath (roots : Array System.FilePath) (value : String) : IO String := do
  let mut dirs : System.SearchPath := []
  for dir in System.SearchPath.parse value do
    if dir.toString.isEmpty then continue
    try
      let dir ← IO.FS.realPath dir
      if !(withinWorkspace roots dir) && (← dir.isDir) then
        dirs := dirs ++ [dir]
    catch _ => pure ()
  return dirs.toString

/-- Resolve a tool using only the trusted search path, and reject workspace overrides. -/
private def trustedTool (roots : Array System.FilePath)
    (env : Array (String × Option String)) (envName fallback : String) :
    IO String := do
  let tool := (← IO.getEnv envName).getD fallback
  let result ← IO.Process.output {
    cmd := "which"
    args := #["--", tool]
    env
  }
  if result.exitCode != 0 then
    throw <| IO.userError s!"Cannot find trusted tool for {envName}: {tool}"
  let resolved ← IO.FS.realPath result.stdout.trimAscii.toString
  if withinWorkspace roots resolved then
    throw <| IO.userError s!"{envName} must point outside the evaluation workspace and its writable cache: {resolved}"
  return resolved.toString

/-- Experimental trusted entrypoint for the toolchain Lake comparator. -/
def main : IO UInt32 := do
  let comparatorBin := "lake comparator"
  try
    let workspace ← IO.FS.realPath (← IO.currentDir)
    let roots := #[workspace, ← IO.FS.realPath (workspace / ".lake")]
    let path ← trustedSearchPath roots ((← IO.getEnv "PATH").getD "")
    if path.isEmpty then
      throw <| IO.userError "No trusted executable search directories remain"
    let mut env := #[("PATH", some path)]
    for envName in #["LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"] do
      if let some value ← IO.getEnv envName then
        let value ← trustedSearchPath roots value
        env := env.push (envName, if value.isEmpty then none else some value)
    let comparator ← trustedTool roots env "COMPARATOR_LAKE" "lake"
    let bwrap ← trustedTool roots env "COMPARATOR_BWRAP" "bwrap"
    let toolchainBin := (System.FilePath.mk comparator).parent.getD (System.FilePath.mk ".")
    let nanoda ← trustedTool roots env "LEAN_EVAL_NANODA" (toolchainBin / "nanoda_bin").toString
    env := env.push ("COMPARATOR_BWRAP", some bwrap)
    let configText ← IO.FS.readFile "config.json"
    let config ← IO.ofExcept (Json.parse configText)
    let config := config.setObjVal! "enable_nanoda" (Json.bool false)
    let config := config.setObjVal! "external_kernels"
      (Json.mkObj [("nanoda", Json.arr #[Json.str nanoda])])
    IO.FS.withTempFile fun handle enforcedPath => do
      handle.putStr config.pretty
      handle.flush
      let child ← IO.Process.spawn {
        cmd := comparator
        args := #["comparator", "--config", enforcedPath.toString]
        env
      }
      child.wait
  catch err =>
    IO.eprintln s!"Failed to run comparator via `{comparatorBin}`."
    IO.eprintln "Install the pinned Lean toolchain and bubblewrap outside this workspace."
    IO.eprintln "This is an experimental Lake comparator harness."
    IO.eprintln s!"Original error: {err}"
    pure 1
