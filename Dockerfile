FROM ekidd/rust-musl-builder AS builder

# Add source code
ADD Cargo.* ./
ADD src/ ./src

# Fix permissions on source code
RUN sudo chown -R rust:rust /home/rust

# update rust needed until 1.37 is in upstream image
# RUN sudo rustup update
# RUN rustup show

# Build PGO instrumented application
# RUN RUSTFLAGS="-Cprofile-generate=/tmp/pgo-data" cargo build --release
RUN cargo build --release

# Generate profile
RUN timeout 10 --signal=SIGINT PORT=8080 /home/rust/src/target/x86_64-unknown-linux-musl/release/canary &
RUN timeout 2 bash -c -- 'while true; do curl localhost:8080;done'
# RUN llvm-profdata merge -o /tmp/pgo-data/merged.profdata /tmp/pgo-data

# Build application from PGO
# RUN RUSTFLAGS="-Cprofile-use=/tmp/pgo-data/merged.profdata" cargo build --release
RUN strip /home/rust/src/target/x86_64-unknown-linux-musl/release/canary

# Build final container
FROM scratch

COPY --from=builder /home/rust/src/target/x86_64-unknown-linux-musl/release/canary .

# Configure and document the service HTTP port
ENV PORT 8080
EXPOSE $PORT

# Configure log level
ENV RUST_LOG=info

ENTRYPOINT ["./canary"]
