# Modify standard Rust image
FROM rust:latest as build

ENV USER=canaryuser
ENV UID=12345
RUN adduser \
    --disabled-password \
    --gecos "" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

# Cache dependencies
WORKDIR /usr/src/canary
# COPY Cargo.toml Cargo.toml
# COPY Cargo.lock Cargo.lock
# RUN mkdir src/
# RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
# RUN cargo build --release
# RUN rm -f target/release/deps/canary*

# Final Rust build stage. Docker caches up to this stage if dependencies are unchanged.
COPY . .
RUN cargo build --release 

# Final Docker build Stage
FROM gcr.io/distroless/cc
COPY --from=build /usr/src/canary/target/release/canary .
COPY --from=build /etc/passwd /etc/passwd
USER canaryuser

ENV RUST_LOG=info
ENTRYPOINT ["ls && ./canary"]
