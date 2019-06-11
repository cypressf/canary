use actix_web::{web, App, HttpServer, Responder, middleware};
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
        .expect("ENV VAR PORT must be a number")
}

fn main() -> std::io::Result<()> {
    env_logger::init();
    log::info!("Logging initialized");
    
    use std::net::SocketAddr;
    let addr = SocketAddr::from(([0, 0, 0, 0], get_server_port()));
    
    
    HttpServer::new(|| {
        App::new()
            //    .service(web::resource("/{name}/{id}/index.html").to(index))
            .wrap(middleware::Logger::default())
            .service(web::resource("/").to(chirp))
    })
    .bind(addr)?
    .run()
}
