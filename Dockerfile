FROM ekidd/rust-musl-builder AS builder

# Add source code.
ADD . ./

# Fix permissions on source code.
RUN sudo chown -R rust:rust /home/rust

# Build application.
RUN cargo build --release

# Build final container
FROM alpine:latest

COPY --from=builder /home/rust/src/target/x86_64-unknown-linux-musl/release/canary .

# Configure and document the service HTTP port.
ENV PORT 8080
EXPOSE $PORT

# Configure log level
ENV RUST_LOG=debug

ENTRYPOINT ["./canary"]
