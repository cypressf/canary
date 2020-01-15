# Canary

![Docker Pulls](https://img.shields.io/docker/pulls/acje/canary)

Canary has only one feature. It replies "Canary is alive!".

Buildt in Rust with the Actix-web 2.0 framework and musl in a "from scratch" docker image. The container is compatible with Google cloud run.

https://hub.docker.com/r/acje/canary/

Run:

docker run -e "PORT=8080" -p 8080:8080 acje/canary:latest

Response at http://localhost:8080/ 


References for Dockerfile:

https://shaneutt.com/blog/rust-fast-small-docker-image-builds

https://medium.com/@lizrice/non-privileged-containers-based-on-the-scratch-image-a80105d6d341

https://doc.rust-lang.org/rustc/profile-guided-optimization.html

https://benjamincongdon.me/blog/2019/12/04/Fast-Rust-Docker-Builds-with-cargo-vendor/
