# Modify standard Rust image
FROM rust:latest as cargo-build
RUN apt-get update
RUN apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl
RUN useradd -u 10001 canaryuser

# Cache dependencies
WORKDIR /usr/src/canary
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock
RUN mkdir src/
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/canary*

# Final Rust build stage. Docker caches up to this stage if dependencies are unchanged.
COPY . .
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
RUN strip /usr/src/canary/target/x86_64-unknown-linux-musl/release/canary

# Final Docker build Stage
FROM scratch
COPY --from=cargo-build /usr/src/canary/target/x86_64-unknown-linux-musl/release/canary .
COPY --from=cargo-build /etc/passwd /etc/passwd
USER canaryuser

# Configure and document the service HTTP port
# ENV PORT 8080
EXPOSE $PORT

ENV RUST_LOG=info
ENTRYPOINT ["./canary"]
