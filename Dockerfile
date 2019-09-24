FROM rust:1.37.0-alpine3.10 as builder

WORKDIR /usr/src/myapp
COPY src src
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock
RUN cargo install --path .


FROM alpine:3.10

COPY --from=builder /usr/local/cargo/bin/ /usr/local/cargo/bin/
ENV PORT=80
EXPOSE ${PORT}

CMD /usr/local/cargo/bin/randrust ${PORT}
