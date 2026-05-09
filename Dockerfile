FROM golang:1.26@sha256:2981696eed011d747340d7252620932677929cce7d2d539602f56a8d7e9b660b AS builder

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

FROM debian:13@sha256:35b8ff74ead4880f22090b617372daff0ccae742eb5674455d542bef71ef1999

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
