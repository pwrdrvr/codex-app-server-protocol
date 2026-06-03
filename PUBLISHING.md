# Publishing

This package publishes to npm as **`@pwrdrvr/codex-app-server-protocol`** via
**OIDC trusted publishing** from GitHub Actions — no long-lived `NPM_TOKEN`
secret in the repo. The steady-state flow is tokenless; there is a **one-time
bootstrap** because npm cannot configure a trusted publisher until the package
already exists.

## Version scheme (recap)

`version` **mirrors** the `codex-cli` version that generated `src/`
(`0.133.0` ← `codex-cli 0.133.0`). `codexCliVersion` + `codexExperimental` in
`package.json` record provenance. Never bump the patch for a packaging-only fix
(it would imply a Codex surface that doesn't exist) — use a `-next.N` prerelease
instead. See `README.md` § Versioning.

## One-time bootstrap (creates the package on npm)

> Trusted publishing requires at least one existing published version before a
> trusted publisher can be configured. Pick **one** of the following to create
> `0.133.0`, then switch to the tokenless flow below.

**Option A — local publish (simplest):**

```bash
npm login                 # as a user with @pwrdrvr publish rights
npm publish --access public
```

(Local publish cannot attach provenance — that's fine for the bootstrap; every
subsequent GHA publish will carry provenance.)

**Option B — one temporary token in GHA:** add a short-lived `NPM_TOKEN` repo
secret, run a one-off publish, then delete the secret and rely on OIDC.

## Configure the trusted publisher (once, on npmjs.com)

After the package exists:

1. npmjs.com → **`@pwrdrvr/codex-app-server-protocol`** → **Settings** →
   **Trusted Publisher**.
2. Add a **GitHub Actions** publisher:
   - **Organization / user:** `pwrdrvr`
   - **Repository:** `codex-app-server-protocol`
   - **Workflow filename:** `publish.yml`
   - **Environment:** *(leave blank unless you add one to the workflow)*
3. Save. The repo's `package.json` `repository` field already points at this
   repo, which npm cross-checks.

## Steady-state publish (tokenless, every release after bootstrap)

1. Regenerate against the target Codex version and bump to match:
   ```bash
   PWRDRVR_CODEX_BIN=/path/to/codex pnpm generate
   # edit package.json: version + codexCliVersion = the new `codex --version`
   git commit -am "feat: regenerate protocol from codex-cli <new-version>"
   ```
2. Push, then cut a **GitHub Release** tagged `v<version>` (e.g. `v0.133.0`).
   - Or trigger **Actions → Publish → Run workflow** and pick a `dist-tag`.
3. `.github/workflows/publish.yml` typechecks, verifies the tag matches
   `package.json`, and runs `npm publish --provenance` using the OIDC token. No
   secret involved.

## Notes

- The publish workflow upgrades to the latest npm (trusted publishing needs
  `npm >= 11.5.1`) and sets `id-token: write`.
- `publishConfig.access` is `public`; provenance is added via the `--provenance`
  flag in the workflow (not in `package.json`, so the local bootstrap publish in
  Option A doesn't fail for lack of an OIDC context).
- Prereleases: run the workflow manually with `dist-tag = next` to publish a
  `*-next.N` version without moving `latest`.
