#!/bin/bash
cd "$(dirname "$0")"
xattr -cr . 2>/dev/null || true
DIR="$(pwd)/Matter Tracker.app/Contents/Resources"
if [ ! -f "$DIR/app.py" ]; then
  DIR="$(pwd)/Contents/Resources"
fi
PY="$(command -v python3 || echo /usr/bin/python3)"
if ! "$PY" -c 'import http.server' >/dev/null 2>&1; then
  osascript -e 'display alert "Python 3 needed" message "Open Terminal and run:\n\nxcode-select --install\n\nThen run this again."'
  exit 1
fi
"$PY" "$DIR/app.py" --serve >/dev/null 2>&1 &
for i in $(seq 1 40); do
  curl -s -o /dev/null --max-time 1 http://127.0.0.1:8765/api/health && break
  sleep 0.2
done
open http://127.0.0.1:8765/
