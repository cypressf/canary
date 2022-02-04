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

WORKDIR /usr/src/canary

COPY . .
RUN cargo build --release 

FROM gcr.io/distroless/cc
COPY --from=build /usr/src/canary/target/release/canary .
COPY --from=build /usr/src/canary/target/release/test .
COPY --from=build /etc/passwd /etc/passwd
COPY script .
USER canaryuser

ENV RUST_LOG=info
ENTRYPOINT ["./test && ./canary"]
