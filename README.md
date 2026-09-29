# Reusable Build & Test

A GitHub Actions [reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows) that provides a standard **Node.js build, test, and (optionally) security-audit pipeline** for repositories in this organization.

## Usage

Reference the workflow from a caller repository's job:

```yaml
jobs:
  build-and-test:
    name: Build & Test
    uses: enofei/reusable-build-test/.github/workflows/build-test.yml@<commit-sha>  # v1.0.0
    with:
      node-version: '24'
      test-command: 'npm run test:ci'
      security-checks: true
```

> **Security policy:** always pin `@<commit-sha>` (a full commit SHA) with a `# vX.Y.Z` version comment — never a branch or a mutable tag. See [Pinning](#pinning) below.

## Inputs

| Input | Type | Default | Description |
|---|---|---|---|
| `node-version` | string | `'24'` | Node.js version passed to `actions/setup-node` (default = latest LTS line) |
| `test-command` | string | `'npm test'` | Test command to run after the build |
| `working-directory` | string | `'.'` | Directory containing the Node project |
| `security-checks` | boolean | `false` | Also run `npm audit --audit-level=high` |

## Outputs

| Output | Description |
|---|---|
| `build-result` | Result of the `build-and-test` job (`success`, `failure`, …) |

## Contract for caller repositories

The called workflow assumes the caller repo provides, in `working-directory`:

- a `package.json` **and** `package-lock.json` (the lockfile is required — npm caching fails without it),
- a `build` script (`npm run build`),
- the script referenced by `test-command` (e.g. `npm run test:ci`).

The workflow runs with `contents: read` permissions and never receives caller secrets.

## Pinning

Actions and the workflow itself are SHA-pinned for supply-chain security. To resolve a release tag to its commit SHA:

```bash
./scripts/resolve-action-sha.sh enofei/reusable-build-test v1.0.0
# prints: <commit-sha>  # v1.0.0
```

## Releasing

1. Merge changes to `main` (Dependabot keeps action SHAs up to date via grouped PRs).
2. Create an annotated release tag on `main`: `git tag -a vX.Y.Z -m "..." && git push origin vX.Y.Z`.
3. Update caller repositories to the new tag's **commit** SHA (Dependabot also proposes these updates).
