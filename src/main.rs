use actix_web::{server, App, HttpRequest};
use std::env;

fn index(_req: &HttpRequest) -> &'static str {
    "Canary is alive"
}

// Get the port number to listen on or fail fast.
fn get_server_port() -> u16 {
    env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .expect("ENV VAR PORT must be a number")
}

fn main() {
    use std::net::SocketAddr;
    let addr = SocketAddr::from(([0, 0, 0, 0], get_server_port()));
    println!("Starting server");

    server::new(|| App::new().resource("/", |r| r.f(index)))
        .bind(addr)
        .expect("Can not bind to PORT")
        .run();
}