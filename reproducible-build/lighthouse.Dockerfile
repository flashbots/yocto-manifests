FROM rust:1.78.0-bullseye AS builder
RUN apt-get update && apt-get -y upgrade && apt-get install -y cmake libclang-dev

WORKDIR /app

COPY . lighthouse

ARG RUSTFLAGS="-C target-feature=+crt-static"
ENV RUSTFLAGS "$RUSTFLAGS"

RUN cd lighthouse && cargo install --target x86_64-unknown-linux-gnu --path lighthouse --force --locked --profile release 

FROM scratch as binaries

COPY --from=builder /usr/local/cargo/bin/lighthouse /lighthouse
