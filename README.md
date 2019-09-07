# Canary

Canary is not "Hello world".

Buildt in Rust with the Actix-web 1.0 framework.

https://hub.docker.com/r/acje/canary/

Tiny image on docker hub. Buildt as static binary with musl in docker container "scratch".

Run:

docker run -p 8080:8080/tcp acje/canary:latest

Response at http://localhost:8080/ 

"Canary is alive!"


References for Dockerfile:

https://shaneutt.com/blog/rust-fast-small-docker-image-builds

https://medium.com/@lizrice/non-privileged-containers-based-on-the-scratch-image-a80105d6d341

https://doc.rust-lang.org/rustc/profile-guided-optimization.html
