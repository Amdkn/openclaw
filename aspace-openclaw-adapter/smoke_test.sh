#!/usr/bin/env bash
# Smoke test de l'adapter A'Space pour openclaw (contrat seul).
# Sous-commandes qui parlent seulement, maison scratch, télémétrie coupée
# (DO_NOT_TRACK=1, CI=1). Aucun envoi. --help et telemetry show exigent le
# build (dist/entry.js) : pnpm install && pnpm build d'abord.
# La preuve réseau (namespace sans interface) est le mode --netproof.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$HERE")"
BIN="$ROOT/openclaw.mjs"
[ -f "$BIN" ] || { echo "openclaw.mjs absent"; exit 1; }
[ -f "$ROOT/dist/entry.js" ] || [ -f "$ROOT/dist/entry.mjs" ] || { echo "build absent : pnpm install && pnpm build d'abord"; exit 1; }
SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT
export HOME="$SCRATCH/home" DO_NOT_TRACK=1 CI=1
mkdir -p "$HOME"
RUN=(node "$BIN")
if [ "${1:-}" = "--netproof" ]; then
  RUN=(unshare -n node "$BIN")
fi
"${RUN[@]}" --version | grep -q "OpenClaw 2026.11.2 (ce7788f)"
"${RUN[@]}" --help >/dev/null
"${RUN[@]}" telemetry show | grep -q "Feature stats: disabled"
echo "smoke openclaw OK (version 2026.11.2 ce7788f, --help, telemetry show disabled)"
