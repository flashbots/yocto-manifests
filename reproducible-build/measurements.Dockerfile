# syntax=docker/dockerfile:1
FROM golang:1.21 as builder
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

FROM alpine:latest
WORKDIR /app
COPY --from=builder /build/measured-boot /app/measured-boot
ADD ./measure.sh /app/measure
RUN chmod +x /app/measure
CMD ["/app/measure"]
