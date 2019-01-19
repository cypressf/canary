use actix_web::{server, App, HttpRequest};
use std::env;

fn index(_req: &HttpRequest) -> &'static str {
    "Canary is alive"
}

/// utility function from the heroku buildpack example project
fn get_server_port() -> u16 {
    env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(8080)
}

fn main() {
    use std::net::{SocketAddr};
 //   let sys = actix::System::new("updater");
    let addr = SocketAddr::from(([0, 0, 0, 0], get_server_port()));
println!("Starting server.");

      server::new(|| App::new().resource("/", |r| r.f(index)))
        .bind(addr)
        .expect("Can not bind to port X")
        .run();

}