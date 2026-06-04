#!/usr/bin/env bash
#
# Clean-room regeneration of the App Server protocol types.
#
# Why "clean-room": we delete ALL of src/ before regenerating, so that types
# the new Codex version renamed or removed disappear from the working tree and
# show up as deletions/renames in `git add` — a plain re-run would leave stale
# files behind and only ever show additions/modifications.
#
# Steps:
#   1. Resolve + print the codex binary and its version.
#   2. rm -rf src   (so removals/renames surface in the diff)
#   3. codex app-server generate-ts --out ./src --experimental
#   4. git add -A src
#   5. Print an A/D/M summary, the file count, and the detected version.
#
# Binary selection (first match wins):
#   - $PWRDRVR_CODEX_BIN if set
#   - Codex Desktop's bundled binary (default)
# To pin an EXACT released version (recommended for a real release), download
# the matching release binary and point PWRDRVR_CODEX_BIN at it — see AGENTS.md.
#
set -euo pipefail

CODEX_BIN="${PWRDRVR_CODEX_BIN:-/Applications/Codex.app/Contents/Resources/codex}"

# Repo root = parent of this script's directory.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -x "$CODEX_BIN" ]]; then
  echo "error: codex binary not found or not executable: $CODEX_BIN" >&2
  echo "       set PWRDRVR_CODEX_BIN to a codex binary (see AGENTS.md)." >&2
  exit 1
fi

VERSION_RAW="$("$CODEX_BIN" --version)"          # e.g. "codex-cli 0.135.0"
VERSION="${VERSION_RAW##* }"                      # -> "0.135.0"

echo "codex binary : $CODEX_BIN"
echo "codex version: $VERSION_RAW"
echo

# 1. Delete all generated code so removals/renames surface in the diff.
echo "==> rm -rf src"
rm -rf src
mkdir -p src

# 2. Regenerate (experimental surface included).
echo "==> codex app-server generate-ts --out ./src --experimental"
"$CODEX_BIN" app-server generate-ts --out ./src --experimental

# 3. Stage so added/removed/changed files all appear in `git status`.
echo "==> git add -A src"
git add -A src

# 4. Summary.
echo
echo "Staged changes (A=added, D=deleted, M=modified, R=renamed):"
git diff --cached --name-status -- src | sed 's/^/  /'
echo
echo "  added   : $(git diff --cached --name-status -- src | grep -c '^A' || true)"
echo "  deleted : $(git diff --cached --name-status -- src | grep -c '^D' || true)"
echo "  modified: $(git diff --cached --name-status -- src | grep -c '^M' || true)"
echo "  .ts files now: $(find src -name '*.ts' | wc -l | tr -d ' ')"
echo
echo "Detected codex version: $VERSION"
echo "Next: set package.json \"version\" and \"codexCliVersion\" to \"$VERSION\","
echo "      refresh the README \"Current generated source\" line + file count,"
echo "      then run \`pnpm typecheck\`. See AGENTS.md."
