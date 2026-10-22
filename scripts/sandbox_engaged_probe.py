#!/usr/bin/env python3
"""Check host isolation and private writable build/temp directories through lake test."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import tempfile

from security_probes.common import assert_exit, compare, require_tools, workspace


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-tools", action="store_true")
    args = parser.parse_args()
    if not require_tools(args.require_tools):
        return
    with tempfile.TemporaryDirectory(prefix="sandbox-probe-") as tmp:
        base = Path(tmp)
        outside = base / "outside"
        outside.mkdir()
        marker = outside / "marker"
        marker.write_text("host-only")
        private_path = base / "private-tmp"
        submission = r'''import Lean
initialize do
  IO.FS.createDirAll ".lake/probe"
  let mut lines : List String := []
  for (label, path) in [("source", "source-marker"), ("symlink", ".lake/escape/changed"),
                        ("build", ".lake/probe/inside"), ("home", "/tmp/home/private")] do
    try
      IO.FS.writeFile path "probe"
      lines := lines ++ [label ++ "=allowed"]
    catch _ =>
      lines := lines ++ [label ++ "=denied"]
  try
    let _ ← IO.FS.readFile HOST_MARKER
    lines := lines ++ ["host=visible"]
  catch _ =>
    lines := lines ++ ["host=hidden"]
  IO.FS.createDirAll PRIVATE_PATH
  IO.FS.writeFile (System.FilePath.mk PRIVATE_PATH / "marker") "private"
  let routes ← IO.FS.readFile "/proc/net/route"
  IO.FS.writeFile ".lake/probe/routes" routes
  IO.FS.writeFile ".lake/probe/results" ("\n".intercalate lines)
namespace Submission
theorem target : True := True.intro
end Submission
'''.replace("HOST_MARKER", json.dumps(str(marker))).replace(
            "PRIVATE_PATH", json.dumps(str(private_path))
        )
        project = workspace(base / "workspace", submission)
        (project / ".lake").mkdir()
        (project / ".lake/escape").symlink_to(outside)
        assert_exit(compare(project))
        outcomes = (project / ".lake/probe/results").read_text().splitlines()
        expected = {"source=denied", "symlink=denied", "build=allowed",
                    "home=allowed", "host=hidden"}
        if set(outcomes) != expected:
            raise AssertionError(outcomes)
        assert marker.read_text() == "host-only"
        assert not (outside / "changed").exists()
        assert not private_path.exists(), "sandbox temporary write reached the host"
        assert not (project / "source-marker").exists()
        assert len((project / ".lake/probe/routes").read_text().splitlines()) == 1
    print("PASS: host writes/read access and network isolated; private build/temp writes work")


if __name__ == "__main__":
    main()
