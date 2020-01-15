use actix_web::{get, middleware, App, HttpServer};
use log;
use std::env;

#[get("/")]
async fn chirp() -> &'static str {
    "Canary is alive!\r\n"
}

// Get the port number to listen on or fail fast.
fn get_server_port() -> u16 {
    env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .expect("Aborting: Failed to read environment variable PORT")
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    env_logger::init();
    log::info!("Logging initialized");

    use std::net::SocketAddr;

    HttpServer::new(|| {
        App::new()
            .wrap(middleware::Logger::default())
            .service(chirp)
    })
    .bind(SocketAddr::from(([0, 0, 0, 0], get_server_port())))?
    .run()
    .await
}
