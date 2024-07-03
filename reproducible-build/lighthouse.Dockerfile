FROM ubuntu:22.04 AS builder

# Update default packages
RUN apt-get update && apt-get install -y build-essential cmake libclang-dev curl

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

COPY . lighthouse

ARG RUSTFLAGS="-C target-feature=+crt-static"
ENV RUSTFLAGS "$RUSTFLAGS"

RUN cd lighthouse && cargo install --target x86_64-unknown-linux-gnu --path lighthouse --force --locked --profile release 

FROM scratch as binaries

COPY --from=builder /usr/local/cargo/bin/lighthouse /lighthouse
