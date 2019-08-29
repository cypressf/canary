use actix_web::{middleware, web, App, HttpServer, Responder};
use log;
use std::env;

fn chirp() -> impl Responder {
    // log::info!("Canary is chirping");
    format!("Canary is alive!")
}

// Get the port number to listen on or fail fast.
fn get_server_port() -> u16 {
    env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .expect("Environment variable PORT must be a number in non-privileged range 1024-65535")
}

fn main() -> std::io::Result<()> {
    env_logger::init();
    log::info!("Logging initialized");

    use std::net::SocketAddr;

    HttpServer::new(|| {
        App::new()
            .wrap(middleware::Logger::default())
            .service(web::resource("/").to(chirp))
    })
    .bind(SocketAddr::from(([0, 0, 0, 0], get_server_port())))?
    .run()
}
