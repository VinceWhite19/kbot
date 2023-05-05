APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=vincewhite19
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=$(shell dpkg --print-architecture) #amd64 arm

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v		

get: 
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags="-X 'github.dev/VinceWhite19/kbot/cmd.appVersion=${VERSION}'"

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot && docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}