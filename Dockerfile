ARG VERSION=1.5.0

FROM rust:1.88-alpine AS builder

ARG VERSION

WORKDIR /app

RUN apk add --no-cache git musl-dev openssl-dev openssl-libs-static sqlite-dev sqlite-static
RUN git clone https://gitlab.torproject.org/tpo/core/arti.git .
RUN git checkout arti-v${VERSION}
RUN cargo build --release --features=onion-service-service

FROM alpine:latest AS runner

ARG VERSION

LABEL maintainer="artur@magicgrants.org" \
      version=${VERSION} \
      org.opencontainers.image.source="https://github.com/MAGICGrants/arti-docker"

COPY --from=builder /app/target/release/arti /usr/local/bin/

RUN apk add --no-cache shadow curl
RUN useradd -m arti

WORKDIR /home/arti

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

USER arti

ENTRYPOINT ["./entrypoint.sh"]
CMD ["arti", "proxy"]
