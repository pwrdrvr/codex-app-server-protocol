# Changelog

All notable package changes are documented here. The package version mirrors the
`codex-cli` version used to generate `src/`, and generated entries use
`codex app-server generate-ts --experimental`.

## 0.153.4 - 2026-09-06

Generated from exact released `codex-cli 0.153.4` with the experimental surface.
827 generated TypeScript files, up from 671 in 0.144.0. The client request union
adds 33 methods and the server notification union adds 14 methods; neither
union removes a method.

### Added

- `ServerNotificationEnvelope` with optional `emittedAtMs` (Unix milliseconds)
  for server emission time; older servers may omit it. This is live notification
  timing, not historical item timing.
- Server-managed thread queue add, update, delete, reorder, list, and start
  RPCs, plus queue change notifications and `turn/settings/update`.
- Project CRUD, import, and move RPCs; thread section management; project and
  section assignments on threads; thread revert and occurrence search.
- Experimental `thread/timeline/list`, combining ordinary items, realtime
  items, and turn boundaries, plus backwards hydration cursors on resume.
- Agent-message delivery and asynchronous question metadata, a
  `functionCallOutput` thread-item variant, and `toolOutput` on turn start.
- Audio and local-audio user input, realtime item lifecycle/transcript
  notifications, and an `existingCall` realtime transport.
- Bedrock discovery/setup, provider auth recovery notifications, environment
  status and connection notifications, and server diagnostics.
- MCP event streams, client extension declarations, expanded MCP metadata,
  plugin search/reconciliation, app reads, and installed-app queries.
- Thread model/reasoning-effort/direct-input metadata, per-turn service tier,
  fork-before-turn support, deferred fork goal continuation, model multi-agent
  metadata, cache-write token accounting, and raw response usage notifications.

### Changed / consumer migration

- **`ThreadItemsListResponse.data` now contains `ThreadItemEntry` envelopes
  (`{ turnId, item }`) instead of bare `ThreadItem` values.** Consumers must
  unwrap `entry.item` and can use `entry.turnId` for attribution.
- `ToolRequestUserInputParams` adds required `isBlocking`; use it instead of
  deprecated `autoResolutionMs` to decide whether a question blocks.
- Removed `AmazonBedrockCredentialSource`; the Bedrock account variant now
  reports `usesCodexManagedCredentials` instead of `credentialSource`.
- `ReviewDecision` changes `"denied"` to `{ denied: { rejection: string } }`
  and adds `"approved_mcp_policy_amendment"`.
- Many response types add required nullable fields, including `Thread`,
  `Model`, agent messages, and resume responses. Update typed fixtures and
  exhaustive union handling; newer declarations do not upgrade older servers.
- Full-history hydration is deprecated for paginated threads; prefer metadata
  reads and `thread/turns/list` / `thread/items/list` pagination.
- **Historical per-item timestamps are still absent**, including item-list
  envelopes and ordinary timeline entries. Preserve known live lifecycle times
  and leave unknown historical times absent. See the README for the upstream
  investigation and proposal.

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
