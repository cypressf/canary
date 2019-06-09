//size optimizatin: https://jamesmunns.com/blog/tinyrocket/#tldr
//use actix_web::{server, App, HttpRequest};
use actix_web::{web, App, HttpServer, Responder};
use log;
use std::env;

// fn index(info: web::Path<(String, u32)>) -> impl Responder {
//     log::info!("Canary is chirping");
//     format!("Hello {}! id:{}", info.0, info.1)
// }

fn chirp() -> impl Responder {
    log::info!("Canary is chirping");
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
    use std::net::SocketAddr;
    let addr = SocketAddr::from(([0, 0, 0, 0], get_server_port()));
    log::info!("Starting server");

    HttpServer::new(|| {
        App::new()
            //    .service(web::resource("/{name}/{id}/index.html").to(index))
            .service(web::resource("/").to(chirp))
    })
    .bind(addr)?
    .run()
}
