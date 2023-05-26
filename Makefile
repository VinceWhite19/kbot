APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=k8s-k3s-385712
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux#linux darwin windows
TARGETARCH=$(shell dpkg --print-architecture)#amd64 arm64

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
	docker build . -t "gcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}" \
	       --build-arg TARGETARCH=${TARGETARCH} \
		   --build-arg TARGETOS=${TARGETOS} \
		   --build-arg GITHUB_SHA="$GITHUB_SHA" \
           --build-arg GITHUB_REF="$GITHUB_REF" \


linux:
	make image TARGETOS=linux TARGETARCH=amd64

windows:
	make image TARGETOS=windows TARGETARCH=amd64

mac:
	make image TARGETOS=darwin TARGETARCH=arm64

push:
	docker push "gcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}"

clean:
	rm -rf kbot && docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}