#!/usr/bin/env bash
set -euo pipefail
/usr/bin/time -p bash -c 'cd "$(dirname "$0")" && pwd'
cd "$(dirname "$0")"
/usr/bin/time -p pwd
if [[ -z "${CAPTURE_URL:-}" ]]; then
  echo "CAPTURE_URL is required." >&2
  exit 1
fi
if [[ -z "${CAPTURE_DIR:-}" ]]; then
  echo "CAPTURE_DIR is required." >&2
  exit 1
fi
/usr/bin/time -p bash -c 'echo "capturing $0 -> $1"' "$CAPTURE_URL" "$CAPTURE_DIR"
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
set +e
/usr/bin/time -p node "${RUNTIME_DIR:?}/scripts/default-capture.mjs"
status=$?
set -e
/usr/bin/time -p ls -la "$CAPTURE_DIR"
if [[ $status -ne 0 ]]; then
  exit "$status"
fi
if ! /usr/bin/time -p test -f "${CAPTURE_DIR}/final-desktop.png"; then
  echo "Missing ${CAPTURE_DIR}/final-desktop.png" >&2
  exit 1
fi
if ! /usr/bin/time -p test -f "${CAPTURE_DIR}/final-mobile.png"; then
  echo "Missing ${CAPTURE_DIR}/final-mobile.png" >&2
  exit 1
fi
