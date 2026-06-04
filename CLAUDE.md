# CLAUDE.md

See **[AGENTS.md](AGENTS.md)** for how to work in this repo.

Highlights:

- Everything under `src/` is **generated** (`// GENERATED CODE!` header) — never
  hand-edit it. Regenerate from a different Codex version instead.
- The package version **equals** the `codex-cli` version that generated `src/`
  (generate from an exact release, not a `-alpha`).
- To bump versions, follow the **clean-room regeneration procedure** in
  [AGENTS.md](AGENTS.md) (`pnpm regenerate` — it deletes `src/` first so
  removed/renamed types show up in the diff).
- Publishing: [PUBLISHING.md](PUBLISHING.md).
