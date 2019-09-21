FROM rust:1.37
ENV PORT=8080

WORKDIR /usr/src/myapp
COPY . .

RUN cargo install --path .

EXPOSE ${PORT}
CMD randrust ${PORT}