# select build image
FROM rust:1.30.1@sha256:de5259a33c09ab11ff60d41860dd4cd661310072a1052d0d62688c87d64c0c16 AS build

# create a new empty shell project
RUN USER=root cargo new --bin canary
WORKDIR /canary

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

RUN cargo clean 

# build for release
RUN cargo build --release

# our final base
FROM rust:1.30.1-slim@sha256:afcd63315f6734b6c407e7d60c7e1bcbe44e2db7d409c13958baa4bf2d2b9600

# copy the build artifact from the build stage
COPY --from=build /canary/target/release/canary .

CMD ["./canary"]