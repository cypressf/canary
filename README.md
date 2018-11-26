# canary

Canary is not "Hello world".

Buildt in Rust with the Actix web framework.

https://hub.docker.com/r/acje/canary/

Rust-image/Debian-stretch-slim based docker image (964MB + 10MB App).
Run:

docker run -p 8088:8088/tcp acje/canary

Response at

http://localhost:8088/  "Canary is alive" (happy path)
