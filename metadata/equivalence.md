# v1.102.2 backport equivalence

## PR #20881

- Canonical head/tree: `b32a93e5fd1a4bef1c9d679ab6debb01639706d5` / `4392ba00687f3781b232a1ec8267ec1b7aa7b0bb`.
- v1.102.2 commit: `969b8867cbd6193e1cc0ed6a5271ad391a889765`.
- Canonical and v1.102.2 patch ID: `d6136b17085dcb72dabf5281f3dbd3fc8aa2df46`.
- `ipn/ipnlocal/serve.go` and `serve_test.go` have different whole-parent blobs because the PR was cut from current main, but reversing the local delta restores the exact v1.102.2 base blobs. Applying both PR patches independently to the base produces all six exact combined-tree blobs.

## PR #20886

- Canonical head/tree: `71aa5296baed84ed99e3353f1a48b992d8b71433` / `63cb6205cba9753558cee77cc6d07117d375d985`.
- v1.102.2 commit: `65394776006e93dc05354bb192fd4bb3e5e92f16`.
- Canonical and v1.102.2 patch ID: `928e411132e47ea4a818996a43d10f17b7c85d1d`.

The release workflow rechecks both patch IDs, exact source base/head/tree, the exact six-file allowlist, tests, race tests, and vet before any candidate build.
