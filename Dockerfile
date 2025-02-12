
FROM rust:1.84-alpine AS builder

WORKDIR /app

COPY ./arti/Cargo.toml ./arti/Cargo.lock ./
COPY ./arti/ .

RUN apk add --no-cache musl-dev openssl-dev openssl-libs-static sqlite-dev sqlite-static
RUN cargo build --release

FROM alpine:latest AS runner

COPY --from=builder /app/target/release/arti /usr/local/bin/

RUN apk add --no-cache shadow
RUN useradd -m arti
WORKDIR /home/arti
USER arti

COPY arti.toml .config/arti/arti.toml

LABEL maintainer="artur@magicgrants.org" \
      version="1.4.0" \
      org.opencontainers.image.source="https://github.com/MAGICGrants/arti-docker"

CMD ["arti", "proxy"]
