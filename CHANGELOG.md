# Changelog

All notable package changes are documented here. The package version mirrors the
`codex-cli` version used to generate `src/`, and generated entries use
`codex app-server generate-ts --experimental`.

## 0.144.0 - 2026-07-11

Generated from `codex-cli 0.144.0`.

### Added

- Remote control pairing and client-management RPCs:
  `remoteControl/pairing/start`, `remoteControl/pairing/status`,
  `remoteControl/client/list`, and `remoteControl/client/revoke`.
- Thread lifecycle support for deletion via `thread/delete` and the
  `thread/deleted` notification.
- Background terminal listing and termination RPCs for threads.
- Thread hierarchy and subagent metadata, including `parentThreadId`,
  `historyMode`, `extra`, `recencyAt`, and list filters for parent or ancestor
  thread IDs.
- Account usage and rate-limit reset-credit types and RPCs, including
  `account/usage/read`, `account/rateLimitResetCredit/consume`, reset-credit
  summaries, and spend-control limit snapshots.
- Realtime session controls for speech append, handoff behavior, startup
  context, realtime model override, and realtime protocol version override.
- Dynamic tool namespace specs alongside function specs.
- External-agent config import progress notifications and import history reads.
- Server-to-client `currentTime/read` requests.
- Skills extra-root configuration, npm plugin source metadata, app template
  summaries, and plugin install policy source metadata.
- Turn moderation metadata and model safety-buffering notifications.

### Changed

- `thread/turns/items/list` was renamed to `thread/items/list`, with
  `ThreadTurnsItemsList*` types renamed to `ThreadItemsList*`.
- `ReasoningEffort` widened from a fixed string union to `string`.
- Runtime workspace roots now use `AbsolutePathBuf[]` in thread start, resume,
  fork, and turn start params.
- `ThreadItem` path fields now use `LegacyAppPathString` in several places and
  gained updated web-search, image-generation, sleep, subagent-activity, and
  MCP app-context item shapes.
- `AskForApproval` no longer includes `"on-failure"`.
- `AuthMode` gained `headers`, `personalAccessToken`, and `bedrockApiKey`.
- `WebSearchMode` gained `indexed`.
- `ThreadSortKey` gained `recency_at`.

## 0.135.0 - 2026-06-04

Generated from `codex-cli 0.135.0`.

### Changed

- Regenerated the vendored App Server protocol types from Codex CLI 0.135.0.
- Updated package metadata so `version` and `codexCliVersion` both mirror
  `0.135.0`.

## 0.133.0 - 2026-06-02

Generated from `codex-cli 0.133.0`.

### Added

- Initial package population with generated App Server protocol TypeScript
  types and publishing metadata.
