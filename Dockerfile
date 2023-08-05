# Build the daemon
FROM ghcr.io/kizzycode/buildbase-rust:alpine AS buildenv

RUN mv /root/.cargo /root/.cargo-persistent
RUN --mount=type=tmpfs,target=/root/.cargo \
    cp -a /root/.cargo-persistent/. /root/.cargo \
    && cargo install --git https://github.com/KizzyCode/MinecraftWebhook-rust \
    && cp /root/.cargo/bin/minecraft-webhook /root/minecraft-webhook


# Build the real container
FROM alpine:latest

RUN apk add --no-cache libgcc
COPY --from=buildenv /root/minecraft-webhook /usr/local/bin/minecraft-webhook

RUN adduser -S -H -D -u 1000 -s /sbin/nologin minecraft-webhook
USER minecraft-webhook

WORKDIR /etc/minecraft-webhook
CMD [ "/usr/local/bin/minecraft-webhook" ]
