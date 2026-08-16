# tailscale-halfclose-build

Auditable release-only workflow and metadata for the temporary
`ghcr.io/9173860/tailscale-halfclose` image. Source lives in the public
[`9173860/tailscale`](https://github.com/9173860/tailscale) fork and is checked
out by exact commit. This repository does not carry or modify the source patch.

The only publishing entry point is
`.github/workflows/build.yml@refs/heads/main`. Deployments must use an exact OCI
index digest, never a mutable tag.
