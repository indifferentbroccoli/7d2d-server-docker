FROM --platform=linux/amd64 debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    unzip \
    procps \
    libicu-dev \
    xmlstarlet \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG DEPOT_DOWNLOADER_VERSION=3.4.0
RUN curl -sL "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_${DEPOT_DOWNLOADER_VERSION}/DepotDownloader-linux-x64.zip" -o /tmp/dd.zip && \
    mkdir -p /depotdownloader && \
    unzip /tmp/dd.zip -d /depotdownloader && \
    chmod +x /depotdownloader/DepotDownloader && \
    rm /tmp/dd.zip

RUN useradd -m -s /bin/bash steam

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/7d2d-server-docker" \
      github="https://github.com/indifferentbroccoli/7d2d-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/7d2d-server-docker"

ENV HOME=/home/steam \
    PUID=1000 \
    PGID=1000 \
    GENERATE_SETTINGS=true \
    FORCE_UPDATE=false \
    GAME_VERSION="" \
    TELNET_ENABLED=true \
    WEB_DASHBOARD_ENABLED=true \
    ENABLE_MAP_RENDERING=true

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /7d2d && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
    CMD pgrep -f "7DaysToDieServer" > /dev/null || exit 1

EXPOSE 26900/tcp 26900/udp 26901/udp 26902/udp 8080/tcp 8081/tcp

ENTRYPOINT ["/home/steam/server/init.sh"]
