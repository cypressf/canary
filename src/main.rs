use actix_web::{middleware, web, App, HttpServer};
use std::env;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    std::env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();

    use std::net::SocketAddr;

    HttpServer::new(|| {
        App::new()
            // enable logger
            .wrap(middleware::Logger::default())
            .service(web::resource("/").to(chirp))
    })
    .bind(SocketAddr::from(([0, 0, 0, 0], get_server_port())))?
    .run()
    .await
}

async fn chirp() -> &'static str {
    "Canary 0.37.0 is alive!\r\n"
}

// Get the port number to listen on or fail fast.
fn get_server_port() -> u16 {
    env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .expect("Aborting: Failed to read environment variable PORT")
}
