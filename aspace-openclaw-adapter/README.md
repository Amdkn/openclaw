# Adapter A'Space — openclaw

**Amont :** `openclaw/openclaw`, MIT, gel `ce7788f` (version 2026.11.2).
**Adresse :** `fiber:a0:openclaw` (manifeste V5, domicile FKB00).
**Seul code A'Space du fork** — le code amont est byte-identique au gel (H-M2).

## Surface (contrat seul)

Sous-commandes qui parlent seulement, via le launcher `node openclaw.mjs`
(buildé) ou, sans build, depuis les sources via tsx
(`node --import ./scripts/tsx.mjs src/entry.ts` — même mécanisme que les
scripts amont) :

- `--version` — `OpenClaw 2026.11.2 (<sha>)` (launcher seul, sans build)
- `--help` — aide complète
- `telemetry show` — aperçu local de la requête quotidienne, sans envoi

Le build complet (`pnpm build`) est hors de portée de la VM de travail :
tsdown exige un pic ~4,7 Go (mesuré amont) et la VM plafonne à ~3,5 Go de
heap résolu. Le mode sources est donc le mode de preuve du smoke test ici ;
`dist/entry.js` reste préféré quand il existe.

## Jamais

- Lancer la gateway (`openclaw gateway`, `onboard`) ou toute session agent
- Appel modèle, appel réseau hors npm/pnpm (install/build)
- Envoi télémétrie : `DO_NOT_TRACK=1` et `CI=1` forcés ; statistiques OFF par
  défaut (opt-in explicite) — voir `openclaw-TELEMETRY-AUDIT.md`

## Smoke test

```sh
bash aspace-openclaw-adapter/smoke_test.sh            # mode built si dist présent, sinon sources
bash aspace-openclaw-adapter/smoke_test.sh --netproof # + namespace sans interface réseau
```

stdin est fermé (`< /dev/null`) : le CLI attend sinon une entrée
interactive et ne termine jamais (vérifié sur `telemetry show`).

## Clone partiel

Le repo amont fait ~13,3 Go : clone partiel obligatoire (`--filter=blob:none
--depth 1`) et sparse checkout (`package.json`, `pnpm-workspace.yaml`,
`src/cli`, `src/config`, `src/infra`, `src/gateway/methods`, `src/shared`,
`src`, `packages`, `scripts`, `test`, `patches`, `extensions`, `ui`,
README, LICENSE). Le checkout complet est interdit. L'extension du sparse
checkout au-delà du minimum initial a été dictée par les outils amont
eux-mêmes (prepare → `patches`, `src/gateway/methods`, `src/shared` ;
build → `src`, `extensions` ; suite vitest → `ui`) ; le repo reste à
~2,1 Go, loin des ~13,3 Go du checkout complet.
