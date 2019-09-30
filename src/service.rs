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
        (&Method::GET, "status") => {
            // TODO: add additional checking
            *response.body_mut() = Body::from("OK");
            *response.status_mut() = StatusCode::OK;
        }
        (&Method::GET, "key") => {
            let resp = match parts[2].parse() {
                Ok(n) => {
                    *response.status_mut() = StatusCode::OK;
                    rand_base64_data(n)
                }
                Err(e) => {
                    *response.status_mut() = StatusCode::INTERNAL_SERVER_ERROR;
                    eprintln!("Unable to parse length: {}", e);
                    String::from("Unable to parse length")
                }
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

fn get_rand(length: usize) -> Vec<u8> {
    thread_rng().sample_iter(Standard).take(length).collect()
}

fn rand_base64_data(length: usize) -> String {
    base64::encode(&get_rand(length))
}

#[cfg(test)]
mod test {
    use super::*;

    // Not really our function but let's test it anyways
    #[test]
    fn test_encode() {
        assert_eq!(base64::encode("asdf"), "YXNkZg==");
        assert_eq!(base64::encode("1234"), "MTIzNA==");
        assert_eq!(base64::encode(")(*&"), "KSgqJg==");
    }

    #[test]
    fn test_get_rand() {
        // Check returned length
        assert_eq!(get_rand(5).len(), 5);
        assert_eq!(get_rand(8).len(), 8);
        assert_eq!(get_rand(10).len(), 10);

        // Very dumb test for randomness
        assert_ne!(get_rand(5), get_rand(5));
    }

    #[test]
    fn test_rand_base64_data() {
        // Check base64 encoded length
        assert_eq!(rand_base64_data(5).len(), 8);
        assert_eq!(rand_base64_data(8).len(), 12);
        assert_eq!(rand_base64_data(10).len(), 16);
    }

    #[test]
    fn test_decode_rand_base64_data() {
        // Check if we can decode the result
        base64::decode(&rand_base64_data(5)).unwrap();
        base64::decode(&rand_base64_data(8)).unwrap();
        base64::decode(&rand_base64_data(10)).unwrap();
    }
}