ARG GO_IMAGE=docker.io/library/golang@sha256:640a234f4bea3e399c056b7b8f9c667c4939befae8db2f14e9785e16eccd4205
ARG RUNTIME_IMAGE=docker.io/library/alpine@sha256:14358309a308569c32bdc37e2e0e9694be33a9d99e68afb0f5ff33cc1f695dce
FROM --platform=$BUILDPLATFORM ${GO_IMAGE} AS build

WORKDIR /src
COPY source/go.mod source/go.sum ./
RUN --mount=type=cache,id=tailscale-go-mod,target=/go/pkg/mod \
    go mod download
COPY source/ ./

ARG TARGETOS
ARG TARGETARCH
ARG SOURCE_COMMIT
RUN --mount=type=cache,id=tailscale-go-build,target=/root/.cache/go-build \
    set -eu; \
    ldflags="-s -w -X tailscale.com/version.longStamp=1.102.2-halfclose -X tailscale.com/version.shortStamp=1.102.2 -X tailscale.com/version.gitCommitStamp=${SOURCE_COMMIT}"; \
    mkdir -p /out; \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -trimpath -ldflags="${ldflags}" -o /out/tailscale ./cmd/tailscale; \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -trimpath -ldflags="${ldflags}" -o /out/tailscaled ./cmd/tailscaled; \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -trimpath -ldflags="${ldflags}" -o /out/containerboot ./cmd/containerboot

FROM ${RUNTIME_IMAGE}

ARG SOURCE_COMMIT
RUN apk add --no-cache \
      ca-certificates=20260611-r0 \
      iptables=1.8.11-r1 \
      iptables-legacy=1.8.11-r1 \
      iproute2=6.15.0-r0 \
      iputils=20240905-r0 \
    && rm /usr/sbin/iptables \
    && ln -s /usr/sbin/iptables-legacy /usr/sbin/iptables \
    && rm /usr/sbin/ip6tables \
    && ln -s /usr/sbin/ip6tables-legacy /usr/sbin/ip6tables
COPY --from=build /out/tailscale /out/tailscaled /out/containerboot /usr/local/bin/
RUN mkdir /tailscale && ln -s /usr/local/bin/containerboot /tailscale/run.sh

LABEL org.opencontainers.image.source="https://github.com/9173860/tailscale-halfclose-build" \
      org.opencontainers.image.url="https://github.com/9173860/tailscale/tree/release/v1.102.2-halfclose-slice-25036ff3" \
      org.opencontainers.image.revision="${SOURCE_COMMIT}" \
      org.opencontainers.image.version="v1.102.2-halfclose" \
      org.opencontainers.image.title="Tailscale v1.102.2 half-close backport"

ENTRYPOINT ["/usr/local/bin/containerboot"]
