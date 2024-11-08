# syntax=docker/dockerfile:1
FROM golang:1.22 as builder
ARG VERSION
WORKDIR /build
RUN git clone https://github.com/flashbots/measured-boot.git /build
RUN --mount=type=cache,target=/root/.cache/go-build CGO_ENABLED=0 GOOS=linux \
    go build \
        -trimpath \
        -ldflags "-s -X main.version=${VERSION}" \
        -v \
        -o measured-boot \
    measured-boot.go

FROM ubuntu:22.04
WORKDIR /app

RUN apt update && apt install -y python3 parted libssl-dev python3-pip mtools
RUN pip install signify

COPY --from=builder /build/measured-boot /app/measured-boot
ADD ./measure.sh /app/measure
RUN chmod +x /app/measure

CMD ["/app/measure"]
