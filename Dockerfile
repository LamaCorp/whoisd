FROM golang:1.27@sha256:205c7636d74e0ffbe3d007162df7d74f859f5a8c8322dfb9f907977686c126cf AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux

WORKDIR /go/src/whoisd

COPY ./ ./

ARG VERSION
ARG COMMIT
ENV VERSION=$VERSION
ENV COMMIT=$COMMIT

RUN go build \
  -trimpath \
  -ldflags="-s -w -X main.version=v$VERSION -X main.commit=$COMMIT" \
  -o whoisd \
  ./...

FROM debian:13@sha256:9c6e381421d0f48d1b8133e573f33c185ee16cbf505eda9c4a8a4791b25ea8a6

ARG VERSION
ARG COMMIT

LABEL org.opencontainers.image.authors="Lama Corp."
LABEL org.opencontainers.image.source="https://github.com/LamaCorp/whoisd"
LABEL org.opencontainers.image.description="A recursive WHOIS server, it gets the data from whomever owns it."
LABEL org.opencontainers.image.documentation="https://github.com/LamaCorp/whoisd"
LABEL org.opencontainers.image.licenses="https://github.com/LamaCorp/whoisd/blob/main/LICENSE"
LABEL org.opencontainers.image.revision=${COMMIT}
LABEL org.opencontainers.image.title="whoisd"
LABEL org.opencontainers.image.url="https://github.com/LamaCorp/whoisd"
LABEL org.opencontainers.image.vendor="Lama Corp."
LABEL org.opencontainers.image.version=${VERSION}

WORKDIR /app

COPY ./LICENSE /app/LICENSE

COPY --from=builder /go/src/whoisd/whoisd /app/whoisd

CMD ["/app/whoisd"]
