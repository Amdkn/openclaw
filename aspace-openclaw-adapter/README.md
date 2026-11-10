# Adapter A'Space — openclaw

**Amont :** `openclaw/openclaw`, MIT, gel `ce7788f` (version 2026.11.2).
**Adresse :** `fiber:a0:openclaw` (manifeste V5, domicile FKB00).
**Seul code A'Space du fork** — le code amont est byte-identique au gel (H-M2).

## Surface (contrat seul)

Sous-commandes qui parlent seulement, via le launcher `node openclaw.mjs` :

- `--version` — `OpenClaw 2026.11.2 (ce7788f)` (launcher seul, sans build)
- `--help` — aide complète (exige le build `dist/entry.js`)
- `telemetry show` — aperçu local de la requête quotidienne, sans envoi

## Jamais

- Lancer la gateway (`openclaw gateway`, `onboard`) ou toute session agent
- Appel modèle, appel réseau hors npm/pnpm (install/build)
- Envoi télémétrie : `DO_NOT_TRACK=1` et `CI=1` forcés ; statistiques OFF par
  défaut (opt-in explicite) — voir `openclaw-TELEMETRY-AUDIT.md`

## Smoke test

```sh
bash aspace-openclaw-adapter/smoke_test.sh            # après pnpm install && pnpm build
bash aspace-openclaw-adapter/smoke_test.sh --netproof # + namespace sans interface réseau
```

## Clone partiel

Le repo amont fait ~13,3 Go : clone partiel obligatoire (`--filter=blob:none
--depth 1`) et sparse checkout (`package.json`, `pnpm-workspace.yaml`,
`src/cli`, `src/config`, `src/infra`, `packages`, `scripts`, `test`,
README, LICENSE). Le checkout complet est interdit.
