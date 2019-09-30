extern crate hyper;
extern crate futures;

mod service;

use std;
use std::net::{IpAddr, Ipv4Addr, SocketAddr};

use service::serve;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if  args.len() < 2 || args.len() > 3  {
        help()
    }

    let addr: std::net::IpAddr;

    if args.len() == 3 {
        addr = match args[2].parse::<std::net::IpAddr>() {
            Ok(l) => l,
            Err(e) => {
                println!("Problem parsing arguments: {}", e);
                help();
            }
        }
    } else {
        addr = IpAddr::V4(<Ipv4Addr>::new(127, 0, 0, 1));
    }

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
    let args: Vec<String> = std::env::args().collect();
    eprintln!("Usage: {} listen_port [bind_address]", args[0]);
    std::process::exit(1);
}