FROM golang:1.26@sha256:478231bfd9677835606c249208483a3c43b31e941c1040c48747b111c7ab871c AS builder

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

FROM debian:trixie-20260610@sha256:fe7312b5f05bf5f43fad76bcd8945642e4e47a68aefd1b73f447615899d0fac1

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
