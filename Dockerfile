# select build image
FROM rust:1.30 as build

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
# RUN rm ./target/release/deps/canary*
RUN cargo build --release

# our final base
FROM rust:1.30

# copy the build artifact from the build stage
COPY --from=build /canary/target/release/canary .

CMD ["./canary"]
