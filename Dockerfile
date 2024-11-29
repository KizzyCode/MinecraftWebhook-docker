# Build the daemon
FROM debian:bookworm-slim AS buildenv

ENV APT_PACKAGES="build-essential ca-certificates curl git"
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends ${APT_PACKAGES}

RUN curl --tlsv1.3 --output rustup.sh https://sh.rustup.rs \
    && sh rustup.sh -y --profile=minimal

RUN git clone https://github.com/KizzyCode/MinecraftWebhook-rust \
    && /root/.cargo/bin/cargo install --path MinecraftWebhook-rust --bins minecraft-webhook


# Build the real container
FROM debian:bookworm-slim

COPY --from=buildenv /root/.cargo/bin/minecraft-webhook /usr/local/bin/minecraft-webhook

RUN adduser --system --shell=/bin/nologin --uid=1000 minecraft-webhook
USER minecraft-webhook

WORKDIR /etc/minecraft-webhook
CMD [ "/usr/local/bin/minecraft-webhook" ]
