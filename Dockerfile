# Our first FROM statement declares the build environment.
FROM ekidd/rust-musl-builder AS builder

# Add our source code.
ADD . ./

# Fix permissions on source code.
RUN sudo chown -R rust:rust /home/rust

# Build our application.
RUN cargo build --release

# build real container
FROM alpine:latest

COPY --from=builder /home/rust/src/target/x86_64-unknown-linux-musl/release/canary .

# Configure and document the service HTTP port.
ENV PORT 8080
EXPOSE $PORT

ENTRYPOINT ["./canary"]