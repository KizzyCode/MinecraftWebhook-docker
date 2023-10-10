# Build the daemon
FROM alpine:latest AS buildenv

RUN apk add --no-cache cargo
RUN cargo install --git https://github.com/KizzyCode/MinecraftWebhook-rust


# Build the real container
FROM alpine:latest

RUN apk add --no-cache libgcc
COPY --from=buildenv /root/.cargo/bin/minecraft-webhook /usr/local/bin/minecraft-webhook

RUN adduser -S -H -D -u 1000 -s /sbin/nologin minecraft-webhook
USER minecraft-webhook

WORKDIR /etc/minecraft-webhook
CMD [ "/usr/local/bin/minecraft-webhook" ]
