FROM rust:1.79 as base

RUN cargo install cargo-chef --version ^0.1

FROM base AS planner
WORKDIR /app

COPY rbuilder/Cargo.lock ./Cargo.lock
COPY rbuilder/Cargo.toml ./Cargo.toml
COPY rbuilder/.git ./.git
COPY rbuilder/crates/ ./crates/

RUN cargo chef prepare --recipe-path recipe.json

FROM base as builder
WORKDIR /app

RUN apt-get update \
    && apt-get install -y clang libclang-dev

ARG RUSTFLAGS="-C target-feature=+crt-static"
ENV RUSTFLAGS "$RUSTFLAGS"

COPY --from=planner /app/recipe.json recipe.json

RUN cargo chef cook --release --recipe-path recipe.json --target x86_64-unknown-linux-gnu

COPY rbuilder/Cargo.lock ./Cargo.lock
COPY rbuilder/Cargo.toml ./Cargo.toml
COPY rbuilder/.git ./.git
COPY rbuilder/crates/ ./crates/

RUN cargo build --release --target x86_64-unknown-linux-gnu --bin rbuilder

FROM scratch as binaries

COPY --from=builder /app/target/x86_64-unknown-linux-gnu/release/rbuilder /build/rbuilder
