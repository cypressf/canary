# Canary

Canary is not "Hello world".

Buildt in Rust with the Actix-web framework.

https://hub.docker.com/r/acje/canary/

Less than 10MB image on docker hub. Buildt as static binary with musl in docker container from scratch.
https://github.com/emk/rust-musl-builder

Run:

docker run -p 8080:8080/tcp acje/canary:latest

Response at http://localhost:8080/ 

"Canary is alive!"

(happy path)

References for Dockerfile:

https://shaneutt.com/blog/rust-fast-small-docker-image-builds

https://medium.com/@lizrice/non-privileged-containers-based-on-the-scratch-image-a80105d6d341

https://doc.rust-lang.org/rustc/profile-guided-optimization.html
