import Lean

open Lean

/-- Invoke comparator on this workspace with the external nanoda kernel disabled.

Nanoda remains integrated and pinned, but is temporarily disabled globally for
submission performance. This harness overrides `enable_nanoda := false` rather
than relying on each workspace's committed `config.json`. Comparator still
checks the exports and replays the solution through Lean's default kernel. Flip
the boolean below back to `true` to restore independent-kernel replay. -/
def main : IO UInt32 := do
  let comparatorBin := (← IO.getEnv "COMPARATOR_BIN").getD "comparator"
  try
    let configText ← IO.FS.readFile "config.json"
    let config ← IO.ofExcept (Json.parse configText)
    let config := config.setObjVal! "enable_nanoda" (Json.bool false)
    IO.FS.withTempFile fun handle enforcedPath => do
      handle.putStr config.pretty
      handle.flush
      let child ← IO.Process.spawn {
        cmd := "lake"
        args := #["env", comparatorBin, enforcedPath.toString]
      }
      child.wait
  catch err =>
    IO.eprintln s!"Failed to run comparator via `{comparatorBin}`."
    IO.eprintln "Make sure `comparator` is installed and on your `PATH`, or set `COMPARATOR_BIN=/path/to/comparator`."
    IO.eprintln "See the root repository README for comparator setup details, including landrun and lean4export. `nanoda_bin` is additionally required when nanoda is enabled."
    IO.eprintln s!"Original error: {err}"
    pure 1
