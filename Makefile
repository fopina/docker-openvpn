IMAGE:=fopina/openvpn
BASEIMAGE:=alpine:3.10
VERSION:=dev

build:
	@docker build --build-arg BASEIMAGE=${BASEIMAGE} \
	              -t ${IMAGE}:${VERSION} .

release:
	@docker buildx build \
	               --platform linux/amd64,linux/arm64,linux/arm/v7 \
				   --build-arg BASEIMAGE=${BASEIMAGE} \
				   --push \
	               -t ${IMAGE}:${VERSION} \
				   -t ${IMAGE}:latest \
				   .
