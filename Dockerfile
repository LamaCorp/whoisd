FROM golang:1.26@sha256:6cd10a6fcc5eadd62008fc2ad8056b38971cafd42f44d55297f18be8adc86410 AS builder

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

FROM debian:13@sha256:34cd9e9fd437c0a095ec39cb2e73422c9f30821b0d0848ed74fd0d43bae4d958

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
