# Stable backport equivalence

## PR #20881

- Canonical head/tree: `b32a93e5fd1a4bef1c9d679ab6debb01639706d5` / `4392ba00687f3781b232a1ec8267ec1b7aa7b0bb`
- Stable base: `05a91829316e055517a1e84f7b00016846ef4107`
- Stable commits: `ce39a42bd385ad5a54ac7b5f61332e04bc5c7d7a`, compatibility import `cde955f3b8c8cf00978858d99a5441f5ed52b584`
- Canonical/stable patch IDs differ because v1.98.8 predates `serviceMeteredConn` and the unrelated `raceDialUser` test block used as canonical hunk context.
- Conflict policy: omit the nonexistent service-meter wrapper and its test; do not import newer unrelated race-dial production/test code. Preserve `sysConn.CloseWrite`, the complete capacity-two Serve pump state machine, PROXY v2 prefix ordering, hard-failure full close, and real 8 MiB/EOF/1 MiB tests. Add only the `net` import required by the stable test file.
- Conflict blob evidence (`canonical parent → canonical head`; `stable base → stable head`):
  - `ipn/ipnlocal/serve.go`: `3730123a76ddb22f4facaad96f3408bbd404a2e5 → fdcf5e86357e48daba2212d2690a8cba628a5a01`; `83b8027d7c02ca08713bdbddd351a887988c2e81 → b2d72012e4b0df8f36714510308c1dc89a815369`.
  - `ipn/ipnlocal/serve_test.go`: `84c0b293f4994e6f46a974f3e340f51391808f3e → 3ebcc728b3cbcde266980c8a12039d842071ddd4`; `05f4936b2c299ff35d2b1f2bb3dffcf9d0e55e4c → 31ecdd9c696fd021cc4eccc82eca07760a0f12c1`.
  - `net/tsdial/tsdial.go`: `ea2ddc63292070c7633b63b56e9bb6c7b7141b1a → 400e6d28350e39ab41f4a8935f3e13dfe98462ac`; `ca08810a3da0e9b9977a183110e8505c1f8ca1f6 → 4b79fe1e1c6e1f24db09474437ba3e6d9ec42f63`.
  - `net/tsdial/tsdial_test.go`: `c8868ab363ae287f90a6921b0c52bedc67f3c4a9 → 88401656665096dd416b7e9c3c910d8e7e4938f3`; `92960acbe38b1dd4b718a508feebd4d840573480 → f8656823071e9764c90b2387778588a27df691f8`.
- The six-file aggregate diff and all tests are checked by the release workflow before publishing.

## PR #20886

- Canonical head/tree: `71aa5296baed84ed99e3353f1a48b992d8b71433` / `63cb6205cba9753558cee77cc6d07117d375d985`
- Stable commit: `b24757ee86a0a0716ba653a9a2ee301334671d2e`
- Canonical and stable patch ID: `928e411132e47ea4a818996a43d10f17b7c85d1d`
- Cherry-pick was conflict-free.
