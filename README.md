# Canary

![Docker Pulls](https://img.shields.io/docker/pulls/acje/canary)

Canary has only one feature. It replies "Canary is alive!".

Buildt in Rust with the Actix-web 3 framework on distroless image.

<https://hub.docker.com/r/acje/canary/>

Run:

docker run -e "PORT=8080" -p 8080:8080 acje/canary:latest

Response at <http://localhost:8080/>

On cloud run:
<https://canary-app-acje-qvw63kdulq-ue.a.run.app/>
