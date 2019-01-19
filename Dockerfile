FROM alpine:latest

COPY ./target/x86_64-unknown-linux-musl/release/canary .

# Configure and document the service HTTP port.
ENV PORT 8088
EXPOSE $PORT

ENTRYPOINT ["./canary"]