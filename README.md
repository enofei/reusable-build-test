# Reusable Build & Test

Reusable GitHub Actions workflow providing a Node.js build, test, and optional security-audit pipeline.

## Usage

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

Pin to a full commit SHA with a `# vX.Y.Z` version comment — never a branch or tag.

| Input | Default | Description |
|---|---|---|
| `node-version` | `'24'` | Node.js version |
| `test-command` | `'npm test'` | Test command run after the build |
| `working-directory` | `'.'` | Directory containing the Node project |
| `security-checks` | `false` | Run `npm audit --audit-level=high` |

Output `build-result`: result of the `build-and-test` job.

Callers must provide `package.json`, `package-lock.json`, a `build` script, and the script named in `test-command`. The workflow runs with `contents: read` and receives no caller secrets.

Resolve a release tag to its commit SHA:

```bash
./scripts/resolve-action-sha.sh enofei/reusable-build-test v1.0.0
```

## Releasing

Merge to `main`, tag it (`git tag -a vX.Y.Z -m "..." && git push origin vX.Y.Z`), then update caller pins to the tag's commit SHA.
