ARG GO_IMAGE=docker.io/library/golang@sha256:70b46548e42db77e0966aaf3619fd068734dc6c77584d526b91126504fd95816
ARG RUNTIME_IMAGE=docker.io/library/alpine@sha256:14358309a308569c32bdc37e2e0e9694be33a9d99e68afb0f5ff33cc1f695dce
FROM ${GO_IMAGE} AS build

WORKDIR /src
COPY source/go.mod source/go.sum ./
RUN go mod download
COPY source/ ./

ARG TARGETARCH
ARG SOURCE_COMMIT
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go install -trimpath -ldflags="-s -w -X tailscale.com/version.longStamp=1.98.8-halfclose -X tailscale.com/version.shortStamp=1.98.8 -X tailscale.com/version.gitCommitStamp=${SOURCE_COMMIT}" ./cmd/tailscale ./cmd/tailscaled ./cmd/containerboot

FROM ${RUNTIME_IMAGE}

ARG SOURCE_COMMIT
RUN apk add --no-cache ca-certificates iptables iptables-legacy iproute2 ip6tables iputils \
    && rm /usr/sbin/iptables \
    && ln -s /usr/sbin/iptables-legacy /usr/sbin/iptables \
    && rm /usr/sbin/ip6tables \
    && ln -s /usr/sbin/ip6tables-legacy /usr/sbin/ip6tables
COPY --from=build /go/bin/tailscale /go/bin/tailscaled /go/bin/containerboot /usr/local/bin/
RUN mkdir /tailscale && ln -s /usr/local/bin/containerboot /tailscale/run.sh

LABEL org.opencontainers.image.source="https://github.com/9173860/tailscale" \
      org.opencontainers.image.revision="${SOURCE_COMMIT}" \
      org.opencontainers.image.version="v1.98.8-halfclose" \
      org.opencontainers.image.title="Tailscale v1.98.8 half-close backport"

ENTRYPOINT ["/usr/local/bin/containerboot"]
