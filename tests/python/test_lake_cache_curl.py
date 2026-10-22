from __future__ import annotations

import contextlib
import http.server
import pathlib
import shutil
import subprocess
import tempfile
import threading
import unittest


WRAPPER = pathlib.Path(__file__).resolve().parents[2] / "scripts/lake_cache_curl.py"


@unittest.skipUnless(shutil.which("curl"), "curl is required")
class LakeCacheCurlTests(unittest.TestCase):
    def setUp(self) -> None:
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = pathlib.Path(directory.name)
        self.destination = self.root / "artifact.olean"

    @contextlib.contextmanager
    def server(self, responses: list[tuple[int, bytes, bool]]):
        destination = self.destination
        observations = []

        class Handler(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                observations.append(destination.read_bytes() if destination.exists() else None)
                status, body, partial = responses[min(len(observations) - 1, len(responses) - 1)]
                self.send_response(status)
                self.send_header("Content-Length", str(len(body) * (2 if partial else 1)))
                self.end_headers()
                self.wfile.write(body)
                self.wfile.flush()
                self.close_connection = True

            def log_message(self, *_args):
                pass

        with http.server.ThreadingHTTPServer(("127.0.0.1", 0), Handler) as server:
            thread = threading.Thread(target=server.serve_forever, daemon=True)
            thread.start()
            try:
                yield f"http://127.0.0.1:{server.server_port}/artifact", observations
            finally:
                server.shutdown()
                thread.join()

    def run_download(self, url):
        return subprocess.run(
            [str(WRAPPER), "-s", "-S", "-f", "-o", str(self.destination), "-L", url],
            capture_output=True, text=True, check=False, timeout=30,
        )

    def test_recovers_from_http_and_partial_transfer_errors_atomically(self) -> None:
        self.destination.write_bytes(b"previous complete artifact")
        with self.server([(503, b"unavailable", False), (200, b"partial", True),
                          (200, b"complete artifact", False)]) as (url, observations):
            result = self.run_download(url)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(observations), 3)
        self.assertEqual(observations, [b"previous complete artifact"] * 3)
        self.assertEqual(self.destination.read_bytes(), b"complete artifact")
        self.assertEqual(list(self.root.glob("*.download")), [])

    def test_exhausted_partial_downloads_leave_no_cached_artifact(self) -> None:
        with self.server([(200, b"interrupted transfer", True)]) as (url, observations):
            result = self.run_download(url)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(len(observations), 4)
        self.assertEqual(observations, [None] * 4)
        self.assertFalse(self.destination.exists())
        self.assertEqual(list(self.root.iterdir()), [])

    def test_other_curl_requests_preserve_stdout_and_status(self) -> None:
        with self.server([(200, b"metadata", False)]) as (url, _):
            result = subprocess.run([str(WRAPPER), "-fsS", url],
                                    capture_output=True, check=False, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, b"metadata")
        self.assertFalse(self.destination.exists())


if __name__ == "__main__":
    unittest.main()
