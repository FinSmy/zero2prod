FROM rust:alpine AS builder
WORKDIR /app
COPY . .
RUN apk add pkgconfig openssl-dev libc-dev
ENV SQLX_OFFLINE true
RUN cargo build --release

FROM rust:alpine AS runtime
WORKDIR /app
RUN apk update \
    && apk add openssl ca-certificates
COPY --from=builder /app/target/release/zero2prod zero2prod
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT ["./zero2prod"]

# FROM alpine AS runtime
# WORKDIR /app
# COPY --from=builder /app/target/release/zero2prod zero2prod
# COPY configuration configuration
# ENV APP_ENVIRONMENT=production
# ENTRYPOINT ["./zero2prod"]
