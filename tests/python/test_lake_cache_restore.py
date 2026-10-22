"""Exercise real Lake artifact restoration; opt in with LEAN_EVAL_LAKE_CACHE_TEST=1."""
from __future__ import annotations

import http.server
import json
import os
import pathlib
import shutil
import subprocess
import tempfile
import threading
import unittest


WRAPPER = pathlib.Path(__file__).resolve().parents[2] / "scripts/lake_cache_curl.py"


@unittest.skipUnless(os.environ.get("LEAN_EVAL_LAKE_CACHE_TEST") == "1",
                     "requires the pinned Lean toolchain")
class LakeCacheRestoreTests(unittest.TestCase):
    def test_failed_download_can_be_retried_without_compilation_or_poisoned_cache(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            cache = root / "cache"
            (root / "lakefile.toml").write_text(
                'name = "cache-probe"\ndefaultTargets = ["CacheProbe"]\n'
                '[[lean_lib]]\nname = "CacheProbe"\n'
            )
            (root / "CacheProbe.lean").write_text("def cacheProbe : Nat := 42\n")
            (root / "UseCacheProbe.lean").write_text(
                "import CacheProbe\nexample : cacheProbe = 42 := rfl\n"
            )
            payloads = {}
            requests = []
            healthy = False

            class Handler(http.server.BaseHTTPRequestHandler):
                def do_GET(self):
                    requests.append(self.path)
                    body = payloads.get(self.path.rsplit("/", 1)[-1].removesuffix(".art"))
                    if body is None:
                        self.send_error(404)
                        return
                    self.send_response(200)
                    self.send_header("Content-Length", str(len(body)))
                    self.end_headers()
                    self.wfile.write(body if healthy else body[:max(1, len(body) // 2)])
                    self.wfile.flush()
                    self.close_connection = True

                def log_message(self, *_args):
                    pass

            with http.server.ThreadingHTTPServer(("127.0.0.1", 0), Handler) as server:
                config = root / "cache.toml"
                endpoint = f"http://127.0.0.1:{server.server_port}"
                config.write_text(
                    'cache.defaultService = "probe"\n[[cache.service]]\n'
                    'name = "probe"\nkind = "s3"\n'
                    f'artifactEndpoint = "{endpoint}"\nrevisionEndpoint = "{endpoint}"\n'
                )
                env = dict(os.environ, LAKE_CONFIG=str(config), LAKE_CACHE_DIR=str(cache),
                           LAKE_ARTIFACT_CACHE="true", LAKE_RESTORE_ARTIFACTS="true",
                           CURL=str(WRAPPER))

                def lake(*args):
                    return subprocess.run(["lake", *args], cwd=root, env=env, check=False,
                                          capture_output=True, text=True, timeout=60)

                built = lake("build")
                self.assertEqual(built.returncode, 0, built.stdout + built.stderr)
                artifacts = cache / "artifacts"
                self.assertTrue(list(artifacts.glob("*.olean")))
                payloads.update({p.stem: p.read_bytes() for p in artifacts.iterdir()})
                # Remote mappings imported by `lake cache get --mappings-only`
                # bind their service and scope; locally produced mappings do not.
                for path in (cache / "outputs/cache-probe").glob("*.json"):
                    mapping = json.loads(path.read_text())
                    mapping.update(service="probe", scope="probe")
                    path.write_text(json.dumps(mapping))
                shutil.rmtree(artifacts)
                artifacts.mkdir()
                shutil.rmtree(root / ".lake/build")
                thread = threading.Thread(target=server.serve_forever, daemon=True)
                thread.start()
                try:
                    failed = lake("-v", "--no-build", "build")
                    self.assertNotEqual(failed.returncode, 0)
                    self.assertIn("curl", failed.stdout + failed.stderr)
                    self.assertTrue(requests)
                    self.assertFalse((root / ".lake/build/lib/lean/CacheProbe.olean").exists())
                    self.assertEqual(list(artifacts.iterdir()), [])
                    healthy = True
                    restored = lake("-v", "--no-build", "build")
                    self.assertEqual(restored.returncode, 0, restored.stdout + restored.stderr)
                    self.assertNotIn("Built CacheProbe", restored.stdout + restored.stderr)
                    checked = lake("env", "lean", "UseCacheProbe.lean")
                    self.assertEqual(checked.returncode, 0, checked.stdout + checked.stderr)
                finally:
                    server.shutdown()
                    thread.join()


if __name__ == "__main__":
    unittest.main()
