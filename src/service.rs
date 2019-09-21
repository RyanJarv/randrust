extern crate hyper;
extern crate futures;
extern crate rand;
extern crate base64;

use std::net::SocketAddr;
use std::iter::Iterator;

use hyper::{Body, Request, Response, Server, Method, StatusCode};
use hyper::service::service_fn;
use hyper::rt::Future;
use futures::future;

use rand::{thread_rng, Rng};
use rand::distributions::Standard;

use base64::{encode};


type BoxFut = Box<dyn Future<Item=Response<Body>, Error=hyper::Error> + Send>;

pub fn serve(listen: SocketAddr) {
    let new_svc = || service_fn(router);
    let server = Server::bind(&listen)
        .serve(new_svc)
        .map_err(|e| eprintln!("server error: {}", e));

    hyper::rt::run(server);
}

fn router(req: Request<Body>) -> BoxFut {
    let mut response = Response::new(Body::empty());

    let parts: Vec<_> = req.uri().path().split("/").collect();

    match (req.method(), parts[1]) {
        (&Method::GET, "key") => {
            let resp = match parts[2].parse() {
                Ok(n) => rand_base64_data(n),
                Err(e) => panic!(e), // TODO: don't panic
            };
            *response.body_mut() = Body::from(resp);
        }
        _ => {
            *response.body_mut() = Body::from("Please use the `/key/<length>` endpoint\n");
            *response.status_mut() = StatusCode::NOT_FOUND;
        }
    }

    Box::new(future::ok(response))
}

fn rand_base64_data(length: usize) -> String {
    let data: Vec<u8> = thread_rng().sample_iter(Standard).take(length).collect();
    return encode(&data)
}