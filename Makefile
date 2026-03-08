TEST?=$$(go list ./... | grep -v 'vendor')
BINARY=whoisd

all: build

lint:
	golangci-lint run --timeout 5000s --verbose

build:
	go build -o ${BINARY}

build-all:
	GOOS=darwin GOARCH=amd64 go build -o ./bin/${BINARY}_darwin_amd64
	GOOS=freebsd GOARCH=386 go build -o ./bin/${BINARY}_freebsd_386
	GOOS=freebsd GOARCH=amd64 go build -o ./bin/${BINARY}_freebsd_amd64
	GOOS=freebsd GOARCH=arm go build -o ./bin/${BINARY}_freebsd_arm
	GOOS=linux GOARCH=386 go build -o ./bin/${BINARY}_linux_386
	GOOS=linux GOARCH=amd64 go build -o ./bin/${BINARY}_linux_amd64
	GOOS=linux GOARCH=arm go build -o ./bin/${BINARY}_linux_arm
	GOOS=openbsd GOARCH=386 go build -o ./bin/${BINARY}_openbsd_386
	GOOS=openbsd GOARCH=amd64 go build -o ./bin/${BINARY}_openbsd_amd64
	GOOS=solaris GOARCH=amd64 go build -o ./bin/${BINARY}_solaris_amd64
	GOOS=windows GOARCH=386 go build -o ./bin/${BINARY}_windows_386
	GOOS=windows GOARCH=amd64 go build -o ./bin/${BINARY}_windows_amd64

test:
	go test -i $(TEST) || exit 1
	echo $(TEST) | xargs -t -n4 go test $(TESTARGS) -timeout=30s -parallel=4

.PHONY = all lint build build-all test
