extern crate hyper;
extern crate futures;

mod service;

use std::env;
use std::net::{IpAddr, Ipv4Addr, SocketAddr};

use service::serve;

fn main() {
    let args: Vec<String> = env::args().collect();

    let addr = IpAddr::V4(<Ipv4Addr>::new(0, 0, 0, 0));
    let port = args[1].parse();
    match port {
        Ok(p) => serve(SocketAddr::new(addr, p)),
        Err(e) => {
            println!("Problem parsing arguments: {}", e);
            help();
        },
    };
}

fn help() -> ! {
    let args: Vec<String> = env::args().collect();
    eprintln!("Usage: {} <listen port>", args[0]);
    std::process::exit(1);
}