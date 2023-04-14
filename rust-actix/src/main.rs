use std::{env, time::SystemTime};

use actix_web::{
    dev::Service as _, error::ErrorUnauthorized, middleware, post, web, App, Error, HttpResponse,
    HttpServer,
};
use serde::{Deserialize, Serialize};

#[derive(Deserialize)]
struct LoginReqDto {
    email: String,
    password: String,
}
#[derive(Serialize)]
struct LoginResDto {
    username: String,
    role: String,
}

#[post("/")]
async fn login(data: web::Json<LoginReqDto>) -> Result<HttpResponse, Error> {
    if data.email != "hanutsingh@gmail.com" || data.password != "qweasd@123" {
        return Err(ErrorUnauthorized("Unauthorized"));
    }
    let res_data = LoginResDto {
        username: String::from("asdasd"),
        role: String::from("super admin"),
    };
    Ok(HttpResponse::Ok().json(res_data))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env::set_var("RUST_LOG", "actix_web=debug,actix_server=info");

    HttpServer::new(|| {
        App::new()
            .wrap_fn(|req, srv| {
                println!("{} {} {}", timestamp(), req.method(), req.path());
                srv.call(req)
            })
            .wrap(middleware::Logger::default())
            .service(web::resource("/"))
    })
    .bind(("localhost", 3004))?
    .run()
    .await
}

fn timestamp() -> String {
    match SystemTime::now().duration_since(SystemTime::UNIX_EPOCH) {
        Ok(n) => format!("{}", n.as_millis()),
        Err(_) => panic!("The system time seems wonky. its before the unix epoch !"),
    }
}
