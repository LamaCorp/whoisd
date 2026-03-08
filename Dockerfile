FROM golang:1.22 as builder

WORKDIR /go/src/whoisd

COPY ./ ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o whoisd .

FROM debian:13@sha256:3615a749858a1cba49b408fb49c37093db813321355a9ab7c1f9f4836341e9db

WORKDIR /app

COPY --from=builder /go/src/whoisd/whoisd /app/whoisd

CMD ["/app/whoisd"]
