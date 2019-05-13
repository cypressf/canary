use actix_web::{server, App, HttpRequest};
use log;
use std::env;

fn index(_req: &HttpRequest) -> &'static str {
    log::info!("Canary is chirping");
    //    println!("{:?}", _req);
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
    if ::std::env::var("RUST_LOG").is_err() {
        ::std::env::set_var("RUST_LOG=info", "actix_web=info");
        log::info!("Setting default log level 'ENV RUST_LOG=info'");
    }

    env_logger::init();

    use std::net::SocketAddr;
    let addr = SocketAddr::from(([0, 0, 0, 0], get_server_port()));
    log::info!("Starting server");
    server::new(|| App::new().resource("/", |r| r.f(index)))
        .bind(addr)
        .expect("Can not bind to PORT")
        .run();
}
