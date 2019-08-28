# Based on:
# https://shaneutt.com/blog/rust-fast-small-docker-image-builds/
# https://medium.com/@lizrice/non-privileged-containers-based-on-the-scratch-image-a80105d6d341
# ------------------------------------------------------------------------------
# Cargo Build Stage
# ------------------------------------------------------------------------------

FROM rust:latest as cargo-build

RUN apt-get update

RUN apt-get install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/canary

COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock

RUN mkdir src/

RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

RUN rm -f target/x86_64-unknown-linux-musl/release/deps/canary*

COPY . .
RUN ls -lah

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
RUN strip /usr/src/canary/target/x86_64-unknown-linux-musl/release/canary

RUN useradd -u 10001 canaryuser

# ------------------------------------------------------------------------------
# Final Stage
# ------------------------------------------------------------------------------

FROM scratch
COPY --from=cargo-build /usr/src/canary/target/x86_64-unknown-linux-musl/release/canary .
COPY --from=cargo-build /etc/passwd /etc/passwd
USER canaryuser

# Configure and document the service HTTP port
ENV PORT 8080
EXPOSE $PORT

# Configure log level
ENV RUST_LOG=info

ENTRYPOINT ["./canary"]