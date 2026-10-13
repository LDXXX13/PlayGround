#!/usr/bin/env bash
set -euo pipefail
/usr/bin/time -p bash -c 'cd "$(dirname "$0")" && pwd'
cd "$(dirname "$0")"
/usr/bin/time -p pwd
PROJECT_ROOT="$(pwd)"
/usr/bin/time -p bash -c 'echo "project root: $0"' "$PROJECT_ROOT"
PORT="${PORT:-3000}"
/usr/bin/time -p bash -c 'echo "PORT=$0"' "$PORT"
BUILD_DIR="${PROJECT_ROOT}/dist"
/usr/bin/time -p mkdir -p "$BUILD_DIR"
if /usr/bin/time -p test -f "${PROJECT_ROOT}/package.json"; then
  /usr/bin/time -p npm install --no-audit --no-fund --prefix "$PROJECT_ROOT"
  if /usr/bin/time -p node -e "process.exit(JSON.parse(require('fs').readFileSync('${PROJECT_ROOT}/package.json','utf8')).scripts?.build?0:1)"; then
    /usr/bin/time -p npm run --prefix "$PROJECT_ROOT" build
  fi
fi
if ! /usr/bin/time -p test -f "${BUILD_DIR}/index.html"; then
  echo "Static deployment output must contain index.html at ${BUILD_DIR}/index.html" >&2
  exit 1
fi
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p "$WEB_DIR"
/usr/bin/time -p node -e "require('fs').writeFileSync(process.argv[1], JSON.stringify({project: process.argv[2], directory: process.argv[3]}))" "${WEB_DIR}/deployment-output.json" "$PROJECT_ROOT" "$BUILD_DIR"
/usr/bin/time -p cat "${WEB_DIR}/deployment-output.json"
/usr/bin/time -p python3 --version
exec /usr/bin/time -p python3 -m http.server "$PORT" --directory "$BUILD_DIR" --bind 0.0.0.0
