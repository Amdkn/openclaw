#!/usr/bin/env bash
# Smoke test de l'adapter A'Space pour openclaw (contrat seul).
# Sous-commandes qui parlent seulement, maison scratch, télémétrie coupée
# (DO_NOT_TRACK=1, CI=1). Aucun envoi. stdin fermé : le CLI attend sinon
# une entrée interactive et ne termine jamais (vérifié).
# Mode built si dist/entry.js existe, sinon mode sources via tsx
# (même mécanisme que les scripts amont : node --import ./scripts/tsx.mjs).
# La preuve réseau (namespace sans interface) est le mode --netproof.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$HERE")"
if [ -f "$ROOT/dist/entry.js" ] || [ -f "$ROOT/dist/entry.mjs" ]; then
  RUN=(node "$ROOT/openclaw.mjs")
  MODE="built"
else
  RUN=(node --import ./scripts/tsx.mjs src/entry.ts)
  MODE="sources"
fi
[ -f "$ROOT/openclaw.mjs" ] || { echo "openclaw.mjs absent"; exit 1; }
SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT
export HOME="$SCRATCH/home" DO_NOT_TRACK=1 CI=1
mkdir -p "$HOME"
if [ "${1:-}" = "--netproof" ]; then
  RUN=(unshare -n "${RUN[@]}")
fi
cd "$ROOT"
VERSION="$("${RUN[@]}" --version < /dev/null)"
echo "$VERSION" | grep -q "OpenClaw 2026.11.2"
"${RUN[@]}" --help < /dev/null >/dev/null
"${RUN[@]}" telemetry show < /dev/null | grep -q "Feature stats: disabled"
echo "smoke openclaw OK (mode $MODE, $VERSION, --help, telemetry show disabled)"
