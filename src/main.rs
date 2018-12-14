use actix_web::{server, App, HttpRequest};

fn index(_req: &HttpRequest) -> &'static str {
    "Canary is alive"
}

fn main() {
    server::new(|| App::new().resource("/", |r| r.f(index)))
        .bind("0.0.0.0:8088")
        .unwrap()
        .run();
}
